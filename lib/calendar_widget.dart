import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'your plants/plants_constants.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

Map<DateTime, List<String>> _wateringEvents = {};

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Future<void> _loadWateringEvents() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('plants')
        .get();

    Map<DateTime, List<String>> events = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final name = data['name'];
      final lastWater = (data['lastWatering'] as Timestamp).toDate();
      final freq = data['frequency'];

      int daysToAdd = getDaysBetweenWaterings(freq);
      DateTime endPeriod = DateTime(lastWater.year, lastWater.month + 3, lastWater.day);
      DateTime nextWater = lastWater;

      while(nextWater.isBefore(endPeriod))
      {
        nextWater = nextWater.add(Duration(days: daysToAdd));

        DateTime dayOnly = DateTime(nextWater.year, nextWater.month, nextWater.day);

        if (!events.containsKey(dayOnly)) {
          events[dayOnly] = [];
        }
        events[dayOnly]!.add(name);
      }
    }

    setState(() {
      _wateringEvents = events;
    });
  }


  @override
  void initState() {
    super.initState();
    _loadWateringEvents();
  }

  List<String> _getEventsForDay(DateTime day) {
    return _wateringEvents[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 189, 221, 214),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 8),
          ..._getEventsForDay(_selectedDay ?? _focusedDay).map(
            (event) => ListTile(
              title: Row(
                children: [
                  Text("It's time to water ", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(event, style: TextStyle(fontWeight: FontWeight.bold),),
                  Image.asset('assets/images/watering_can.png', width: 40,),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }

}