import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alarm_provider.dart';

class AlarmDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmProvider>(
      builder: (context, alarmProvider, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Active Alarms',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: alarmProvider.activeAlarms.isEmpty
                  ? Center(child: Text('No active alarms'))
                  : ListView.builder(
                itemCount: alarmProvider.activeAlarms.length,
                itemBuilder: (context, index) {
                  final alarm = alarmProvider.activeAlarms[index];
                  return Card(
                    child: ListTile(
                      leading: _getAlarmIcon(alarm.severity),
                      title: Text(alarm.message),
                      subtitle: Text(
                        '${alarm.timestamp.toString().split('.')[0]}',
                      ),
                      trailing: alarm.acknowledged
                          ? Icon(Icons.check, color: Colors.green)
                          : TextButton(
                        child: Text('Acknowledge'),
                        onPressed: () {
                          alarmProvider.acknowledgeAlarm(alarm.id);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getAlarmIcon(AlarmSeverity severity) {
    switch (severity) {
      case AlarmSeverity.info:
        return Icon(Icons.info, color: Colors.blue);
      case AlarmSeverity.warning:
        return Icon(Icons.warning, color: Colors.orange);
      case AlarmSeverity.critical:
        return Icon(Icons.error, color: Colors.red);
    }
  }
}