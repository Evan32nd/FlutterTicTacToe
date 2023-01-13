import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

import 'dart:async';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreeState();
}

class _GameScreeState extends State<GameScreen> {
  bool oTurn = true;
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];
  List<int> matchedIndexes = [];
  int attempts = 0;

  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  bool winnerFound = false;
  String resultDeclaration = '';

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MainColors.primaryColor,
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Player O',
                              style: customFontWhite,
                            ),
                            Text(oScore.toString(), style: customFontWhite)
                          ],
                        ),
                        SizedBox(width: 50),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Player X',
                              style: customFontWhite,
                            ),
                            Text(xScore.toString(), style: customFontWhite)
                          ],
                        )
                      ],
                    ))),
                Expanded(
                    flex: 3,
                    child: GridView.builder(
                        itemCount: 9,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                _tapped(index);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        width: 5,
                                        color: MainColors.primaryColor,
                                      ),
                                      color: matchedIndexes.contains(index)
                                          ? MainColors.accentColor
                                          : MainColors.secondaryColor),
                                  child: Center(
                                      child: Text(displayXO[index],
                                          style: GoogleFonts.coiny(
                                              textStyle: TextStyle(
                                                  fontSize: 64,
                                                  color: MainColors
                                                      .primaryColor))))));
                        })),
                Expanded(
                    flex: 2,
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Text(
                            resultDeclaration,
                            style: customFontWhite,
                          ),
                          SizedBox(height: 10),
                          _buildTimer(),
                        ]))),
              ],
            )));
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;
    if (isRunning) {
      setState(() {
        if (oTurn && displayXO[index] == '') {
          displayXO[index] = "O";
          filledBoxes++;
          oTurn = !oTurn;
        } else if (!oTurn && displayXO[index] == '') {
          displayXO[index] = "X";
          filledBoxes++;
          oTurn = !oTurn;
        }
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    //check first row
    if (displayXO[0] != '' &&
        displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2]) {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[0] + ' Wins!';
        matchedIndexes.addAll([0, 1, 2]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }

    //check second row
    if (displayXO[3] != '' &&
        displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5]) {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[3] + ' Wins!';
        matchedIndexes.addAll([3, 4, 5]);
        stopTimer();
        _updateScore(displayXO[3]);
      });
    }

    //check third row
    if (displayXO[6] != '' &&
        displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8]) {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[6] + ' Wins!';
        matchedIndexes.addAll([6, 7, 8]);
        stopTimer();
        _updateScore(displayXO[6]);
      });
    }

    //check first column
    if (displayXO[0] != '' &&
        displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6]) {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[6] + ' Wins!';
        matchedIndexes.addAll([0, 3, 6]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }

        //check second column
    if (displayXO[1] != '' &&
        displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7]) {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[6] + ' Wins!';
        matchedIndexes.addAll([1, 4, 7]);
        stopTimer();
        _updateScore(displayXO[1]);
      });
    }

        //check third column
    if (displayXO[2] != '' &&
        displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8]) {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[6] + ' Wins!';
        matchedIndexes.addAll([2, 5, 8]);
        stopTimer();
        _updateScore(displayXO[2]);
      });
    }

    //check first diagonal
    if (displayXO[0] != '' &&
        displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8]) {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[0] + ' Wins!';
        matchedIndexes.addAll([0, 4, 8]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }

    //check second diagonal
    if (displayXO[2] != '' &&
        displayXO[2] == displayXO[4] &&
        displayXO[2] == displayXO[6]) {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[2] + ' Wins!';
        matchedIndexes.addAll([2, 4, 6]);
        stopTimer();
        _updateScore(displayXO[2]);
      });
    }

    if (!winnerFound && filledBoxes == 9) {
      setState(() {
        resultDeclaration = 'Nobody Wins!';
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }

    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      displayXO = ['', '', '', '', '', '', '', '', ''];
    });
    resultDeclaration = '';
    filledBoxes = 0;
    matchedIndexes = [];
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning
        ? SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 8,
                  backgroundColor: MainColors.accentColor,
                ),
                Center(
                    child: Text(seconds.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 50)))
              ],
            ))
        : ElevatedButton(
            onPressed: () {
              _clearBoard();
              startTimer();
              attempts++;
            },
            child: Text(
              attempts == 0 ? 'Start!' : 'Play Again!',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)));
  }
}
