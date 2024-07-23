import 'package:flutter/material.dart';
import 'package:hangman/screens/new-game/new_game.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NewGame(),
    theme: ThemeData(
      primaryColor: Colors.brown, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black)
    )
  ));
}