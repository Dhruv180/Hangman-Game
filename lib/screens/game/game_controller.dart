import 'dart:async';

class GameController {
  final String answer;
  int _errorCount = 0;
  final int maxErrorCount = 7;
  String imagePath = 'assets/images/hangman_0.png';
  final List<String> wrongLetters = [];
  final List<String> rightLetters = [];
  final List<String> puzzleLetters = [];

  final StreamController<String> onSomething = StreamController<String>.broadcast();

  void takeShot(String letter) {
    letter = letter.toLowerCase();
    if (!alreadyTried(letter)) {
      if (answer.toLowerCase().contains(letter)) {
        _success(letter);
      } else {
        _error(letter);
      }
    }
  }

  void _error(String letter) {
    _errorCount++;
    String tag = alreadyLost() ? '[lose]' : '[error]';
    updateImagePath();
    wrongLetters.add(letter);
    onSomething.add(tag);
  }

  void _success(String letter) {
    rightLetters.add(letter);
    updatePuzzle();
    String tag = puzzleLetters.contains(' ') ? '[success]' : '[win]';
    onSomething.add(tag);
  }

  void updatePuzzle() {
    puzzleLetters.clear();
    for (int i = 0; i < answer.length; i++) {
      rightLetters.contains(answer[i].toLowerCase()) ? puzzleLetters.add(answer[i]) : puzzleLetters.add(' ');
    }
  }

  void updateImagePath() {
    if (alreadyLost()) {
      imagePath = 'assets/images/hangman_lose.jpeg';
    } else if (alreadyWon()) {
      imagePath = 'assets/images/hangman_win.jpeg';
    } else {
      imagePath = 'assets/images/hangman_$_errorCount.png';
    }
  }

  bool alreadyWon() {
    return answer.split('').every((letter) => rightLetters.contains(letter.toLowerCase()));
  }

  bool alreadyTried(String letter) {
    return wrongLetters.contains(letter);
  }

  bool alreadyLost() {
    return _errorCount >= maxErrorCount;
  }

  int get answerLength => answer.length;

  GameController({required this.answer}) {
    updatePuzzle();
  }
}
