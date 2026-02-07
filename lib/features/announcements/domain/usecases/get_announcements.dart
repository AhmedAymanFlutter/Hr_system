import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

class GetAnnouncements
    implements UseCase<Either<Failure, List<Announcement>>, NoParams> {
  final AnnouncementRepository repository;

  GetAnnouncements(this.repository);

  @override
  Future<Either<Failure, List<Announcement>>> call(NoParams params) async {
    return await repository.getAnnouncements();
  }
}
