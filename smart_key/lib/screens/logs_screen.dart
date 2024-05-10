import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/widgets/log_item.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => LogsScreenState();
}

class LogsScreenState extends State<LogsScreen> {
  late TextEditingController dateController;
  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(text: _formatDate(DateTime.now()));
  }

  String _formatDate(DateTime dateTime) {
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
      dateController.text = _formatDate(picked);
    }
  }

  List<List<String>> listsData = [
    ['Aya Mazloum opened the door via app', '2025-17-23'],
    ['Aya Mazloum opened the door via app', '2025-17-23'],
    ['Aya Mazloum opened the door via app', '2025-17-23'],
    ['Aya Mazloum opened the door via app', '2025-17-23'],
    ['Aya Mazloum opened the door via app', '2025-17-23'],
  ];

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
                                borderSide: BorderSide(
                                    color: primaryColor),
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
                      child: ListView.builder(
                        itemCount: listsData.length,
                        itemBuilder: (context, index) {
                          return LogCard(listData: listsData[index]);
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
