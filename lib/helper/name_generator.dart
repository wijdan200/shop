import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class NameGenerator {
  static final List<String> _adjectives = [
     'Happy', 'Clever', 'Quiet' 'Gentle',
    'Lucky', 'Cool', 'Swift'
  ];

  static final List<String> _nouns = [
    'Panda',  'Lion', 'Penguin', 
    'Bear',  'Dolphin'
  ];

  static String getDisplayName(User? user) {
    if (user == null) {
      return _generateAnonymousName('guest');
    }

    final String? fullName = user.displayName;
    if (fullName != null && fullName.isNotEmpty) {
      // Return first name
      return fullName.split(' ').first;
    }

    // Generate nickname based on user id to keep it consistent
    return _generateAnonymousName(user.uid);
  }

  static String _generateAnonymousName(String seedString) {
    int seed = seedString.hashCode;
    final random = Random(seed);
    final adj = _adjectives[random.nextInt(_adjectives.length)];
    final noun = _nouns[random.nextInt(_nouns.length)];
    return '$adj $noun';
  }
}
