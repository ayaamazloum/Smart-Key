import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:logger/logger.dart';
import 'package:smart_key/utils/input_methods.dart';
import 'package:smart_key/widgets/primary_button.dart';
import 'package:smart_key/widgets/text_field.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

List<String> invitationTypes = ['family_member', 'guest'];

class _InviteScreenState extends State<InviteScreen> {
  late SharedPreferences preferences;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  String selectedType = invitationTypes[0];

  final logger = Logger();

  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != startDate) {
      setState(() {
        startDate = pickedDate;
      });
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (pickedTime != null && pickedTime != startTime) {
      setState(() {
        startTime = pickedTime;
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != endDate) {
      setState(() {
        endDate = pickedDate;
      });
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (pickedTime != null && pickedTime != endTime) {
      setState(() {
        endTime = pickedTime;
      });
    }
  }

  void sendInvitation() async {
    final data = {
      'email': emailController.text.toString(),
      'type': selectedType,
      if (selectedType == 'guest')
        'start_date':
            '${startDate.toString().substring(0, 10)} ${startTime.toString().substring(10, 15)}:00',
      if (selectedType == 'guest')
        'end_date':
            '${endDate.toString().substring(0, 10)} ${endTime.toString().substring(10, 15)}:00',
    };

    final result = await API(context: context)
        .sendRequest(route: '/invite', method: 'post', data: data);
    final response = jsonDecode(result.body);
    logger.i(response);

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            'Invitation sent successfully.',
            style: TextStyle(fontSize: 12, color: primaryColor),
          ),
          backgroundColor: Colors.grey.shade200,
          elevation: 30,
        ),
      );
    } else {
      final errorMessage = response['message'];
      ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
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
              left: (screenWidth(context) - screenWidth(context) * 0.45) / 2,
              child: Text('Invite Member',
                  style: Theme.of(context).textTheme.headlineLarge)),
          Container(
            padding: EdgeInsets.only(
                left: screenWidth(context) * 0.05,
                right: screenWidth(context) * 0.05,
                top: screenHeight(context) * 0.04),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: screenHeight(context) * 0.05),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Family member',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    leading: Radio(
                      value: invitationTypes[0],
                      groupValue: selectedType,
                      onChanged: (value) {
                        setState(() {
                          selectedType = value.toString();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(-100),
                    title: Text(
                      'Guest',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    leading: Radio(
                      value: invitationTypes[1],
                      groupValue: selectedType,
                      onChanged: (value) {
                        setState(() {
                          selectedType = value.toString();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight(context) * 0.03),
                  selectedType == 'family_member'
                      ? SizedBox(height: 0)
                      : Column(children: [
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => selectStartDate(context),
                                child: Text('Start Date'),
                              ),
                              SizedBox(width: screenWidth(context) * 0.05),
                              Text(
                                startDate.toString().substring(0, 10),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(height: screenHeight(context) * 0.005),
                              ElevatedButton(
                                onPressed: () => selectStartTime(context),
                                child: Text('Start Time'),
                              ),
                              SizedBox(width: screenWidth(context) * 0.05),
                              Text(
                                startTime.toString().substring(10, 15),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight(context) * 0.005),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => selectEndDate(context),
                                child: Text('End Date'),
                              ),
                              SizedBox(width: screenWidth(context) * 0.05),
                              Text(
                                endDate.toString().substring(0, 10),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight(context) * 0.005),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => selectEndTime(context),
                                child: Text('End Time'),
                              ),
                              SizedBox(width: screenWidth(context) * 0.05),
                              Text(
                                endTime.toString().substring(10, 15),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight(context) * 0.05),
                        ]),
                  MyTextField(
                      labelText: 'E-mail',
                      hintText: 'example@example.com',
                      controller: emailController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.isValidEmail) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      obscureText: false,
                      textInputType: TextInputType.emailAddress),
                  SizedBox(height: screenHeight(context) * 0.05),
                  PrimaryButton(
                    text: 'Invite',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        sendInvitation();
                      }
                    },
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
