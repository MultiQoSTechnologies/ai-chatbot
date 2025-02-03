import 'package:flutter/material.dart';
import 'package:google_generative_ai_demo/common/app_loader.dart';
import 'package:google_generative_ai_demo/common/string_extension.dart';
import 'package:google_generative_ai_demo/ui/chat_tile.dart';

class ChatScreen extends StatefulWidget {
  final Function() changesTheme;
  final ThemeMode themeMode;

  const ChatScreen({
    super.key,
    required this.changesTheme,
    required this.themeMode,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/ic_space_back.jpg'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 30,
          title:  Text(
            StringExtension.kAppTitle,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                  onTap: () {
                    widget.changesTheme();
                  },
                  child: Icon(
                    color: Colors.white,
                    widget.themeMode == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  )),
            )
          ],
        ),
        body: ChatWidget(apiKey: StringExtension.kApiKey,themeMode:widget.themeMode),
      ),
    );
  }
}
