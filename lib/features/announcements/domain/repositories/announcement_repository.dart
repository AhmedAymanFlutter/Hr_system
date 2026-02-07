import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  Future<Either<Failure, List<Announcement>>> getAnnouncements();
  Future<Either<Failure, Announcement>> createAnnouncement(
    Announcement announcement,
  );
}
