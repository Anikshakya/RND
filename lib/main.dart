import 'package:flutter/material.dart';
import 'package:rnd/src/services/connectivity_service.dart';
import 'package:rnd/src/view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    // Check Internet Connectivity
    ConnectivityService().checkConnectivityPeriodically();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RND',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey, // Set the global key here
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
