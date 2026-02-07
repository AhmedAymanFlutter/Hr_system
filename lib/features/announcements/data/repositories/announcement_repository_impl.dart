import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../datasources/announcement_remote_data_source.dart';
import '../models/announcement_model.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;

  AnnouncementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Announcement>>> getAnnouncements() async {
    try {
      final announcements = await remoteDataSource.getAnnouncements();
      return Right<Failure, List<Announcement>>(announcements);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Announcement>> createAnnouncement(
    Announcement announcement,
  ) async {
    try {
      final announcementModel = AnnouncementModel(
        id: announcement.id,
        title: announcement.title,
        content: announcement.content,
        date: announcement.date,
        author: announcement.author,
      );
      final createdAnnouncement = await remoteDataSource.createAnnouncement(
        announcementModel,
      );
      return Right<Failure, Announcement>(createdAnnouncement);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
