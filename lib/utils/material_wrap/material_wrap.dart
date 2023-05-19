import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MaterialWrap extends StatelessWidget {
  const MaterialWrap(this.widget, {Key? key}) : super(key: key);
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness:
              SchedulerBinding.instance.platformDispatcher.platformBrightness,
        ),
        useMaterial3: true,
      ),
      home: widget,
    );
  }
}
