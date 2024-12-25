

import 'package:flutter/material.dart';

class BadgesSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(57, 36, 72, 1),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5, // Adjust the number of badges here
            itemBuilder: (context, index) {
              return BadgeCard(
                badgeImage: 'https://cdn-icons-png.freepik.com/512/4209/4209019.png',
                achievementName: 'Achievement ${index + 1}',
                isCompleted: index % 2 == 0, // Customize completion condition here
              );
            },
          ),
        ),
      ],
    );
  }
}

class BadgeCard extends StatefulWidget {
  final String badgeImage;
  final String achievementName;
  final bool isCompleted;

  BadgeCard({
    required this.badgeImage,
    required this.achievementName,
    required this.isCompleted,
  });

  @override
  _BadgeCardState createState() => _BadgeCardState();
}

class _BadgeCardState extends State<BadgeCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
      if (isHovered) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: 6,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Color.fromRGBO(57, 36, 72, 0.9),
              child: InkWell(
                onTap: () {
                  // Handle tap action here
                },
                borderRadius: BorderRadius.circular(16.0), // Match the card's border radius
                splashColor: Colors.white.withOpacity(0.3), // Ripple effect color
                child: Container(
                  width: 150,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        widget.badgeImage,
                        width: 70,
                        height: 70,
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.achievementName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (widget.isCompleted)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Completed',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

