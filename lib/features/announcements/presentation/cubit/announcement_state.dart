import 'package:equatable/equatable.dart';
import '../../domain/entities/announcement.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();

  @override
  List<Object> get props => [];
}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementLoading extends AnnouncementState {}

class AnnouncementLoaded extends AnnouncementState {
  final List<Announcement> announcements;

  const AnnouncementLoaded(this.announcements);

  @override
  List<Object> get props => [announcements];
}

class AnnouncementError extends AnnouncementState {
  final String message;

  const AnnouncementError(this.message);

  @override
  List<Object> get props => [message];
}

class AnnouncementOperationSuccess extends AnnouncementState {
  final String message;

  const AnnouncementOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
