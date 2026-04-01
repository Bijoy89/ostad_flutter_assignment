import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_strings.dart';
import '../provider/converter_provider.dart';
import '../widget/category_selector.dart';
import '../widget/input_field.dart';
import '../widget/result_card.dart';
import '../widget/unit_drop_down.dart';


class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConverterProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.chooseCategory,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Center(child: CategorySelector()),
            Text(
              AppStrings.enterValue,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            InputField(),
            Text(
              AppStrings.selectUnits,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Expanded(
                  child: UnitDropdown(
                    label: AppStrings.fromLabel,
                    selectedUnit: provider.fromUnit,
                    units: provider.currentUnits,
                    onChanged: (value) {
                      context.read<ConverterProvider>().updateFromUnit(value!);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () => context.read<ConverterProvider>().swap(),
                  icon: Icon(Icons.swap_horiz),
                ),
                Expanded(
                  child: UnitDropdown(
                    label: AppStrings.toLabel,
                    selectedUnit: provider.toUnit,
                    units: provider.currentUnits,
                    onChanged: (value) {
                      context.read<ConverterProvider>().updateToUnit(value!);
                    },
                  ),
                ),
              ],
            ),
            ResultCard(),
          ],
        ),
      ),
    );
  }
}