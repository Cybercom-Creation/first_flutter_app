import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';

class AppModel extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>{};

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}
