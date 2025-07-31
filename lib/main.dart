import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    title: "First Flutter App",
    center: true,
    size: Size(800, 600),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // 👈 Turn off debug banner
        title: 'First Flutter App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>{};

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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  bool isRailExtended = true;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritePage();
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    // Burger menu button
                    IconButton(
                      icon: Icon(Icons.menu),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        setState(() {
                          isRailExtended = !isRailExtended;
                        });
                      },
                    ),
                    Expanded(
                      child: NavigationRail(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        extended: isRailExtended,
                        destinations: [
                          NavigationRailDestination(
                            icon: Icon(
                              Icons.home_outlined,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            label: Text(
                              'Home',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            selectedIcon: Icon(Icons.home),
                          ),
                          NavigationRailDestination(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            label: Text(
                              'Favorites',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            selectedIcon: Icon(Icons.favorite),
                          ),
                        ],
                        selectedIndex: selectedIndex,
                        onDestinationSelected: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData favoriteIcon;
    if (appState.favorites.contains(pair)) {
      favoriteIcon = Icons.favorite;
    } else {
      favoriteIcon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(favoriteIcon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text(
          'No favorites yet!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have '
            '${appState.favorites.length} favorites:',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Wrap(
            clipBehavior: Clip.hardEdge,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var pair in appState.favorites)
                Chip(
                  elevation: 4,
                  avatar: Icon(
                    Icons.favorite_border_outlined,
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                    size: 20,
                  ),
                  label: Text(pair.asPascalCase),
                  deleteIcon: Icon(Icons.close),
                  deleteIconColor: Theme.of(context).colorScheme.onPrimaryFixed,
                  deleteButtonTooltipMessage: 'Remove from favorites',
                  onDeleted: () {
                    appState.removeFavorite(pair);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${pair.asPascalCase} removed from favorites',
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimaryFixedVariant,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asPascalCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
