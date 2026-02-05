import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/bathroom_repository.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/bathroom_entry_model.dart';
import 'bathroom_state.dart';

class BathroomCubit extends Cubit<BathroomState> {
  final BathroomRepository bathroomRepository;
  final AuthRepository authRepository;

  StreamSubscription? _queueSubscription;
  StreamSubscription? _statusSubscription;

  List<BathroomEntryModel> _currentQueue = [];
  bool _currentIsOccupied = false;
  UserModel? _currentUser; // Me

  BathroomCubit({
    required this.bathroomRepository,
    required this.authRepository,
  }) : super(BathroomInitial()) {
    _init();
  }

  void _init() async {
    // 1. Load sync data immediately
    try {
      _currentQueue = bathroomRepository.currentQueue;
      _currentIsOccupied = bathroomRepository.isOccupied;

      // Emit immediately so user sees UI
      _emitUpdatedState();
    } catch (e) {
      // If sync getters fail (shouldn't happen), emit error
      emit(BathroomError("Failed to load initial data: $e"));
      return;
    }

    // 2. Load async data (User)
    try {
      _currentUser = await authRepository.getCurrentUser();
      // Update state with user info
      _emitUpdatedState();
    } catch (e) {
      // If auth fails, we just continue as "anonymous" or show error?
      // For now, continue but maybe log
      print("Error fetching user: $e");
    }

    // 3. Listen to streams
    _queueSubscription = bathroomRepository.getQueue().listen((queue) {
      _currentQueue = queue;
      _emitUpdatedState();
    });

    _statusSubscription = bathroomRepository.isOccupiedStream().listen((
      isOccupied,
    ) {
      _currentIsOccupied = isOccupied;
      _emitUpdatedState();
    });
  }

  void _emitUpdatedState() {
    final currentUserInBathroom = bathroomRepository.getCurrentUser();

    final isMeInQueue =
        _currentUser != null &&
        _currentQueue.any((e) => e.user.id == _currentUser!.id);

    final isMeInBathroom =
        _currentUser != null && currentUserInBathroom?.id == _currentUser!.id;

    emit(
      BathroomStatusLoaded(
        queue: _currentQueue,
        isOccupied: _currentIsOccupied,
        currentUserInBathroom: currentUserInBathroom,
        isMeInQueue: isMeInQueue,
        isMeInBathroom: isMeInBathroom,
      ),
    );
  }

  Future<void> requestEntry() async {
    if (_currentUser == null) {
      // If we don't have a user, we can't join.
      // Ideally show a message, for now try to fetch again or just fail.
      _currentUser = await authRepository.getCurrentUser();
      if (_currentUser == null) {
        emit(const BathroomError("You must be logged in to use this feature"));
        _emitUpdatedState(); // Revert to loaded after error?
        // Actually emit Error replaces Loaded. UI needs to handle "Error -> Loaded" or show Snackbar.
        // Simpler: Just don't do anything if null
        return;
      }
    }

    try {
      if (_currentIsOccupied) {
        // Join queue
        await bathroomRepository.joinQueue(_currentUser!);
      } else {
        // Enter immediately
        await bathroomRepository.enterBathroom(_currentUser!);
      }
    } catch (e) {
      emit(BathroomError(e.toString()));
      _emitUpdatedState();
    }
  }

  Future<void> leave() async {
    if (_currentUser == null) return;
    try {
      final state = this.state;
      if (state is BathroomStatusLoaded) {
        if (state.isMeInBathroom) {
          await bathroomRepository.finishBathroom();
        } else if (state.isMeInQueue) {
          await bathroomRepository.leaveQueue(_currentUser!);
        }
      }
    } catch (e) {
      emit(BathroomError(e.toString()));
      _emitUpdatedState();
    }
  }

  @override
  Future<void> close() {
    _queueSubscription?.cancel();
    _statusSubscription?.cancel();
    return super.close();
  }
}
