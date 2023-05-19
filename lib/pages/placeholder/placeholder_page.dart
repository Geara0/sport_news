import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sport_news/widgets/post_widget.dart';

class PlaceHolderPage extends StatefulWidget {
  const PlaceHolderPage({Key? key}) : super(key: key);

  @override
  State<PlaceHolderPage> createState() => _PlaceHolderPageState();
}

class _PlaceHolderPageState extends State<PlaceHolderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('appbar').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: PostWidget(
              text: 'lorem'.tr(),
              header: 'post.header'.tr(),
              imageProvider: const AssetImage('assets/images/icon.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}
