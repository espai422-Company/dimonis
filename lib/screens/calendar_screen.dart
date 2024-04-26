import 'package:app_dimonis/models/state/gimcama.dart';
import 'package:app_dimonis/providers/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Gimcama>> events = {};

  late final ValueNotifier<List<Gimcama>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  Widget build(BuildContext context) {
    List<Gimcama> gimcanes =
        Provider.of<FireBaseProvider>(context, listen: false)
            .gimcanaProvider
            .gimcanes;

    for (Gimcama gimcama in gimcanes) {
      DateTime startDateNotFormated = DateTime(
        gimcama.start.year,
        gimcama.start.month,
        gimcama.start.day,
      );

      String dateString = '${startDateNotFormated}Z';
      DateTime finalDate = DateTime.parse(dateString);

      events.addAll({
        finalDate: [gimcama]
      });
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Calendari'),
          Text(_focusedDay.toString().split(" ")[0]),
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(3000, 1, 1),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            calendarStyle: const CalendarStyle(outsideDaysVisible: false),
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Flexible(
            child: SizedBox(
              height: double.maxFinite,
              child: ValueListenableBuilder<List<Gimcama>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(value[index].nom),
                          leading: const Icon(Icons.gamepad_outlined),
                          subtitle: Text(
                              '${value[index].start.toString().split(" ")[0]} --> ${value[index].end.toString().split(" ")[0]}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  List<Gimcama> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }
}
