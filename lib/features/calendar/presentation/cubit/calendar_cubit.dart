import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_system/core/usecases/usecase.dart';
import '../../domain/entities/event.dart';
import '../../domain/usecases/get_events.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final GetEvents getEvents;

  CalendarCubit({required this.getEvents}) : super(CalendarInitial());

  Future<void> loadEvents() async {
    emit(CalendarLoading());
    final result = await getEvents(NoParams());
    result.fold(
      (failure) {
        if (!isClosed) emit(CalendarError(failure.message));
      },
      (eventList) {
        if (!isClosed) {
          final eventsMap = _groupEventsByDate(eventList);
          emit(CalendarLoaded(eventsMap));
        }
      },
    );
  }

  Map<DateTime, List<Event>> _groupEventsByDate(List<Event> events) {
    Map<DateTime, List<Event>> data = {};
    for (var event in events) {
      // Normalize date to remove time part for map key
      final date = DateTime(event.date.year, event.date.month, event.date.day);
      if (data[date] == null) data[date] = [];
      data[date]!.add(event);
    }
    return data;
  }
}
