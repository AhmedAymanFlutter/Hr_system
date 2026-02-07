import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

class CreateAnnouncement
    implements
        UseCase<Either<Failure, Announcement>, CreateAnnouncementParams> {
  final AnnouncementRepository repository;

  CreateAnnouncement(this.repository);

  @override
  Future<Either<Failure, Announcement>> call(
    CreateAnnouncementParams params,
  ) async {
    return await repository.createAnnouncement(params.announcement);
  }
}

class CreateAnnouncementParams extends Equatable {
  final Announcement announcement;

  const CreateAnnouncementParams({required this.announcement});

  @override
  List<Object> get props => [announcement];
}
