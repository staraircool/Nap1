import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isAgreed = false;
  late AnimationController _pandaController;
  late Animation<double> _pandaAnimation;

  @override
  void initState() {
    super.initState();
    _pandaController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _pandaAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pandaController,
      curve: Curves.easeInOut,
    ));
    _pandaController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pandaController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB19CD9),
              Color(0xFF2C2C2C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Enhanced Panda illustration
                      AnimatedBuilder(
                        animation: _pandaAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_pandaAnimation.value * 0.1),
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(70),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Panda ears
                                  Positioned(
                                    top: 15,
                                    left: 25,
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 15,
                                    right: 25,
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  // Panda face
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Eyes
                                        Positioned(
                                          top: 20,
                                          left: 15,
                                          child: Container(
                                            width: 15,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 20,
                                          right: 15,
                                          child: Container(
                                            width: 15,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        // Nose
                                        Positioned(
                                          bottom: 25,
                                          child: Container(
                                            width: 8,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(Radius.circular(3)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Panda paw
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.circle,
                                          color: Colors.white,
                                          size: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'WELCOME TO NAP',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'For the Dreamers, Not the Grinders',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: _isAgreed,
                              onChanged: (value) {
                                setState(() {
                                  _isAgreed = value ?? false;
                                });
                              },
                              activeColor: Colors.blue,
                              checkColor: Colors.white,
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'I agree to Headspace\'s Terms & Conditions and acknowledge the Privacy Policy.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isAgreed ? _navigateToHome : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isAgreed ? Colors.blue : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: _isAgreed ? 5 : 0,
                          ),
                          child: const Text(
                            'Create an account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _navigateToHome,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

