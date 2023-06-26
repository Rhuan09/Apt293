import 'package:att_2_flutter/colors.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class GastosFixosPage extends StatefulWidget {
  const GastosFixosPage({Key? key}) : super(key: key);

  @override
  _GastosFixosPageState createState() => _GastosFixosPageState();
}

class _GastosFixosPageState extends State<GastosFixosPage> {
  double _luz = 0.0;
  double _aluguel = 0.0;
  double _internet = 0.0;

  double get _total => _luz + _aluguel + _internet;

  Map<String, double> get _dataMap => {
        'Luz': _luz,
        'Aluguel': _aluguel,
        'Internet': _internet,
      };

  void _adicionarGasto(String tipo) {
    // Adicione o código para adicionar um gasto aqui
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textColor,
        title: const Text('Gastos Fixos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Total: R\$${_total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headline4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Expanded(
            child: PieChart(
              dataMap: _dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 2,
              colorList: [
                Colors.yellow,
                Colors.blue,
                Colors.green,
              ],
              initialAngleInDegree: 0,
              chartType: ChartType.disc,
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
                decimalPlaces: 1,
              ),
            ),
          ),
          const SizedBox(height: 90), // Adiciona um espaçamento de 16 pixels
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.lightbulb),
                      onPressed: () => _adicionarGasto('Luz'),
                    ),
                    const Text('Luz'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () => _adicionarGasto('Aluguel'),
                    ),
                    const Text('Aluguel'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.wifi),
                      onPressed: () => _adicionarGasto('Internet'),
                    ),
                    const Text('Internet'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
