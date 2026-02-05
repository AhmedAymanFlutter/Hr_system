import 'package:equatable/equatable.dart';
import '../../../data/models/bathroom_entry_model.dart';
import '../../../data/models/user_model.dart'; // Needed if we expose current user

abstract class BathroomState extends Equatable {
  const BathroomState();

  @override
  List<Object?> get props => [];
}

class BathroomInitial extends BathroomState {}

class BathroomLoading extends BathroomState {}

class BathroomStatusLoaded extends BathroomState {
  final List<BathroomEntryModel> queue;
  final bool isOccupied;
  final UserModel? currentUserInBathroom;
  final bool isMeInQueue;
  final bool isMeInBathroom;

  const BathroomStatusLoaded({
    required this.queue,
    required this.isOccupied,
    this.currentUserInBathroom,
    this.isMeInQueue = false,
    this.isMeInBathroom = false,
  });

  @override
  List<Object?> get props => [
    queue,
    isOccupied,
    currentUserInBathroom,
    isMeInQueue,
    isMeInBathroom,
  ];
}

class BathroomError extends BathroomState {
  final String message;

  const BathroomError(this.message);

  @override
  List<Object?> get props => [message];
}
