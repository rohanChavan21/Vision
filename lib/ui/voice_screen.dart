import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:vision_app/ui/tab_view.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({Key? key}) : super(key: key);

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  FlutterTts flutterTts = FlutterTts();
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      flutterTts.speak(
          'The app is now open press anywhere on the screen to start speaking, say scan to go to currency detection');
    });
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vision App'),
      ),
      body: GestureDetector(
        onTap: () {
          _speechToText.isNotListening ? _startListening : _stopListening;
          if (_speechToText.isListening) {
            if (_lastWords.contains('Scan')) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const TabViewScreen(),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
