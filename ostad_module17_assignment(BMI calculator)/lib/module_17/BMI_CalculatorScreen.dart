import 'package:flutter/material.dart';

enum WeightType { Kg, lb }

enum HeightType { cm, meter, feetInch }

class BMI_CalculatorScreen extends StatefulWidget {
  const BMI_CalculatorScreen({super.key});

  @override
  State<BMI_CalculatorScreen> createState() => _BMI_CalculatorScreenState();
}

class _BMI_CalculatorScreenState extends State<BMI_CalculatorScreen> {
  WeightType weightType = WeightType.Kg;
  HeightType heightType = HeightType.cm;

  final weightController = TextEditingController();
  final cmctr = TextEditingController();
  final meterController = TextEditingController();
  final feetctr = TextEditingController();
  final inchctr = TextEditingController();

  String _bmiResult = '';

  String? category;

  Color categoryColor(String category) {
    switch (category) {
      case "Underweight":
        return Colors.blue;
      case "Normal":
        return Colors.green;
      case "Overweight":
        return Colors.orange;
      case "Obese":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String categoryResult(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    }
    if (bmi < 25) {
      return "Normal";
    }
    if (bmi < 30) {
      return "Overweight";
    }
    return "Obese";
  }

  double? getWeightInKg() {
    final weight = double.tryParse(weightController.text.trim());
    if (weight == null || weight <= 0) {
      showError("Invalid weight value");
      return null;
    }
    if(weightType==WeightType.Kg){
      return weight;
    }else{
      //1 lb =0.453592 kg
      return weight*0.453592;
    }
  }
  double? getHeightInMeter(){
    switch(heightType){
      case HeightType.cm:
        final cm=double.tryParse(cmctr.text.trim());
        if(cm==null||cm<=0){
          showError("Invalid cm value");
          return null;
        }
        return cm/100.0;
      case HeightType.meter:
        final meter=double.tryParse(meterController.text.trim());
        if(meter==null||meter<=0){
          showError("Invalid meter value");
          return null;
        }
        return meter;
      case HeightType.feetInch:
        double ? feet=double.tryParse(feetctr.text.trim());
        double ? inch=double.tryParse(inchctr.text.trim());
        if(feet==null||feet<0||inch==null||inch<0){
          showError("Invalid feet/inch value");
          return null;
        }
        if(inch>=12){
          feet+=(inch ~/12);
          inch=inch%12;

        }
        final totalInches=(feet*12)+inch;
        return totalInches*0.0254;//1 inch=0.0254m

    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
  }


  void _calculator() {
    final weight = getWeightInKg();
    final height = getHeightInMeter();

    if (weight == null || height==null) return;

    final bmi = weight / (height * height);
    final cat= categoryResult(bmi);

    setState(() {
      _bmiResult = bmi.toStringAsFixed(1);
      category = cat;

      weightController.clear();
      cmctr.clear();
      meterController.clear();
      feetctr.clear();
      inchctr.clear();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    weightController.dispose();
    cmctr.dispose();
    meterController.dispose();
    feetctr.dispose();
    inchctr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BMI Calculator")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Weight Unit",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8,),
          SegmentedButton<WeightType>(
              segments: const [
                ButtonSegment<WeightType>(
                  value: WeightType.Kg,
                  label: Text("KG"),
                ),
                ButtonSegment<WeightType>(
                  value: WeightType.lb,
                  label: Text("LB"),
                ),
              ],
              selected: {weightType},
              onSelectionChanged: (value) =>
                  setState(() => weightType = value.first)
          
          ),
          const SizedBox(height: 12,),
          
          TextFormField(
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: weightType ==WeightType.Kg
              ? 'Weight(Kg)'
              : 'Weight(lb)',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            "Height Unit",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          SegmentedButton<HeightType>(
            segments: const [
               ButtonSegment<HeightType>(
                value: HeightType.cm,
                label: Text("CM"),
              ),
               ButtonSegment<HeightType>(
                value: HeightType.meter,
                label: Text("Meter"),
              ),

               ButtonSegment<HeightType>(
                value: HeightType.feetInch,
                label: Text("Feet + Inch"),
              ),
            ],
            selected: {heightType},
            onSelectionChanged: (value) =>
                setState(() => heightType = value.first),
          ),

          const SizedBox(height: 12),

          if (heightType == HeightType.cm) ...[
            TextFormField(
              controller: cmctr,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Height(cm)',
                border: OutlineInputBorder(),
              ),
            ),
          ]else if(heightType == HeightType.meter)...[
            TextFormField(
              controller: meterController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Height(meter)',
                border: OutlineInputBorder(),
              ),
              
            ),
          ] 
          
          else ...[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: feetctr,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: "Feet('ft)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8,),

                Expanded(
                  child: TextFormField(
                    controller: inchctr,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: "Inch (\")",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: _calculator,
              child: const Text("Calculate BMI ")
          ),
          const SizedBox(height: 24),
          if(_bmiResult.isNotEmpty && category !=null)
            Card(
              elevation: 4,
              shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Your BMI is $_bmiResult",
                       style: const TextStyle(
                         fontSize: 22,
                         fontWeight: FontWeight.bold
                       ),
                    ),
                    const SizedBox(height: 12,),
                    Chip(
                        label: Text(
                          category!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      backgroundColor: categoryColor(category!),
                    )
                  ],
                ),
              ),
            )

        ],
      ),
    );
  }
}
