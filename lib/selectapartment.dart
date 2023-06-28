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
          title: Text('Selecione um apartamento'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mostra uma lista de botões para os apartamentos do usuário
              BlocBuilder<ApartmentBloc, ApartmentState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      for (String apartment in state.apartments)
                        ElevatedButton(
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
                          child: Text(apartment),
                        ),
                    ],
                  );
                },
              ),
              // Adiciona um botão para criar um novo apartamento
              ElevatedButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
