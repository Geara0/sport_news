import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PostWidget extends StatefulWidget {
  final ImageProvider? imageProvider;
  final String header;
  final String text;

  const PostWidget({
    required this.text,
    required this.header,
    this.imageProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isExpanded = false;
  static const _duration = Duration(milliseconds: 400);

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
                AnimatedCrossFade(
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd.MM.yyyy').format(DateTime.now())),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.share),
                          const SizedBox(width: 5),
                          Text('post.defaultCount'.tr()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.tonal(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.comment),
                          const SizedBox(width: 5),
                          Text('post.defaultCount'.tr()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const _LikeButton(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LikeButton extends StatefulWidget {
  const _LikeButton({Key? key}) : super(key: key);

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton> {
  bool isLike = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () {
        setState(() => isLike = !isLike);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: [
              if (isLike)
                const Icon(Icons.favorite)
              else
                const Icon(Icons.favorite_outline),
            ].first,
          )
              .animate(target: isLike ? 1 : 0)
              .scaleXY(end: isLike ? 1.5 : 1 / 1.5, duration: 40.ms)
              .then(delay: 40.ms)
              .scaleXY(end: isLike ? 1 / 1.5 : 1.5, duration: 60.ms),
          const SizedBox(width: 5),
          Text('post.defaultCount'.tr()),
        ],
      ),
    );
  }
}
