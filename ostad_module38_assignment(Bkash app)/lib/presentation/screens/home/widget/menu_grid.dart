import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/home_provider.dart';
import 'menu_grid_item.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        final items = provider.visibleItems;
        final isExpanded = provider.isExpanded;

        return Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.78,
                mainAxisSpacing: 8,
                crossAxisSpacing: 10,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return MenuGridItem(item: items[index]);
              },
            ),
            OutlinedButton.icon(
              onPressed: provider.toggleExpanded,
              label: Text(isExpanded ? 'Show Less' : 'Show More'),
            ),
          ],
        );
      },
    );
  }
}
