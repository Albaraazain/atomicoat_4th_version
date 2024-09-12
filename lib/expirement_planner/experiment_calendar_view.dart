import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'experiment_model.dart';
import 'experiment_detail_page.dart';

class ExperimentCalendarView extends StatefulWidget {
  @override
  _ExperimentCalendarViewState createState() => _ExperimentCalendarViewState();
}

class _ExperimentCalendarViewState extends State<ExperimentCalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<ExperimentModel>(
        builder: (context, experimentModel, child) {
          return Column(
            children: [
              TableCalendar<Experiment>(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
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
                eventLoader: (day) {
                  return experimentModel.getExperimentsByDateRange(
                    day,
                    day.add(Duration(days: 1)),
                  );
                },
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: _buildEventList(experimentModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEventList(ExperimentModel model) {
    if (_selectedDay == null) {
      return Center(child: Text('Please select a day'));
    }

    final experiments = model.getExperimentsByDateRange(
      _selectedDay!,
      _selectedDay!.add(Duration(days: 1)),
    );

    if (experiments.isEmpty) {
      return Center(child: Text('No experiments on this day'));
    }

    return ListView.builder(
      itemCount: experiments.length,
      itemBuilder: (context, index) {
        final experiment = experiments[index];
        return ListTile(
          title: Text(experiment.name),
          subtitle: Text('${_formatTime(experiment.startTime)} - ${_formatTime(experiment.endTime)}'),
          onTap: () => _navigateToExperimentDetail(context, experiment.id),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToExperimentDetail(BuildContext context, String experimentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExperimentDetailPage(experimentId: experimentId),
      ),
    );
  }
}