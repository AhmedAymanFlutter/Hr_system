import 'package:equatable/equatable.dart';
import 'user_model.dart';

class BathroomEntryModel extends Equatable {
  final UserModel user;
  final DateTime joinedAt;

  const BathroomEntryModel({required this.user, required this.joinedAt});

  factory BathroomEntryModel.fromUser(UserModel user) {
    return BathroomEntryModel(user: user, joinedAt: DateTime.now());
  }

  @override
  List<Object?> get props => [user, joinedAt];
}
