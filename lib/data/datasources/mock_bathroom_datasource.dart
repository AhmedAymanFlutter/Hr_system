import 'dart:async';
import '../models/bathroom_entry_model.dart';
import '../models/user_model.dart';

class MockBathroomDataSource {
  final _queueController =
      StreamController<List<BathroomEntryModel>>.broadcast();
  final _statusController =
      StreamController<bool>.broadcast(); // true = occupied

  List<BathroomEntryModel> _queue = [];
  bool _isOccupied = false;
  UserModel? _currentUser;

  MockBathroomDataSource() {
    // No need to emit in constructor for broadcast stream
  }

  // Getters for initial state
  List<BathroomEntryModel> get queue => List.unmodifiable(_queue);
  bool get isOccupied => _isOccupied;

  Stream<List<BathroomEntryModel>> get queueStream => _queueController.stream;
  Stream<bool> get isOccupiedStream => _statusController.stream;
  UserModel? get currentUser => _currentUser;

  void _emitQueue() {
    _queueController.add(List.unmodifiable(_queue));
  }

  void _emitStatus() {
    _statusController.add(_isOccupied);
  }

  Future<void> joinQueue(UserModel user) async {
    // Prevent duplicates
    if (_queue.any((element) => element.user.id == user.id)) return;

    _queue.add(BathroomEntryModel.fromUser(user));
    _emitQueue();
  }

  Future<void> leaveQueue(UserModel user) async {
    _queue.removeWhere((element) => element.user.id == user.id);
    _emitQueue();
  }

  Future<void> enterBathroom(UserModel user) async {
    if (_isOccupied) {
      throw Exception('Bathroom is already occupied');
    }
    _isOccupied = true;
    _currentUser = user;

    // If user was in queue, remove them
    _queue.removeWhere((element) => element.user.id == user.id);

    _emitStatus();
    _emitQueue();
  }

  Future<void> finishBathroom() async {
    _isOccupied = false;
    _currentUser = null;
    _emitStatus();
  }
}
