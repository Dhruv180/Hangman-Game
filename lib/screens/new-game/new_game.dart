import 'package:flutter/material.dart';
import 'package:hangman/screens/game/game.dart';

class NewGame extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void startNewGame(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Game(answer: _textEditingController.text),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _toggleFocus(BuildContext context) {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Word of the day:',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8),
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'Enter your text here',
            border: OutlineInputBorder(),
          ),
          textAlign: TextAlign.center,
          focusNode: _focusNode,
          onSubmitted: (String value) {
            startNewGame(context);
          },
        ),
      ],
    );
  }

  Widget _buildArrowButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_forward),
      onPressed: () {
        if (_textEditingController.text.isNotEmpty) {
          startNewGame(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please enter a word!'),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman Game'),
      ),
      body: InkWell(
        splashColor: Colors.brown[100],
        highlightColor: Colors.brown[100],
        onTap: () {
          _toggleFocus(context);
        },
        child: Container(
          color: Colors.brown[200],
          padding: EdgeInsets.all(20.0),
          child: Container(
            alignment: Alignment.center,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                _buildTitle(context),
                SizedBox(height: 16), // Adjust spacing as needed
                _buildArrowButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
