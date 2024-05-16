import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';
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
  late TextEditingController startDateController =
      TextEditingController(text: formatDate(DateTime.now()));
  late TextEditingController endDateController =
      TextEditingController(text: formatDate(DateTime.now()));
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  String formatDate(DateTime dateTime) {
    return dateTime.toString().substring(0, 16);
  }

  Future<DateTime?> selectDateTime(BuildContext context) async {
    return await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      isForce2Digits: true,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
  }

  void sendInvitation() async {
    final data = {
      'email': emailController.text.toString(),
      'type': selectedType,
      if (selectedType == 'guest') 'start_date': startDateController.text,
      if (selectedType == 'guest') 'end_date': endDateController.text,
    };

    logger.i(data);
    final result = await API(context: context)
        .sendRequest(route: '/invite', method: 'post', data: data);
    final response = jsonDecode(result.body);

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
        child: SizedBox(
          height: screenHeight(context),
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
                  right: screenWidth(context) * 0.05),
              margin: EdgeInsets.only(top: screenHeight(context) * 0.14),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(children: [
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
                    SizedBox(height: screenHeight(context) * 0.07),
                    selectedType == 'family_member'
                        ? SizedBox(height: 0)
                        : Column(children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    onTap: () async {
                                      DateTime? picked =
                                          await selectDateTime(context);
                                      if (picked != null) {
                                        startDateController.text =
                                            formatDate(picked);
                                      }
                                    },
                                    readOnly: true,
                                    controller: startDateController,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade700),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      prefixIcon: Icon(
                                        Icons.calendar_today,
                                        color: primaryColor,
                                        size: 17,
                                      ),
                                      labelText: 'Start Date',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    onTap: () async {
                                      DateTime? picked =
                                          await selectDateTime(context);
                                      if (picked != null) {
                                        endDateController.text =
                                            formatDate(picked);
                                      }
                                    },
                                    readOnly: true,
                                    controller: endDateController,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade700),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      prefixIcon: Icon(
                                        Icons.calendar_today,
                                        color: primaryColor,
                                        size: 17,
                                      ),
                                      labelText: 'End Date',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight(context) * 0.09),
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
      ),
    );
  }
}
