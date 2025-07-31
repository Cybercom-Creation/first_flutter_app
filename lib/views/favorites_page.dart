import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = AppController(context.watch());

    if (controller.favorites.isEmpty) {
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
            'You have ${controller.favorites.length} favorites:',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.favorites.map((pair) {
              return Chip(
                elevation: 4,
                avatar: Icon(
                  Icons.favorite_border_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                  size: 20,
                ),
                label: Text(pair.asPascalCase),
                deleteIcon: const Icon(Icons.close),
                deleteIconColor: Theme.of(context).colorScheme.onPrimaryFixed,
                deleteButtonTooltipMessage: 'Remove from favorites',
                onDeleted: () {
                  controller.removeFavorite(pair);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${pair.asPascalCase} removed from favorites',
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimaryFixedVariant,
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
