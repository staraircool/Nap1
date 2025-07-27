import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class MiningService {
  static const double _baseRate = 4.3333; // NAP per hour
  static const double _referralBonus = 1.3333; // Additional NAP per hour per referral
  static const int _sessionDurationHours = 12;
  
  static Timer? _miningTimer;
  static bool _isMining = false;
  
  // Start mining session
  static Future<void> startMining() async {
    if (_isMining) return;
    
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    
    // Save mining start time
    await prefs.setString('miningStartTime', now.toIso8601String());
    await prefs.setBool('isMining', true);
    
    _isMining = true;
    
    // Start background mining timer
    _miningTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateTokens();
    });
  }
  
  // Stop mining session
  static Future<void> stopMining() async {
    if (!_isMining) return;
    
    final prefs = await SharedPreferences.getInstance();
    
    // Calculate final tokens and save
    await _updateTokens();
    
    // Clear mining state
    await prefs.remove('miningStartTime');
    await prefs.setBool('isMining', false);
    
    _isMining = false;
    _miningTimer?.cancel();
  }
  
  // Check if currently mining
  static Future<bool> isMining() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isMining') ?? false;
  }
  
  // Get current token balance
  static Future<double> getTokenBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('tokenBalance') ?? 0.0;
  }
  
  // Update tokens based on mining time
  static Future<void> _updateTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final miningStartTimeString = prefs.getString('miningStartTime');
    
    if (miningStartTimeString == null) return;
    
    final miningStartTime = DateTime.parse(miningStartTimeString);
    final now = DateTime.now();
    final miningDuration = now.difference(miningStartTime);
    
    // Check if session has expired (12 hours)
    if (miningDuration.inHours >= _sessionDurationHours) {
      await stopMining();
      return;
    }
    
    // Calculate tokens earned
    final hoursElapsed = miningDuration.inMinutes / 60.0;
    final referralCount = prefs.getInt('referralCount') ?? 0;
    final totalRate = _baseRate + (referralCount * _referralBonus);
    final tokensEarned = hoursElapsed * totalRate;
    
    // Update balance
    final currentBalance = await getTokenBalance();
    await prefs.setDouble('tokenBalance', currentBalance + tokensEarned);
  }
  
  // Get mining rate per hour
  static Future<double> getMiningRate() async {
    final prefs = await SharedPreferences.getInstance();
    final referralCount = prefs.getInt('referralCount') ?? 0;
    return _baseRate + (referralCount * _referralBonus);
  }
  
  // Get remaining mining time
  static Future<Duration> getRemainingMiningTime() async {
    final prefs = await SharedPreferences.getInstance();
    final miningStartTimeString = prefs.getString('miningStartTime');
    
    if (miningStartTimeString == null) {
      return const Duration(hours: _sessionDurationHours);
    }
    
    final miningStartTime = DateTime.parse(miningStartTimeString);
    final now = DateTime.now();
    final elapsed = now.difference(miningStartTime);
    final remaining = Duration(hours: _sessionDurationHours) - elapsed;
    
    return remaining.isNegative ? Duration.zero : remaining;
  }
  
  // Add referral
  static Future<void> addReferral() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt('referralCount') ?? 0;
    await prefs.setInt('referralCount', currentCount + 1);
  }
  
  // Get referral count
  static Future<int> getReferralCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('referralCount') ?? 0;
  }
  
  // Initialize mining service (call on app start)
  static Future<void> initialize() async {
    final isMiningActive = await isMining();
    if (isMiningActive) {
      _isMining = true;
      // Resume mining timer
      _miningTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
        _updateTokens();
      });
    }
  }
  
  // Cleanup (call on app dispose)
  static void dispose() {
    _miningTimer?.cancel();
  }
}

