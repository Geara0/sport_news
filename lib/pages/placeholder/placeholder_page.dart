import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sport_news/global_variables.dart';
import 'package:sport_news/widgets/post_widget.dart';

class PlaceHolderPage extends StatefulWidget {
  const PlaceHolderPage({Key? key}) : super(key: key);

  @override
  State<PlaceHolderPage> createState() => _PlaceHolderPageState();
}

class _PlaceHolderPageState extends State<PlaceHolderPage> {
  @override
  Widget build(BuildContext context) {
    var news = GlobalVariables.news;
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
              date: news[i].date,
              text: news[i].text,
              header: news[i].header,
              imageProvider: AssetImage(news[i].imagePath),
            ),
          ),
          itemCount: news.length,
        ),
      ),
    );
  }
}
