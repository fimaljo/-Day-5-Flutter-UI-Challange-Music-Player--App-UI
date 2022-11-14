import 'dart:math';
import 'dart:ui';

import 'package:day_5_music_player_app/model/cards.dart';
import 'package:day_5_music_player_app/screens/3D_cards_details.dart';
import 'package:flutter/material.dart';

class CardsHome extends StatelessWidget {
  const CardsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: Colors.white,
        title: const Text(
          "My Playlist",
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () => null,
            icon: const Icon(
              Icons.search,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: CardsBody(),
          ),
          Expanded(
              flex: 2,
              child: Container(
                child: CardsHorizontal(),
              ))
        ],
      ),
    );
  }
}

class CardsBody extends StatefulWidget {
  const CardsBody({super.key});

  @override
  State<CardsBody> createState() => _CardsBodyState();
}

//double _value = 0.15;

class _CardsBodyState extends State<CardsBody> with TickerProviderStateMixin {
  bool _selectedMode = false;
  late AnimationController _animationControllerSelection;
  late AnimationController _animationControllerMovement;
  int _selectedIndex = 0;
  Future<void> _onCardSelected(Card3D card, int index) async {
    setState(() {
      _selectedIndex = index;
    });
    final duration = Duration(milliseconds: 750);
    _animationControllerMovement.forward();
    await Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, _) =>
          FadeTransition(opacity: animation, child: CardDetails(card: card)),
    ));
    _animationControllerMovement.reverse(from: 1.0);
  }

  int _getCurrentFactor(int currentIndex) {
    if (_selectedIndex == null || currentIndex == _selectedIndex) {
      return 0;
    } else if (currentIndex > _selectedIndex) {
      return -1;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    _animationControllerSelection = AnimationController(
        vsync: this,
        lowerBound: 0.15,
        upperBound: 0.5,
        duration: const Duration(milliseconds: 500));
    _animationControllerMovement = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 880));
    super.initState();
  }

  @override
  void dispose() {
    _animationControllerSelection.dispose();
    _animationControllerMovement.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _animationControllerSelection,
          builder: (context, snapshot) {
            final selectionValue = _animationControllerSelection.value;
            return GestureDetector(
              onTap: () {
                if (!_selectedMode) {
                  _animationControllerSelection.forward().whenComplete(() {
                    setState(() {
                      _selectedMode = true;
                    });
                  });
                } else {
                  _animationControllerSelection.reverse().whenComplete(() {
                    setState(() {
                      _selectedMode = false;
                    });
                  });
                }
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(selectionValue),
                child: AbsorbPointer(
                  absorbing: !_selectedMode,
                  child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth * 0.45,
                    color: Colors.white24,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: List.generate(
                        4,
                        (index) => Card3DItem(
                          height: constraints.maxHeight / 2,
                          card: cardList[index],
                          percent: selectionValue,
                          depth: index,
                          verticalFactor: _getCurrentFactor(index),
                          onCardSelected: (card) {
                            _onCardSelected(card, index);
                          },
                          animation: _animationControllerMovement,
                        ),
                      ).reversed.toList(),
                      // Positioned(
                      //   bottom: 0,
                      //   left: 0,
                      //   right: 0,
                      //   child: Slider(
                      //     value: _value,
                      //     min: 0.15,
                      //     max: 0.5,
                      //     onChanged: (val) {
                      //       setState(() {
                      //         _value = val;
                      //       });
                      //     },
                      //   ),
                      // ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class Card3DItem extends AnimatedWidget {
  const Card3DItem({
    super.key,
    required this.card,
    required this.percent,
    required this.height,
    required this.depth,
    required this.onCardSelected,
    this.verticalFactor = 0,
    required this.animation,
  }) : super(listenable: animation);
  final Card3D card;
  final double percent;
  final double height;
  final int depth;
  final ValueChanged<Card3D> onCardSelected;
  final int verticalFactor;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    final depthFactor = 50.0;
    final bottomMargin = height / 4.0;
    return Positioned(
      top: height + -depth * height / 2.0 * percent - bottomMargin,
      right: 0,
      left: 0,
      child: Opacity(
        opacity: verticalFactor == 0 ? 1 : 1 - animation.value,
        child: Hero(
          tag: card.title,
          flightShuttleBuilder: (flightContext, animation, flightDirection,
              fromHeroContext, toHeroContext) {
            Widget _current;
            if (flightDirection == HeroFlightDirection.push) {
              _current = fromHeroContext.widget;
            } else {
              _current = fromHeroContext.widget;
            }

            return AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  final newValue = lerpDouble(0.0, 2 * pi, animation.value);
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(
                        newValue!,
                      ),
                    child: _current,
                  );
                });
          },
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(
                  0.0,
                  verticalFactor *
                      animation.value *
                      MediaQuery.of(context).size.height,
                  depth * depthFactor),
            child: GestureDetector(
              onTap: () {
                onCardSelected(card);
              },
              child: SizedBox(
                height: height,
                child: Card3DWidget(card: card),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardsHorizontal extends StatelessWidget {
  const CardsHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 20),
          child: Text('Recently Played'),
        ),
        Expanded(
            child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cardList.length,
          itemBuilder: (context, index) {
            final card = cardList[index];
            return Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 50, bottom: 50),
              child: Card3DWidget(card: card),
            );
          },
        ))
      ],
    );
  }
}

class Card3DWidget extends StatelessWidget {
  const Card3DWidget({super.key, required this.card});
  final Card3D card;
  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(15.0);
    return PhysicalModel(
      elevation: 10,
      color: Colors.white,
      borderRadius: border,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          card.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
