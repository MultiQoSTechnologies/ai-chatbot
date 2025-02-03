import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_generative_ai_demo/common/app_loader.dart';
import 'package:google_generative_ai_demo/common/show_error.dart';
import 'package:google_generative_ai_demo/common/string_extension.dart';
import 'package:google_generative_ai_demo/ui/common_chat_widget.dart';
import 'package:google_generative_ai_demo/common/image_picker_bottomsheet.dart';
import 'package:image_picker/image_picker.dart';

class ChatWidget extends StatefulWidget {
  final ThemeMode themeMode;

  ChatWidget({
    super.key,
    required this.apiKey,
    required this.themeMode,
  });

  final String apiKey;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: widget.apiKey,
    );
    _chat = _model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    final textFieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: StringExtension.kMessageEnterHintTest,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Expanded(
              child: widget.apiKey.isNotEmpty
                  ? _generatedContent.isNotEmpty
                      ? ListView.builder(
                          controller: _scrollController,
                          itemBuilder: (context, idx) {
                            final content = _generatedContent[idx];
                            return MessageWidget(
                              text: content.text,
                              image: content.image,
                              isFromUser: content.fromUser,
                            );
                          },
                          itemCount: _generatedContent.length,
                        )
                      : _buildEmptyChatPlaceholder()
                  : ListView(
                      children: [
                        Text(
                          StringExtension.kServiceNotAvailable,
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: _textFieldFocus,
                      decoration: textFieldDecoration,
                      controller: _textController,
                      onSubmitted: _sendChatMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox.square(dimension: 15),
                  IconButton(
                    onPressed: !_loading
                        ? () async {
                            FocusScope.of(context).unfocus();
                            openGalleryCamera(
                                context: context,
                                fileFromGalley: (ImageSource imageFile) {
                                  _pickImage(_textController.text, imageFile);
                                  AppLoader.hideLoader();
                                  _scrollDown();
                                  setState(() {});
                                });
                          }
                        : null,
                    icon: Icon(Icons.image,
                        color: _loading ? Colors.white : Colors.white),
                  ),
                  IconButton(
                    onPressed: () async {
                      _scrollDown();
                      FocusScope.of(context).unfocus();
                      if (_textController.text.isNotEmpty) {
                        _sendChatMessage(_textController.text);
                        _textController.text = '';
                      }
                    },
                    icon: !_loading
                        ? const Icon(
                            Icons.send,
                            color: Colors.white,
                          )
                        : SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.green.shade900,
                            ),
                          ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendImagePrompt(String message, Uint8List? imageBytes) async {
    _scrollDown();
    setState(() {
      _loading = true;
    });
    try {
      final content = [
        Content.multi([
          TextPart(message),
          if (imageBytes != null)
            DataPart('image/jpeg', imageBytes), // Add the selected image
        ])
      ];

      // Add user input to the chat
      _generatedContent.add((
        image: imageBytes != null ? Image.memory(imageBytes) : null,
        text: message,
        fromUser: true,
      ));

      // Simulate a response from the API
      var response = await _model.generateContent(content); // Your model call
      var text = response.text;

      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        showError('No response from API.', context);
        return;
      }
    } catch (e) {
      showError(e.toString(), context);
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _scrollDown();
      // _textFieldFocus.requestFocus();
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String message, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        Uint8List imageBytes = await pickedFile.readAsBytes();
        _sendImagePrompt(message, imageBytes);
      }
    } catch (e) {
      showError('Error picking image: $e', context);
    }
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    _scrollDown();
    setState(() {
      _loading = true;
    });
    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        showError('No response from API.', context);
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      showError(e.toString(), context);
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _scrollDown();
    }
  }
}

Widget _buildEmptyChatPlaceholder() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.chat_bubble_outline,
          size: 100,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        Text(
          StringExtension.kNoMsgYet,
          style: const TextStyle(fontSize: 22, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          StringExtension.kStartConversationNow,
          style: const TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ],
    ),
  );
}
