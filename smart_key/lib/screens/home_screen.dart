import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences preferences;
  bool isLoading = false;
  String? firstName;
  String? profilePicture;

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      firstName = preferences.getString('name')!.split(' ')[0];
      profilePicture = preferences.getString('profilePicture');
      isLoading = false;
    });
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
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth(context) * 0.05,
                        vertical: screenHeight(context) * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      '$serverImagesUrl/${preferences.getString('profilePicture')}',
                                      width: screenWidth(context) * 0.2,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth(context) * 0.03),
                              Expanded(
                                flex: 12,
                                child: Text(
                                  'Hi, $firstName',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Icon(
                                  Icons.notifications_none_outlined,
                                  color: primaryColor,
                                  size: screenWidth(context) * 0.08,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/homeMembers');
                          },
                          child: Expanded(
                              flex: 1,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Members at home',
                                    style: TextStyle(color: primaryColor),
                                  ))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
