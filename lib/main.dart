import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_generative_ai_demo/common/app_loader.dart';
import 'package:google_generative_ai_demo/common/color_theme.dart';
import 'package:google_generative_ai_demo/common/image_picker_bottomsheet.dart';
import 'package:google_generative_ai_demo/ui/chat_screen.dart';
import 'package:image_picker/image_picker.dart';

/// The API key to use when accessing the Gemini API.
/// To learn how to generate and specify this key,
/// check out the README file of this sample.

void main() {
  runApp(const GenerativeAISample());
}

class GenerativeAISample extends StatefulWidget {
  const GenerativeAISample({super.key});

  @override
  State<GenerativeAISample> createState() => _GenerativeAISampleState();
}

class _GenerativeAISampleState extends State<GenerativeAISample> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: ChatScreen(
        changesTheme: () {
          print('_GenerativeAISampleState.build $_themeMode');
          _toggleTheme();
        }, themeMode: _themeMode,
      ),
    );
  }
}