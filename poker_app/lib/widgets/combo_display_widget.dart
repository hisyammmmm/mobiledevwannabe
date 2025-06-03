import 'package:flutter/material.dart';

class ComboDisplayWidget extends StatefulWidget {
  final String combo;

  const ComboDisplayWidget({required this.combo});

  @override
  _ComboDisplayWidgetState createState() => _ComboDisplayWidgetState();
}

class _ComboDisplayWidgetState extends State<ComboDisplayWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation for entrance
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Shimmer animation for text highlight
    _shimmerController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Pulse animation for container
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() {
    _scaleController.forward();

    // Start shimmer after scale animation
    Future.delayed(Duration(milliseconds: 500), () {
      _shimmerController.repeat(reverse: true);
    });

    // Start pulse animation
    Future.delayed(Duration(milliseconds: 800), () {
      _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          // Animated title with shimmer effect
          AnimatedBuilder(
            animation: _shimmerAnimation,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.grey.shade600,
                      Colors.white,
                      Colors.grey.shade600,
                    ],
                    stops: [
                      (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                      _shimmerAnimation.value.clamp(0.0, 1.0),
                      (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  '✨ Your Epic Combo ✨',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),

          SizedBox(height: 24),

          // Main combo container with animations
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    // Gradient background
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.7),
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    // Glowing shadow effect
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned.fill(
                        child: CustomPaint(
                          painter: PatternPainter(),
                        ),
                      ),

                      // Main content
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Combo text with special styling
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              widget.combo,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: 16),

                          // Achievement badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.amber.shade300,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber.shade800,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'COMBO UNLOCKED',
                                  style: TextStyle(
                                    color: Colors.amber.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber.shade800,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 16),

          // Floating action buttons for interaction
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.small(
                onPressed: () {
                  // Share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Combo shared! 🎉')),
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Icon(Icons.share, color: Colors.white),
                heroTag: "share",
              ),
              SizedBox(width: 16),
              FloatingActionButton.small(
                onPressed: () {
                  // Favorite functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added to favorites! ⭐')),
                  );
                },
                backgroundColor: Colors.red.shade400,
                child: Icon(Icons.favorite, color: Colors.white),
                heroTag: "favorite",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for background pattern
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw geometric pattern
    final path = Path();
    final spacing = 30.0;

    for (double i = 0; i < size.width + spacing; i += spacing) {
      for (double j = 0; j < size.height + spacing; j += spacing) {
        canvas.drawCircle(
          Offset(i, j),
          4,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}