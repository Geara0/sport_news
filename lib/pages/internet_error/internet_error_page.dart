import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InternetErrorPage extends StatelessWidget {
  const InternetErrorPage({required this.errorCode, Key? key})
      : super(key: key);

  final String errorCode;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/internet_error.jpg',
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 250),
                child: Text(
                  errorCode.tr(),
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
