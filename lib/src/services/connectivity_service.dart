import 'dart:io';
import 'package:flutter/material.dart';

// To Show Snack Bar on Connectivity Change
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class ConnectivityService {
  // Continous Connectivity Check
  checkConnectivityPeriodically() async {
    while (true) {
      await checkConnectivity();
      await Future.delayed(const Duration(seconds: 2)); // Check every 2 seconds
    }
  }

  // Check For Internet Connectivity
  checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      var isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      if(isConnected){
        // Close the SnackBar if connected
        scaffoldMessengerKey.currentState?.clearSnackBars();
      } else {
         // Show SnackBar if not connected
        _showSnackBar('You are offline');
      }
    } catch (e) {
       // Show SnackBar if not connected
      _showSnackBar('You are offline');
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(days: 1000000),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          scaffoldMessengerKey.currentState?.clearSnackBars();
        },
      ),
    );

    // Show the SnackBar using the global key
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
