import 'package:flutter/material.dart';
import 'dart:async';
import '../services/mining_service.dart';

class MiningScreen extends StatefulWidget {
  const MiningScreen({super.key});

  @override
  State<MiningScreen> createState() => _MiningScreenState();
}

class _MiningScreenState extends State<MiningScreen>
    with TickerProviderStateMixin {
  late AnimationController _pandaController;
  late AnimationController _zzzController;
  late Animation<double> _pandaAnimation;
  late Animation<double> _zzzAnimation;
  
  bool _isMining = false;
  Timer? _uiTimer;
  Duration _remainingTime = const Duration(hours: 12);
  
  @override
  void initState() {
    super.initState();
    
    _pandaController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _zzzController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pandaAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _pandaController,
      curve: Curves.easeInOut,
    ));
    
    _zzzAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _zzzController,
      curve: Curves.easeInOut,
    ));
    
    _checkMiningStatus();
  }

  @override
  void dispose() {
    _pandaController.dispose();
    _zzzController.dispose();
    _uiTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkMiningStatus() async {
    final isMining = await MiningService.isMining();
    if (isMining) {
      final remaining = await MiningService.getRemainingMiningTime();
      setState(() {
        _isMining = true;
        _remainingTime = remaining;
      });
      _startAnimations();
      _startUITimer();
    }
  }

  void _startAnimations() {
    _pandaController.repeat(reverse: true);
    _zzzController.repeat(reverse: true);
  }

  void _stopAnimations() {
    _pandaController.stop();
    _zzzController.stop();
  }

  void _startUITimer() {
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final remaining = await MiningService.getRemainingMiningTime();
      setState(() {
        _remainingTime = remaining;
      });
      
      if (_remainingTime.inSeconds <= 0) {
        _stopMining();
      }
    });
  }

  Future<void> _startMining() async {
    await MiningService.startMining();
    setState(() {
      _isMining = true;
      _remainingTime = const Duration(hours: 12);
    });
    
    _startAnimations();
    _startUITimer();
  }

  Future<void> _stopMining() async {
    await MiningService.stopMining();
    setState(() {
      _isMining = false;
    });
    
    _stopAnimations();
    _uiTimer?.cancel();
  }

  void _navigateToHome() {
    Navigator.pop(context);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // Swipe up detected
            _navigateToHome();
          }
        },
        child: Container(
          color: Colors.black,
          child: SafeArea(
            child: Column(
              children: [
                // Top section with timer
                if (_isMining)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'Start next session after\n${_formatDuration(_remainingTime)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                
                // Dream mode text
                if (_isMining)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '"You\'re in Dream Mode. You\'ll wake up with more \$NAP."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                
                // Panda animation section
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Panda
                            AnimatedBuilder(
                              animation: _pandaAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _pandaAnimation.value),
                                  child: Container(
                                    width: 150,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '🐼',
                                        style: TextStyle(fontSize: 60),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // ZZZ animation
                            if (_isMining)
                              Positioned(
                                top: -50,
                                right: -30,
                                child: AnimatedBuilder(
                                  animation: _zzzAnimation,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity: _zzzAnimation.value,
                                      child: const Text(
                                        'Z Z Z Z Z',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom section
                Container(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      if (!_isMining)
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _startMining,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Start Nap',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              'Nap in Progress',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      
                      const SizedBox(height: 30),
                      
                      const Text(
                        'Swipe Up to Awake',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      GestureDetector(
                        onTap: _navigateToHome,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_up,
                            size: 40,
                            color: Colors.black,
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
  }
}

