import 'package:english_words/english_words.dart';
import '../models/app_models.dart';

class AppController {
  final AppModel model;

  AppController(this.model);

  WordPair get current => model.current;

  Set<WordPair> get favorites => model.favorites;

  void getNext() => model.getNext();

  void toggleFavorite() => model.toggleFavorite();

  void removeFavorite(WordPair pair) => model.removeFavorite(pair);
}
