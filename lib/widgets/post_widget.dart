import 'package:easy_localization/easy_localization.dart' as l10n;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PostWidget extends StatefulWidget {
  final ImageProvider? imageProvider;
  final String header;
  final String text;
  final String date;

  const PostWidget({
    required this.text,
    required this.header,
    required this.date,
    this.imageProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isExpanded = false;
  bool hasOverflow = true;
  static const _duration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void toggleExpand() => setState(() => isExpanded = true);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.imageProvider != null)
            Image(
              image: widget.imageProvider!,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectionArea(
                  child: Text(
                    widget.header,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Use a textpainter to determine if it will exceed max lines
                    var painter = TextPainter(
                      maxLines: 4,
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr,
                      text: TextSpan(text: widget.text),
                    );

                    // trigger it to layout
                    painter.layout(maxWidth: constraints.maxWidth);

                    hasOverflow = painter.didExceedMaxLines;
                    // if text wasn't overflown
                    if (!painter.didExceedMaxLines) {
                      return Text(widget.text);
                    }

                    return AnimatedCrossFade(
                      duration: _duration,
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstCurve: Curves.easeIn,
                      secondCurve: Curves.easeOut,
                      firstChild: SelectionArea(
                        child: Text(
                          widget.text,
                          maxLines: 4,
                        ),
                      ),
                      secondChild: SelectionArea(child: Text(widget.text)),
                    );
                  },
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.date),
                      if (hasOverflow)
                        TextButton(
                          onPressed: toggleExpand,
                          child: Text('post.showMore'.tr()),
                        ).animate(target: isExpanded ? 1 : 0).scaleY(
                              begin: 1,
                              end: 0,
                              duration: _duration,
                              alignment: Alignment.bottomCenter,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
