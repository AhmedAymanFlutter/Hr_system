import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_data_source.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Event>>> getEvents() async {
    try {
      final events = await remoteDataSource.getEvents();
      return Right(events);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
