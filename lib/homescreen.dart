import 'package:att_2_flutter/Blocs/gastosvariaveis_bloc.dart';
import 'package:att_2_flutter/colors.dart';
import 'package:att_2_flutter/configura%C3%A7%C3%B5es.dart';
import 'package:flutter/material.dart';
import 'GastosFixos.dart';
import 'GastosVariaveis.dart';
import 'Moveis.dart';
import 'selectapartment.dart';
import 'bottomnavigationbar.dart';
import 'appscaffold.dart';
import 'Blocs/apartamentos_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Blocs/gastosfixos_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = [
    HomeContentScreen(),
    Moveis(),
    GastosFixosPage(),
    GastosVariaveis(),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      screens: _screens,
      bottomNavigationBarItems: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chair),
          label: 'Móveis',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Custos Fixos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.money_off),
          label: 'Custos Variáveis',
        ),
      ],
    );
  }
}

class HomeContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApartmentBloc, ApartmentState>(
      builder: (context, state) {
        // Acessa o apartamento selecionado a partir do estado do ApartmentBloc
        String? selectedApartment = state.selectedApartment;

        return Container(
          color: Colors.white,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          //apartamento selecionado
                          '$selectedApartment',
                          style: TextStyle(
                              fontSize: 22, color: AppColors.textColor),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.swap_horiz),
                            color: AppColors.textColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SelectApartmentScreen()),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.settings),
                            color: AppColors.textColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bem vindo!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.0),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Valor total acumulado:',
                                style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8.0),
                            BlocBuilder<GastosFixosBloc, GastosFixosState>(
                              builder: (context, gastosFixosState) {
                                return BlocBuilder<GastosVariaveisBloc,
                                    GastosVariaveisState>(
                                  builder: (context, gastosVariaveisState) {
                                    double total = 0.0;

                                    if (gastosFixosState is GastosFixosLoaded) {
                                      total += gastosFixosState
                                          .gastosFixos.values
                                          .fold(0.0, (a, b) => a + b);
                                    }

                                    if (gastosVariaveisState
                                        is GastosVariaveisListadosState) {
                                      total += gastosVariaveisState
                                          .gastosvariaveis
                                          .fold(
                                              0,
                                              (previousValue, element) =>
                                                  previousValue +
                                                  int.parse(element['valor']
                                                      .toString()));
                                    }

                                    return Text(
                                      'R\$ ${total.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(color: Colors.green),
                                    );
                                  },
                                );
                              },
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
