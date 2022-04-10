import 'dart:html';
import 'dart:js';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  //List<List<String>> matrix =List<List<String>>();

  late List<List> matrix;
  _GameScreenState() {
    _initiMatrix();
  }
  _initiMatrix() {
    matrix = [
      [' ', ' ', ' '],
      [' ', ' ', ' '],
      [' ', ' ', ' '],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('X_o Game'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildElement(0, 0, context),
              buildElement(0, 1, context),
              buildElement(0, 2, context),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildElement(1, 0, context),
              buildElement(1, 1, context),
              buildElement(1, 2, context),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildElement(2, 0, context),
              buildElement(2, 1, context),
              buildElement(2, 2, context),
            ],
          ),
        ]),
      ),
    );
  }

  String _lastValue = 'o';
  buildElement(int row, int col, BuildContext context) {
    return GestureDetector(
      onTap: () {
        GhangeMatrix(row, col);

        if (WinnerFun(row, col, context)) {
          _PopUpMsg(matrix[row][col], context);
        } else {
          if (CheckDraw()) {
            _PopUpMsg(null, context);
          }
        }
      },
      child: Container(
        width: 90,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.black,
            )),
        child: Center(
          child: Text(
            matrix[row][col],
            style: TextStyle(fontSize: 100),
          ),
        ),
      ),
    );
  }

  GhangeMatrix(int row, int col) {
    setState(() {
      if (matrix[row][col] == ' ') {
        if (_lastValue == 'o') {
          matrix[row][col] = 'x';
        } else {
          matrix[row][col] = 'o';
        }
        _lastValue = matrix[row][col]; //update value to continue
        // matrix[row][col] = 'x';
      }
    });
  }

  WinnerFun(int row, int col, BuildContext context) {
    var row_ = 0, col_ = 0, diagonal = 0, rdiagonal = 0;
    var len = matrix.length - 1;
    var player = matrix[row][col];
    for (var i = 0; i < matrix.length; i++) {
      if (matrix[i][col] == player) {
        row_++;
      }
      if (matrix[row][i] == player) {
        col_++;
      }
      if (matrix[i][i] == player) {
        diagonal++;
      }
      if (matrix[i][len - i] == player) {
        rdiagonal++;
      }
    }
    if (row_ == len + 1 ||
        col_ == len + 1 ||
        diagonal == len + 1 ||
        rdiagonal == len + 1) {
      // print('$player is winner');
      // _initiMatrix();
      // _PopUpMsg(player, context);
      return true;
    } else {
      return false;
    }
  }

  CheckDraw() {
    var draw = true;
    matrix.forEach((element1) {
      element1.forEach((element2) {
        if (element2 == ' ') {
          draw = false;
        }
      });
    });
    return draw;
  }

  _PopUpMsg(String? winner, BuildContext context) {
    String dialogText;
    if (winner == null) {
      dialogText = "it's a draw";
    } else {
      dialogText = "player $winner the Winner";
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text(dialogText),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _initiMatrix();
                    });
                  },
                  child: Text('Reset Game')),
            ],
          );
        });
  }
}
