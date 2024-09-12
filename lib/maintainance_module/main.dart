// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/maintenance_provider.dart';
import 'providers/calibration_provider.dart';
import 'providers/ald_system_provider.dart';
import 'providers/spare_parts_provider.dart';
import 'providers/report_provider.dart';
import 'screens/maintenance_home_screen.dart';
import 'screens/calibration_screen.dart';
import 'screens/troubleshooting_screen.dart';
import 'screens/spare_parts_screen.dart';
import 'screens/documentation_screen.dart';
import 'screens/reporting_screen.dart';
import 'screens/remote_assistance_screen.dart';
import 'screens/safety_procedures_screen.dart';
import 'widgets/app_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => MaintenanceProvider()),
        ChangeNotifierProvider(create: (ctx) => CalibrationProvider()),
        ChangeNotifierProvider(create: (ctx) => ALDSystemProvider()),
        ChangeNotifierProvider(create: (ctx) => SparePartsProvider()),
        ChangeNotifierProxyProvider2<MaintenanceProvider, CalibrationProvider, ReportProvider>(
          create: (ctx) => ReportProvider(
            Provider.of<MaintenanceProvider>(ctx, listen: false),
            Provider.of<CalibrationProvider>(ctx, listen: false),
          ),
          update: (ctx, maintenance, calibration, previous) =>
              ReportProvider(maintenance, calibration),
        ),
      ],
      child: MaterialApp(
        title: 'ALD Machine Maintenance',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey[800],
          scaffoldBackgroundColor: Colors.grey[900],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey[900],
            elevation: 0,
          ),
          cardTheme: CardTheme(
            color: Colors.blueGrey[800],
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(color: Colors.white70),
            bodyMedium: TextStyle(color: Colors.white60),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        home: MainScreen(),
        routes: {
          '/maintenance': (ctx) => MaintenanceHomeScreen(),
          '/calibration': (ctx) => CalibrationScreen(),
          '/troubleshooting': (ctx) => TroubleshootingScreen(),
          '/spare_parts': (ctx) => SparePartsScreen(),
          '/documentation': (ctx) => DocumentationScreen(),
          '/reporting': (ctx) => ReportingScreen(),
          '/remote_assistance': (ctx) => RemoteAssistanceScreen(),
          '/safety_procedures': (ctx) => SafetyProceduresScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ALD Machine Maintenance'),
      ),
      body: MaintenanceHomeScreen(),
    );
  }
}