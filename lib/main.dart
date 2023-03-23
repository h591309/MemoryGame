import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memory_card_game/logic/cardmodel.dart';
import 'package:memory_card_game/logic/cardwidget.dart';

void main() => runApp(MemoryCardGame());

class MemoryCardGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Card Game',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<CardModel> cards = [];
  List<Icon> icons = [
    Icon(Icons.g_mobiledata),
    Icon(Icons.zoom_in),
    Icon(Icons.face_3),
    Icon(Icons.arrow_back),
    Icon(Icons.javascript),
    Icon(Icons.kayaking),
  ];
  CardModel? firstSelectedCard;
  CardModel? secondSelectedCard;
  bool canSelectCard = true;
  int points = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    // Initialize the card list with pairs of numbers.
    List<int> cardValues = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6];
    cardValues.shuffle();

    cards = List.generate(cardValues.length, (index) {
      return CardModel(
        id: index,
        value: cardValues[index],
        isFlipped: false,
        isMatched: false,
        icon: icons[cardValues[index] - 1],
      );
    });
  }

  void onCardSelected(CardModel card) {
    if (!canSelectCard || card.isMatched || card.isFlipped) return;
    if (secondSelectedCard != null) return;

    setState(() {
      card.isFlipped = true;
    });

    if (firstSelectedCard == null) {
      firstSelectedCard = card;
      setState(() {
        canSelectCard = true;
      });
    } else {
      secondSelectedCard = card;
      checkForMatch();
    }
  }

  void checkForMatch() {
    canSelectCard = false;

    if (firstSelectedCard!.value == secondSelectedCard!.value) {
      setState(() {
        firstSelectedCard!.isMatched = true;
        secondSelectedCard!.isMatched = true;
        points += 10;
      });
      resetSelection();
    } else {
      Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          firstSelectedCard!.isFlipped = false;
          secondSelectedCard!.isFlipped = false;
          points -= 5;
        });
        resetSelection();
      });
    }
  }

  void resetSelection() {
    firstSelectedCard = null;
    secondSelectedCard = null;
    canSelectCard = true;
  }

  void onReset() {
    setState(() {
      for (CardModel card in cards) {
        card.isFlipped = false;
        card.isMatched = false;
      }
    });
    points = 0;
    resetSelection();
    initializeGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Card Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 400,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: cards.length,
                itemBuilder: (BuildContext context, int index) {
                  CardModel card = cards[index];
                  return CardWidget(
                    card: card,
                    onCardFlip: () => onCardSelected(card),
                  );
                },
              ),
            ),
            ElevatedButton(
              child: Text("Reset"),
              onPressed: () => onReset(),
              style: ButtonStyle(
                elevation: MaterialStateProperty.resolveWith((states) => 5),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Text(
              "Score: $points",
            ),
          ],
        ),
      ),
    );
  }
}
