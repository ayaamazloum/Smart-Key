import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_key/main.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/widgets/log.dart';
import 'package:smart_key/widgets/log_item.dart';
import 'package:logger/logger.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => LogsScreenState();
}

class LogsScreenState extends State<LogsScreen> {
  late TextEditingController dateController;
  List<Log> logs = [];
  final logger = Logger();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(text: formatDate(DateTime.now()));
    setState(() {
      isLoading = true;
    });
    fetchLogs();
  }

  void fetchLogs() async {
    final data = {
      'date': dateController.text.toString(),
    };

    logger.i(data.toString());

    final result = await API(context: navigatorKey.currentContext!)
        .sendRequest(route: '/logs', method: 'post', data: data);
    final response = jsonDecode(result.body);
    logger.i(response);

    setState(() {
      isLoading = false;
    });

    if (response['status'] == 'success') {
      setState(() {
        logs = parseLogs(result.body);
      });
    } else {
      final errorMessage = response['message'];
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 12, color: Colors.red.shade800),
          ),
          backgroundColor: Colors.grey.shade200,
          elevation: 30,
        ),
      );
    }
  }

  List<Log> parseLogs(String responseBody) {
    final parsed = jsonDecode(responseBody)['logs'].cast<Map<String, dynamic>>();
    return parsed.map<Log>((json) => Log.fromJson(json)).toList();
  }

  String formatDate(DateTime dateTime) {
    return dateTime.toString().split(" ")[0];
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != DateTime.now()) {
      dateController.text = formatDate(picked);
      fetchLogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: screenHeight(context),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/screen_shape_2.png',
                  width: screenWidth(context) * 0.35,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: -40,
                right: 0,
                child: Image.asset(
                  'assets/images/screen_shape_3.png',
                  width: screenWidth(context) * 0.35,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: screenHeight(context) * 0.04,
                left: (screenWidth(context) - screenWidth(context) * 0.16) / 2,
                child: Text(
                  'Logs',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 0.05,
                  vertical: screenHeight(context) * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight(context) * 0.09),
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 7,
                          child: TextField(
                            onTap: selectDate,
                            readOnly: true,
                            controller: dateController,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade700),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                color: primaryColor,
                                size: 20,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight(context) * 0.04),
                    Expanded(
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : logs.isEmpty
                              ? Center(child: Text('No logs available.'))
                              : ListView.builder(
                                  itemCount: logs.length,
                                  itemBuilder: (context, index) {
                                    return LogCard(log: logs[index]);
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
