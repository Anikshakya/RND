import 'dart:async';

import 'package:flutter/material.dart';

class CompleterLoadPage extends StatefulWidget {
  const CompleterLoadPage({super.key});

  @override
  State<CompleterLoadPage> createState() => _CompleterLoadPageState();
}

class _CompleterLoadPageState extends State<CompleterLoadPage> {
  final Completer<String> _weatherCompleter = Completer<String>();
  final Completer<String> _newsCompleter = Completer<String>();
  final Completer<String> _stocksCompleter = Completer<String>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate fetching weather data
    Future.delayed(const Duration(seconds: 2), () {
      _weatherCompleter.complete("Weather: Sunny, 25°C");
    });

    // Simulate fetching news data
    Future.delayed(const Duration(seconds: 3), () {
      _newsCompleter.complete("News: Flutter 3.0 Released!");
    });

    // Simulate fetching stock data
    Future.delayed(const Duration(seconds: 1), () {
      _stocksCompleter.complete("Stocks: ABC Inc. +5%");
    });

    // Wait for all data to load
    await Future.wait([
      _weatherCompleter.future,
      _newsCompleter.future,
      _stocksCompleter.future,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Data Using Completer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<String>(
            future: _weatherCompleter.future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingTile('Loading Weather...');
              } else if (snapshot.hasError) {
                return _buildErrorTile('Error loading weather');
              } else {
                return _buildDataTile('Weather', snapshot.data);
              }
            },
          ),
          FutureBuilder<String>(
            future: _newsCompleter.future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingTile('Loading News...');
              } else if (snapshot.hasError) {
                return _buildErrorTile('Error loading news');
              } else {
                return _buildDataTile('News', snapshot.data);
              }
            },
          ),
          FutureBuilder<String>(
            future: _stocksCompleter.future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingTile('Loading Stocks...');
              } else if (snapshot.hasError) {
                return _buildErrorTile('Error loading stocks');
              } else {
                return _buildDataTile('Stocks', snapshot.data);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingTile(String title) {
    return ListTile(
      leading: const CircularProgressIndicator(),
      title: Text(title),
    );
  }

  Widget _buildErrorTile(String title) {
    return ListTile(
      leading: const Icon(Icons.error, color: Colors.red),
      title: Text(title),
    );
  }

  Widget _buildDataTile(String title, String? data) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.green),
      title: Text(title),
      subtitle: Text(data ?? ''),
    );
  }
}