import 'package:att_2_flutter/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'Blocs/gastosfixos_bloc.dart';
import 'DataProviders/gastosfixos_data_provider.dart';
import 'Blocs/apartamentos_bloc.dart';

class GastosFixosPage extends StatefulWidget {
  const GastosFixosPage({Key? key}) : super(key: key);

  @override
  _GastosFixosPageState createState() => _GastosFixosPageState();
}

class _GastosFixosPageState extends State<GastosFixosPage> {
  void _adicionarGasto(String tipo) async {
    // Exibe um AlertDialog com um TextField para entrada de dados
    final valorController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar gasto'),
        content: TextField(
          controller: valorController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Valor'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Converte o valor digitado pelo usuário para double
              final valor = double.tryParse(valorController.text) ?? 0;
              // Envia um evento AdicionarGasto para o GastosFixosBloc
              context.read<GastosFixosBloc>().add(AdicionarGasto(tipo, valor));
              // Fecha o AlertDialog
              Navigator.pop(context);
            },
            child: Text('Adicionar'),
          ),
        ],
      ),
    );

    // Salva os dados dos gastos fixos no Firestore
    final apartmentBloc = context.read<ApartmentBloc>();
    final selectedApartment = apartmentBloc.state.selectedApartment;
    if (selectedApartment != null) {
      final gastosFixosBloc = context.read<GastosFixosBloc>();
      if (gastosFixosBloc.state is GastosFixosLoaded) {
        final currentState = gastosFixosBloc.state as GastosFixosLoaded;
        final updatedGastosFixos =
            Map<String, double>.from(currentState.gastosFixos);
        updatedGastosFixos[tipo] = double.tryParse(valorController.text) ?? 0;
        await context
            .read<GastosFixosDataProvider>()
            .saveGastosFixos(selectedApartment, updatedGastosFixos);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textColor,
        title: const Text('Gastos Fixos'),
      ),
      body: BlocBuilder<GastosFixosBloc, GastosFixosState>(
        builder: (context, state) {
          if (state is GastosFixosLoaded) {
            final gastosFixos = state.gastosFixos;
            final total = gastosFixos.values.fold(0.0, (a, b) => a + b);
            return Column(
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
                        child: Text('Total: R\$${total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headline4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Expanded(
                  child: gastosFixos.isEmpty
                      ? Center(
                          child: Text('Nenhum gasto fixo adicionado ainda.'))
                      : PieChart(
                          dataMap: gastosFixos,
                          animationDuration: Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: MediaQuery.of(context).size.width / 2,
                          colorList: [
                            Color.fromARGB(255, 255, 153, 0),
                            Colors.blue,
                            Color.fromARGB(255, 9, 167, 164),
                          ],
                          initialAngleInDegree: 0,
                          chartType: ChartType.disc,
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle:
                                TextStyle(fontWeight: FontWeight.bold),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: false,
                              decimalPlaces: 1),
                        ),
                ),
                const SizedBox(height: 90),
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          IconButton(
                              icon: Icon(Icons.lightbulb),
                              onPressed: () => _adicionarGasto('Luz')),
                          const Text('Luz'),
                        ]),
                        Column(children: [
                          IconButton(
                              icon: Icon(Icons.home),
                              onPressed: () => _adicionarGasto('Aluguel')),
                          const Text('Aluguel'),
                        ]),
                        Column(children: [
                          IconButton(
                              icon: Icon(Icons.wifi),
                              onPressed: () => _adicionarGasto('Internet')),
                          const Text('Internet'),
                        ]),
                      ]),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
