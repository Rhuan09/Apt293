import 'package:att_2_flutter/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'moveis_bloc.dart';
import 'drawer.dart';
import 'Blocs/apartamentos_bloc.dart';
import 'dart:async';
import 'moveis_data_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Moveis extends StatelessWidget {
  // Adicione esta linha

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Móveis',
        ),
        backgroundColor: AppColors.textColor,
      ),
      body: BlocBuilder<ApartmentBloc, ApartmentState>(
        builder: (context, apartmentState) {
          // Acessa o apartamento selecionado a partir do estado do ApartmentBloc
          String? selectedApartment = apartmentState.selectedApartment;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _getMoveis(context, selectedApartment),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> moveis = snapshot.data!;
                return ListView.builder(
                  itemCount: moveis.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: moveis[index]['imageUrl'] != null
                          ? Image.network(moveis[index]['imageUrl'])
                          : null,
                      title: Text(moveis[index]['name']),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: PopupMenuButton<String>(
        icon: const Icon(Icons.add),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'adicionar',
            child: ListTile(
              leading: Icon(Icons.add),
              title: Text('Adicionar'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'editar',
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Editar'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'excluir',
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Excluir'),
            ),
          ),
        ],
        onSelected: (String value) {
          if (value == 'adicionar') {
            _adicionarMovel(context, ScaffoldMessenger.of(context));
          } else if (value == 'editar') {
            _editarMovel(context, ScaffoldMessenger.of(context));
          } else if (value == 'excluir') {
            _excluirMovel(context, ScaffoldMessenger.of(context));
          }
        },
        tooltip: 'Opções',
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getMoveis(
      BuildContext context, String? apartment) async {
    // Acessa o MoveisBloc
    MoveisBloc moveisBloc = BlocProvider.of<MoveisBloc>(context);

    // Cria um Completer para aguardar a resposta do MoveisBloc
    Completer<List<Map<String, dynamic>>> completer = Completer();

    // Adiciona um listener ao MoveisBloc para aguardar a resposta
    StreamSubscription subscription = moveisBloc.stream.listen((state) {
      if (state is MoveisListadosState) {
        // Completa o Completer com a lista de móveis retornada pelo MoveisBloc
        completer.complete(state.moveis);
      } else if (state is MovelErrorState) {
        // Completa o Completer com um erro se ocorrer um erro ao obter a lista de móveis
        completer.completeError(state.message);
      }
    });

    // Envia um evento ListarMoveisEvent para o MoveisBloc para obter a lista de móveis
    moveisBloc.add(ListarMoveisEvent(apartment!)); // Use a variável userId aqui

    // Aguarda a resposta do MoveisBloc
    List<Map<String, dynamic>> moveis = await completer.future;

    // Cancela o listener do MoveisBloc
    await subscription.cancel();

    return moveis;
  }
}

void _adicionarMovel(
    BuildContext context, ScaffoldMessengerState scaffoldMessenger) {
  String nomeMovel = ''; // Variável para armazenar o valor do campo de texto
  XFile? imagemMovel; // Variável para armazenar a imagem do móvel

  // Define as variáveis userId e apartmentId com os valores corretos
  final apartmentBloc = BlocProvider.of<ApartmentBloc>(context);
  final apartmentId = apartmentBloc.state.selectedApartment;

  // Cria um ImagePicker
  final ImagePicker _picker = ImagePicker();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Adicionar Móvel"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onChanged: (value) {
                    nomeMovel = value; // Atualiza o valor do campo de texto
                  },
                  decoration: const InputDecoration(hintText: "Nome do móvel"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Verifica se o aplicativo tem permissão para acessar a galeria de fotos
                    var status = await Permission.photos.status;
                    if (status.isDenied) {
                      // Solicita permissão para acessar a galeria de fotos
                      status = await Permission.photos.request();
                    }

                    if (status.isGranted) {
                      // Abre a galeria de fotos para o usuário escolher uma imagem
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);

                      // Atualiza a variável imagemMovel com a imagem escolhida pelo usuário
                      setState(() {
                        imagemMovel = image;
                      });
                    } else {
                      // Exibe uma mensagem de erro se o usuário não conceder permissão
                      scaffoldMessenger.showSnackBar(const SnackBar(
                        content:
                            Text('Permissão para acessar a galeria negada.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                  child: const Text('Escolher imagem'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  BlocProvider.of<MoveisBloc>(context).add(AdicionarMovelEvent(
                      nomeMovel, apartmentId!, imagemMovel));
                  scaffoldMessenger.showSnackBar(const SnackBar(
                    content: Text('Item adicionado com sucesso!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ));
                  Navigator.pop(context);
                },
                child: const Text("Adicionar"),
              ),
            ],
          );
        },
      );
    },
  );
}

void _editarMovel(
    BuildContext context, ScaffoldMessengerState scaffoldMessenger) {
  String movelAntigo = ''; // Variável para armazenar o valor do campo de texto
  String movelNovo = ''; // Variável para armazenar o valor do campo de texto

  // Define as variáveis userId e apartmentId com os valores corretos
  final apartmentBloc = BlocProvider.of<ApartmentBloc>(context);
  final apartmentId = apartmentBloc.state.selectedApartment;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Editar Móvel"),
        content: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                movelAntigo = value; // Atualiza o valor do campo de texto
              },
              decoration:
                  const InputDecoration(hintText: "Nome do móvel antigo"),
            ),
            TextFormField(
              onChanged: (value) {
                movelNovo = value; // Atualiza o valor do campo de texto
              },
              decoration: const InputDecoration(hintText: "Nome do móvel novo"),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<MoveisBloc>(context).add(AtualizarMovelEvent(
                  movelAntigo,
                  movelNovo,
                  apartmentId!)); // Passa os valores corretos para o evento
              scaffoldMessenger.showSnackBar(const SnackBar(
                content: Text('Item editado com sucesso!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ));
              Navigator.pop(context);
            },
            child: const Text("Editar"),
          ),
        ],
      );
    },
  );
}

void _excluirMovel(
    BuildContext context, ScaffoldMessengerState scaffoldMessenger) {
  String movel = ''; // Variável para armazenar o valor do campo de texto

  // Define as variáveis userId e apartmentId com os valores corretos
  final apartmentBloc = BlocProvider.of<ApartmentBloc>(context);
  final apartmentId = apartmentBloc.state.selectedApartment;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Excluir Móvel"),
        content: TextFormField(
          onChanged: (value) {
            movel = value; // Atualiza o valor do campo de texto
          },
          decoration: const InputDecoration(hintText: "Nome do móvel"),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<MoveisBloc>(context).add(RemoverMovelEvent(movel,
                  apartmentId!)); // Passa os valores corretos para o evento
              scaffoldMessenger.showSnackBar(const SnackBar(
                content: Text('Item excluído com sucesso!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ));
              Navigator.pop(context);
            },
            child: const Text("Excluir"),
          ),
        ],
      );
    },
  );
}
