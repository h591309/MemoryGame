import 'package:memory_card_game/logic/cardmodel.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final CardModel card;
  final Function() onCardFlip;

  CardWidget({required this.card, required this.onCardFlip});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onCardFlip();
        if (!widget.card.isFlipped && !widget.card.isMatched) {
          setState(() {
            widget.card.isFlipped = false;
          });
        }
      },
      child: Card(
        child: widget.card.isFlipped || widget.card.isMatched
            ? Center(
                child: Container(
                child: widget.card.icon,
              ))
            : Center(
                child: Container(
                  child: Icon(Icons.photo),
                ),
              ),
      ),
    );
  }
}
