import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _parallaxController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _parallaxAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _parallaxController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _parallaxAnimation = Tween<double>(
      begin: 0.0,
      end: -100.0,
    ).animate(CurvedAnimation(
      parent: _parallaxController,
      curve: Curves.easeOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _parallaxController,
      curve: Curves.easeOut,
    ));
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _parallaxController.dispose();
    super.dispose();
  }

  void _navigateToAuth() {
    _parallaxController.forward().then((_) {
      Navigator.pushReplacementNamed(context, '/auth');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // Swipe up detected
            _navigateToAuth();
          }
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([_fadeAnimation, _parallaxAnimation, _scaleAnimation]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _parallaxAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFB19CD9),
                        Color(0xFF9B7EBD),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: const Center(
                              child: Text(
                                'EARN\nWHILE\nNAP',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                  letterSpacing: 4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 40),
                                child: GestureDetector(
                                  onTap: _navigateToAuth,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 40,
                                      color: Color(0xFF9B7EBD),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

