import 'package:flutter/material.dart';
import 'generator_page.dart';
import 'favorites_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  bool isRailExtended = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isMobile = MediaQuery.of(context).size.width < 600;
    // Only set on first build to avoid resetting on every rebuild
    if (isRailExtended != !isMobile) {
      setState(() {
        isRailExtended = !isMobile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page = selectedIndex == 0 ? GeneratorPage() : FavoritePage();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: NavigationRail(
                          backgroundColor: Colors.transparent,
                          extended: isRailExtended,
                          leading: IconButton(
                            icon: const Icon(Icons.menu),
                            color: Theme.of(context).colorScheme.onPrimary,
                            onPressed: () {
                              setState(() => isRailExtended = !isRailExtended);
                            },
                          ),
                          destinations: [
                            navDestination(Icons.home_outlined, 'Home'),
                            navDestination(Icons.favorite_border, 'Favorites'),
                          ],
                          selectedIndex: selectedIndex,
                          onDestinationSelected: (index) {
                            setState(() => selectedIndex = index);
                          },
                        ),
                      ),
                    ],
                  ),
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

  NavigationRailDestination navDestination(IconData icon, String label) {
    return NavigationRailDestination(
      icon: Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
      selectedIcon: Icon(icon),
      label: Text(
        label,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
