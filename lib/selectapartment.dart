import 'package:att_2_flutter/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Blocs/apartamentos_bloc.dart';
import 'homescreen.dart';
import 'createapartment.dart';
import 'Blocs/gastosfixos_bloc.dart';
import 'Blocs/gastosvariaveis_bloc.dart';

class SelectApartmentScreen extends StatefulWidget {
  const SelectApartmentScreen({Key? key}) : super(key: key);

  @override
  _SelectApartmentScreenState createState() => _SelectApartmentScreenState();
}

class _SelectApartmentScreenState extends State<SelectApartmentScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega os apartamentos do usuário quando a tela é inicializada
    context.read<ApartmentBloc>().add(LoadApartments());
  }

  @override
  Widget build(BuildContext context) {
    String apartmentName = '';

    return BlocListener<ApartmentBloc, ApartmentState>(
      listenWhen: (previous, current) {
        return previous.selectedApartment != current.selectedApartment;
      },
      listener: (context, state) {
        context
            .read<GastosFixosBloc>()
            .add(ApartamentoSelecionado(state.selectedApartment));
        context
            .read<GastosVariaveisBloc>()
            .add(ListarGastosVariaveisEvent(state.selectedApartment!));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.textColor,
          title: Text('Selecione um apartamento'),
        ),
        body: Column(
          children: [
            // Mostra uma lista de ícones para os apartamentos do usuário
            Expanded(
              child: BlocBuilder<ApartmentBloc, ApartmentState>(
                builder: (context, state) {
                  return Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: [
                      for (String apartment in state.apartments)
                        Column(
                          children: [
                            IconButton(
                              iconSize: 48,
                              icon: Icon(Icons.house),
                              onPressed: () {
                                // Atualiza o estado do apartamento selecionado
                                context
                                    .read<ApartmentBloc>()
                                    .add(SelectApartment(apartment));
                                // Redireciona para a tela inicial
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              },
                            ),
                            Text(apartment),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
            // Adiciona um botão para criar um novo apartamento
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Redireciona para a tela de criação de apartamento
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateApartmentScreen(),
                      ),
                    );
                  },
                  child: Text('Criar novo apartamento'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textColor,
                  ),
                ),
              ),
            ),
            // Adiciona um botão para excluir um apartamento
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Digite o nome do apartamento'),
                          content: TextField(
                            onChanged: (value) {
                              apartmentName = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Aqui você pode chamar o método para excluir o apartamento
                                context
                                    .read<ApartmentBloc>()
                                    .add(RemoveApartment(apartmentName));
                                Navigator.of(context).pop();
                              },
                              child: Text('Excluir'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                  label: Text('Excluir apartamento'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
