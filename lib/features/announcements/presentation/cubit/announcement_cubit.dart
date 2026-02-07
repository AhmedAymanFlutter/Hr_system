import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/usecases/create_announcement.dart';
import '../../domain/usecases/get_announcements.dart';
import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final GetAnnouncements getAnnouncements;
  final CreateAnnouncement createAnnouncement;

  AnnouncementCubit({
    required this.getAnnouncements,
    required this.createAnnouncement,
  }) : super(AnnouncementInitial());

  Future<void> loadAnnouncements() async {
    emit(AnnouncementLoading());
    final result = await getAnnouncements(NoParams());
    result.fold(
      (failure) {
        if (!isClosed) emit(AnnouncementError(failure.message));
      },
      (announcements) {
        if (!isClosed) emit(AnnouncementLoaded(announcements));
      },
    );
  }

  Future<void> addAnnouncement(Announcement announcement) async {
    emit(AnnouncementLoading());
    final result = await createAnnouncement(
      CreateAnnouncementParams(announcement: announcement),
    );
    result.fold(
      (failure) {
        if (!isClosed) emit(AnnouncementError(failure.message));
      },
      (newAnnouncement) {
        if (!isClosed) {
          emit(
            const AnnouncementOperationSuccess(
              'Announcement created successfully',
            ),
          );
          loadAnnouncements();
        }
      },
    );
  }
}
