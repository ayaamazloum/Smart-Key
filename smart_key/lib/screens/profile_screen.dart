import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/utils/input_methods.dart';
import 'package:smart_key/widgets/primary_button.dart';
import 'package:smart_key/widgets/profile_image.dart';
import 'package:smart_key/widgets/text_field.dart';
import 'package:logger/logger.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SharedPreferences preferences;

  bool isLoading = false;
  String profilePictureUrl = '';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<dynamic> getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      preferences = await SharedPreferences.getInstance();
      setState(() {
        nameController.text = preferences.getString('name') ?? '';
        emailController.text = preferences.getString('email') ?? '';
        profilePictureUrl = preferences.getString('profilePicture') == null
            ? '$serverImagesUrl/default-profile-picture.jpg'
            : '$serverImagesUrl/${preferences.getString('profilePicture')}';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      logger.e("Error fetching user data: $e");
    }
  }

  void editProfile(BuildContext context) async {
    final data = {
      'name': nameController.text.toString(),
    };

    logger.i(data.toString());

    final result = await API(context: context)
        .sendRequest(route: '/editProfile', method: 'post', data: data);
    final response = jsonDecode(result.body);

    logger.i(response);

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            'Profile info updated successfully.',
            style: TextStyle(fontSize: 12, color: primaryColor),
          ),
          backgroundColor: Colors.grey.shade200,
          elevation: 30,
        ),
      );
      Navigator.pop(formKey.currentContext!);
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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      'assets/images/screen_shape_1.png',
                      width: screenWidth(context) * 0.35,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: screenHeight(context) * 0.04,
                    left: 10,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                      top: screenHeight(context) * 0.04,
                      left:
                          (screenWidth(context) - screenWidth(context) * 0.33) /
                              2,
                      child: Text('Profile',
                          style: Theme.of(context).textTheme.headlineLarge)),
                  Container(
                    padding: EdgeInsets.only(
                      left: screenWidth(context) * 0.05,
                      right: screenWidth(context) * 0.05,
                    ),
                    margin: EdgeInsets.only(top: screenHeight(context) * 0.17),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: screenWidth(context) * 0.23,
                              backgroundImage: NetworkImage(profilePictureUrl),
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.065,
                            ),
                            MyTextField(
                              labelText: 'Full Name',
                              hintText: 'John Doe',
                              controller: nameController,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.isValidName) {
                                  return 'Invalid passcode format';
                                }
                                return null;
                              },
                              obscureText: false,
                              textInputType: TextInputType.name,
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.025,
                            ),
                            MyTextField(
                              labelText: 'E-mail',
                              hintText: 'example@example.com',
                              isEnabled: false,
                              textColor: Colors.grey,
                              controller: emailController,
                              obscureText: false,
                              textInputType: TextInputType.text,
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.06,
                            ),
                            PrimaryButton(
                              text: 'Save Changes',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  editProfile(context);
                                }
                              },
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.015,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
