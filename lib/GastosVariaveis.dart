import 'dart:ffi';

import 'package:att_2_flutter/colors.dart';
import 'package:flutter/material.dart';
import 'Blocs/apartamentos_bloc.dart';
import 'Blocs/gastosvariaveis_bloc.dart';
import 'DataProviders/apartamentos_data_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class GastosVariaveis extends StatelessWidget {
  const GastosVariaveis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apartmentBloc = BlocProvider.of<ApartmentBloc>(context);
    final apartmentId = apartmentBloc.state.selectedApartment;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.textColor,
          title: Text('Gastos Variáveis'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Exibidor de gastos variáveis atuais
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Gastos variáveis atuais',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8.0),
                    BlocBuilder<GastosVariaveisBloc, GastosVariaveisState>(
                      builder: (context, state) {
                        if (state is GastosVariaveisListadosState) {
                          final total = state.gastosvariaveis.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue +
                                  int.parse(element['valor'].toString()));
                          return Text(
                            'R\$ $total',
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.green),
                          );
                        } else {
                          return Text('Carregando...');
                        }
                      },
                    ),
                    Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.local_pizza),
                          title: Text('Alimentação'),
                          trailing: BlocBuilder<GastosVariaveisBloc,
                              GastosVariaveisState>(
                            builder: (context, state) {
                              if (state is GastosVariaveisListadosState) {
                                final totalAlimentacao = state.gastosvariaveis
                                    .where((element) =>
                                        element['tipo'] == 'Alimentação')
                                    .fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue +
                                            int.parse(
                                                element['valor'].toString()));
                                return Text('R\$ $totalAlimentacao');
                              } else {
                                return Text('Carregando...');
                              }
                            },
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.build),
                          title: Text('Reparos'),
                          trailing: BlocBuilder<GastosVariaveisBloc,
                              GastosVariaveisState>(
                            builder: (context, state) {
                              if (state is GastosVariaveisListadosState) {
                                final totalReparos = state.gastosvariaveis
                                    .where((element) =>
                                        element['tipo'] == 'Reparos')
                                    .fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue +
                                            int.parse(
                                                element['valor'].toString()));
                                return Text('R\$ $totalReparos');
                              } else {
                                return Text('Carregando...');
                              }
                            },
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.soap),
                          title: Text('Limpeza'),
                          trailing: BlocBuilder<GastosVariaveisBloc,
                              GastosVariaveisState>(
                            builder: (context, state) {
                              if (state is GastosVariaveisListadosState) {
                                final totalLimpeza = state.gastosvariaveis
                                    .where((element) =>
                                        element['tipo'] == 'Limpeza')
                                    .fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue +
                                            int.parse(
                                                element['valor'].toString()));
                                return Text('R\$ $totalLimpeza');
                              } else {
                                return Text('Carregando...');
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Botões para adicionar gastos
            Column(
              children: [
                // Botão para adicionar gastos
                ElevatedButton(
                  onPressed: () {
                    _adicionarGastos(context, ScaffoldMessenger.of(context));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.textColor,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  child: Text('Adicionar Gastos'),
                ),
                SizedBox(height: 16.0),
                // Botão para abrir popup com lista de todos os gastos
                ElevatedButton(
                  onPressed: () {
                    _exibirGastos(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textColor),
                  child: Text('Ver lista de gastos'),
                ),
              ],
            )
          ]),
        ));
  }

  void _editarGastos(
      BuildContext context, ScaffoldMessengerState scaffoldMessenger) {
    String gastoAntigo =
        ''; // Variável para armazenar o valor do campo de texto
    String gastoNovo = ''; // Variável para armazenar o valor do campo de texto

    // Define as variáveis userId e apartmentId com os valores corretos
    final apartmentBloc = BlocProvider.of<ApartmentBloc>(context);
    final apartmentId = apartmentBloc.state.selectedApartment;
  }

  void _adicionarGastos(
      BuildContext context, ScaffoldMessengerState scaffoldMessenger) {
    String nomeGasto = ''; // Variável para armazenar o valor do campo de texto
    String tipoGasto = '';
    String valorgasto =
        ''; // variável para armazenar o valor escolhido pelo usuário

    // Define as variáveis userId e apartmentId com os valores corretos
    final apartmentBloc = BlocProvider.of<ApartmentBloc>(context);
    final apartmentId = apartmentBloc.state.selectedApartment;

    // Cria um ImagePicker
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text("Adicionar um gasto!"),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                    onChanged: (value) {
                      nomeGasto = value; // Atualiza o valor do campo de texto
                    },
                    decoration:
                        const InputDecoration(hintText: "Insira o Gasto"),
                  ),
                  TextFormField(
                    onChanged: (custo) {
                      valorgasto = custo;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                        hintText: "Insira o valor do gasto"),
                  ),
                  DropdownButtonFormField<String>(
                    onChanged: (String? newValue) {
                      setState(() {
                        tipoGasto =
                            newValue!; // atualiza o valor de tipoGasto com o valor escolhido pelo usuário
                      });
                    },
                    decoration:
                        const InputDecoration(hintText: "Selecione o tipo"),
                    items: [
                      DropdownMenuItem(
                        child: Text('Alimentação'),
                        value: 'Alimentação',
                      ),
                      DropdownMenuItem(
                        child: Text('Reparos'),
                        value: 'Reparos',
                      ),
                      DropdownMenuItem(
                        child: Text('Limpeza'),
                        value: 'Limpeza',
                      ),
                    ],
                  )
                ]),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar"),
                  ),
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<GastosVariaveisBloc>(context).add(
                          AdicionarGastosVariaveisEvent(
                              nomeGasto, apartmentId!, tipoGasto, valorgasto));
                      scaffoldMessenger.showSnackBar(const SnackBar(
                        content: Text('Item adicionado com sucesso!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ));
                      Navigator.pop(context);
                    },
                    child: const Text("Adicionar"),
                  )
                ]);
          });
        });
  }

  void _exibirGastos(BuildContext context) {
    final apartmentBloc = BlocProvider.of<ApartmentBloc>(context);
    final apartmentId = apartmentBloc.state.selectedApartment;

    BlocProvider.of<GastosVariaveisBloc>(context)
        .add(ListarGastosVariaveisEvent(apartmentId!));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<GastosVariaveisBloc, GastosVariaveisState>(
          builder: (context, state) {
            if (state is GastosVariaveisListadosState) {
              return AlertDialog(
                title: Text('Gastos'),
                content: SizedBox(
                  height: 300,
                  width: 300,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      itemCount: state.gastosvariaveis.length,
                      itemBuilder: (BuildContext context, int index) {
                        final gasto = state.gastosvariaveis[index];
                        return Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(gasto['gasto']),
                                  Text(gasto['tipo']),
                                  Text(gasto['valor']),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      BlocProvider.of<GastosVariaveisBloc>(
                                              context)
                                          .add(RemoveGastoVariavelEvent(
                                              gasto['id'], apartmentId));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Fechar'),
                  ),
                ],
              );
            } else if (state is GastosVariaveisErrorState) {
              return AlertDialog(
                title: Text('Erro'),
                content: Text(state.message),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Fechar'),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
