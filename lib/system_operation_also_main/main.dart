import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './providers/ald_system_provider.dart';
import './providers/recipe_provider.dart';
import './providers/alarm_provider.dart';
import './models/recipe_state.dart';
import './screens/main_dashboard.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ALDSystemProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => AlarmProvider()),
        ChangeNotifierProvider(create: (_) => RecipeState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALD Process Monitor',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        hintColor: Colors.blueAccent,
        scaffoldBackgroundColor: Color(0xFF121212),
        cardColor: Color(0xFF1E1E1E),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white70),
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xFF1E1E1E), systemOverlayStyle: SystemUiOverlayStyle.light, toolbarTextStyle: TextTheme(
            titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ).bodyMedium, titleTextStyle: TextTheme(
            titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ).titleLarge,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: TextStyle(fontSize: 16.0),
          unselectedLabelStyle: TextStyle(fontSize: 16.0),
        ),
      ),
      home: MainDashboard(),
    );
  }
}