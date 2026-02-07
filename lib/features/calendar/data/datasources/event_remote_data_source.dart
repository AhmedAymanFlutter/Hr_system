import '../models/event_model.dart';
import '../../domain/entities/event.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getEvents();
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  // Mock Data
  final List<EventModel> _events = [
    EventModel(
      id: '1',
      title: 'Company Picnic',
      description: 'Annual company picnic at the park',
      date: DateTime.now().add(const Duration(days: 5)),
      type: EventType.event,
    ),
    EventModel(
      id: '2',
      title: 'New Year',
      description: 'Public Holiday',
      date: DateTime(DateTime.now().year + 1, 1, 1),
      type: EventType.holiday,
    ),
    EventModel(
      id: '3',
      title: 'Sarah\'s Leave',
      description: 'Sick Leave',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: EventType.leave,
    ),
  ];

  @override
  Future<List<EventModel>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _events;
  }
}
