
import 'package:flutter/material.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  // Weekdays
  final List<String> weekdays = ['SUN', 'MON', 'TUES', 'WED', 'THU', 'FRI', 'SAT'];

  // Days in the month (example June 2025, change as needed)
  final List<int?> days = List.generate(30, (index) => index + 1);

  DateTime? _selectedDate;

  // Records associated with certain dates
  final Map<DateTime, List<String>> recordsByDate = {
    DateTime(2025, 6, 6): ['Meeting at 10 AM', 'Doctor Appointment'],
    DateTime(2025, 6, 7): ['Lunch with friends'],
    // Add more date-record pairs here
  };

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<String>? getRecordsForSelectedDate() {
    if (_selectedDate == null) return null;

    for (var entry in recordsByDate.entries) {
      if (isSameDate(entry.key, _selectedDate!)) {
        return entry.value;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Weekday Headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekdays.map((day) {
            return Expanded(
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: day == 'FRI' ? Colors.black : Colors.grey[600],
                  fontSize: 16.0,
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 10),

        // Dates grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final dayNumber = days[index];
            final currentIterationDate = DateTime(2025, 6, dayNumber!);
            final isSelected = _selectedDate != null &&
                isSameDate(_selectedDate!, currentIterationDate);

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = currentIterationDate;
                });
                print('Selected date: ${currentIterationDate.day}');
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 1.0,
                  ),
                ),
                child: Text(
                  dayNumber.toString(),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: dayNumber == 6 && weekdays[index] == 'FRI'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: dayNumber != null ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Records display section
        _selectedDate == null
            ? const Text('Select a date to see records')
            : Builder(builder: (_) {
          final records = getRecordsForSelectedDate();
          if (records == null || records.isEmpty) {
            return const Text('No record');
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.event_note),
                title: Text(records[index]),
              );
            },
          );
        }),
      ],
    );
  }
}
