import 'package:day_5_music_player_app/model/cards.dart';
import 'package:day_5_music_player_app/screens/3d_cards_home.dart';
import 'package:flutter/material.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({super.key, required this.card});
  final Card3D card;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black45,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          Align(
            child: SizedBox(
              height: 150.0,
              child: Hero(tag: card.title, child: Card3DWidget(card: card)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            card.title,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            card.author,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
