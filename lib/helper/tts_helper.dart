import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class STTHelper {
  static final sttHelper = STTHelper._();

  STTHelper._();

  SpeechToText stt = SpeechToText();

  Future<bool> initSpeech() async {
    return await stt.initialize();
  }

  void startListening() async {
    await stt.listen(onResult: onSpeechResult);
  }

  void stopListening() async {
    await stt.stop();
  }

  String onSpeechResult(SpeechRecognitionResult result) {
    return result.recognizedWords;
  }
}
