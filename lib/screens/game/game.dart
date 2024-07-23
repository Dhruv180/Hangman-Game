import 'package:flutter/material.dart';
import 'package:hangman/screens/game/widgets/header.dart';
import 'package:hangman/screens/game/widgets/puzzle.dart';
import 'package:hangman/screens/game/game_controller.dart';
import 'package:hangman/screens/new-game/new_game.dart';

class Game extends StatefulWidget {
  final String answer;

  const Game({required this.answer});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  late GameController gameController;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    gameController = GameController(answer: widget.answer);

    // Listen to changes in GameController to update the image
    gameController.onSomething.stream.listen((event) {
      setState(() {
        gameController.updateImagePath();
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void submit(String letter) {
    gameController.takeShot(letter);
    _textEditingController.clear();
    FocusScope.of(context).unfocus();
  }

  void _startNewGame(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NewGame()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> hints = gameController.answer.substring(0, 2).split('');

    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman Game'),
      ),
      body: Container(
        color: Colors.brown[200],
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _startNewGame(context),
                child: Text(
                  'New Game',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Header(wrongLetters: gameController.wrongLetters),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Image.asset(
                gameController.imagePath,
                width: double.infinity,
                height: 350.0,
              ),
            ),
            gameController.alreadyLost()
                ? Column(
                    children: <Widget>[
                      Text(
                        'Answer',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Puzzle(
                        answerLength: gameController.answerLength,
                        puzzleLetters: gameController.answer.split(''),
                      ),
                    ],
                  )
                : Puzzle(
                    answerLength: gameController.answerLength,
                    puzzleLetters: gameController.puzzleLetters,
                  ),
            if (!gameController.alreadyWon() && !gameController.alreadyLost())
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150.0,
                      child: TextField(
                        controller: _textEditingController,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _textEditingController.text = value.substring(0, 1);
                          }
                        },
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 35.0),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Next Letter',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: submit,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        if (_textEditingController.text.isNotEmpty) {
                          submit(_textEditingController.text.toLowerCase());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a letter!'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hint: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  for (String hint in hints)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        hint,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
