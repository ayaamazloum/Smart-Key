import 'package:flutter/material.dart';
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
  String selectedType = invitationTypes[0];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final logger = Logger();

  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now();

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

  void sendInvitation() {}

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
          Container(
            padding: EdgeInsets.only(
                left: screenWidth(context) * 0.05,
                right: screenWidth(context) * 0.05,
                top: screenHeight(context) * 0.04),
            child: Form(
              key: _formKey,
              child: ListView(children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Invite a member',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
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
                SizedBox(height: screenHeight(context) * 0.005),
                Row(
                  children: [
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
                MyTextField(
                    labelText: 'E-mail',
                    hintText: 'example@example.com',
                    controller: _emailController,
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
                    if (_formKey.currentState!.validate()) {
                      sendInvitation();
                    }
                  },
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
