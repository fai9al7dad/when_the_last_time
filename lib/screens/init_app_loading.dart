import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:when_the_last_time/screens/home_page/home_page.dart';

class InitAppLoading extends StatefulWidget {
  static String routeName = "/init-app-loading";
  const InitAppLoading({super.key});

  @override
  State<InitAppLoading> createState() => _InitAppLoadingState();
}

class _InitAppLoadingState extends State<InitAppLoading> {
  // add isLoading variable
  // when is loading is false show the home page
  // when is loading is true show the loading screen

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeScreen(context);
  }

  void changeScreen(context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (Route route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
