import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SessionPage extends StatefulWidget {
  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  Timer? _timer;
  int _remainingSeconds = 300;
  bool _isRunning = false;
  List<String> _sessionLogs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _startTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() => _isRunning = true);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        _logSession();
        _stopTimer();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() => _remainingSeconds = 300);
  }

  Future<void> _logSession() async {
    final now = DateTime.now();
    final log = "Session at ${now.hour}:${now.minute} on ${now.month}/${now.day}";
    setState(() => _sessionLogs.add(log));
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('sessionLogs', _sessionLogs);
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList('sessionLogs');
    if (logs != null) {
      setState(() => _sessionLogs = logs);
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 80, color: Colors.green),
          Text(_formatTime(_remainingSeconds), style: TextStyle(fontSize: 48)),
          SizedBox(height: 24),
          if (!_isRunning)
            ElevatedButton(onPressed: _startTimer, child: Text('Start'))
          else
            ElevatedButton(onPressed: _pauseTimer, child: Text('Pause')),
          ElevatedButton(onPressed: _resetTimer, child: Text('Reset')),
          SizedBox(height: 40),
          Text('Session Logs:', style: TextStyle(fontSize: 20)),
          ..._sessionLogs.map((log) => Text(log)).toList(),
        ],
      ),
    );
  }
}
