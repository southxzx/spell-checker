import 'package:flutter/material.dart';

import 'custom_text_editting_controller.dart';
import 'list_english_words.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final List<String> listErrorTexts = [];

  final List<String> listTexts = [];

  CustomTextEdittingController _controller = CustomTextEdittingController();

  @override
  void initState() {
    _controller = CustomTextEdittingController(listErrorTexts: listErrorTexts);
    super.initState();
  }

  void _handleOnChange(String text) {
    _handleSpellCheck(text, true);
  }

  void _handleSpellCheck(String text, bool ignoreLastWord) {
    if (!text.contains(' ')) {
      return;
    }
    final List<String> arr = text.split(' ');
    if (ignoreLastWord) {
      arr.removeLast();
    }
    for (var word in arr) {
      if (word.isEmpty) {
        continue;
      } else if (_isWordHasNumberOrBracket(word)) {
        continue;
      }
      final wordToCheck = word.replaceAll(RegExp(r"[^\s\w]"), '');
      final wordToCheckInLowercase = wordToCheck.toLowerCase();
      if (!listTexts.contains(wordToCheckInLowercase)) {
        listTexts.add(wordToCheckInLowercase);
        if (!listEnglishWords.contains(wordToCheckInLowercase)) {
          listErrorTexts.add(wordToCheck);
        }
      }
    }
  }

  bool _isWordHasNumberOrBracket(String s) {
    return s.contains(RegExp(r'[0-9\()]'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(36.0),
        width: 400,
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              _handleSpellCheck(_controller.text, false);
            }
          },
          child: TextFormField(
              controller: _controller,
              onChanged: _handleOnChange,
              minLines: 5,
              maxLines: 10,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)))),
        ),
      ),
    );
  }
}
