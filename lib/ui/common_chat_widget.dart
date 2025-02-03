import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    super.key,
    this.image,
    this.text,
    required this.isFromUser,
  });

  final Image? image;
  final String? text;
  final bool isFromUser;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          widget.isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        !widget.isFromUser
            ? Container(
                height: 20,
                width: 20,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
                child: const Center(
                    child: Icon(
                  Icons.account_tree_sharp,
                  color: Colors.white,
                )),
              )
            : const SizedBox.shrink(),
        Flexible(
          child:  InkWell(
            onTap: () {
              launchInBrowser(widget.text ?? '');
            },
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 1.5),
              decoration: BoxDecoration(
                color: widget.isFromUser
                    ? Colors.green.shade900
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: widget.image == null ? 20 : 0,
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.text case final text?)
                    MarkdownBody(data: text),
                  if (widget.image case final image?)
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: image,
                    ),
                ],
              ),
            ),
          ),
        ),
        widget.isFromUser
            ? Container(
                height: 20,
                width: 20,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
                child: const Center(
                    child: Icon(
                  Icons.face,
                  size: 20,
                  color: Colors.white,
                )),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Future<void> launchInBrowser(String url) async {
    print('_MessageWidgetState.launchInBrowser $url a');
    final uri = Uri.parse('www.google.com');
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
