import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'moveis_bloc.dart';
import 'drawer.dart';

class Moveis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Móveis',
        ),
        backgroundColor: const Color(0xff764abc),
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<MoveisBloc, MoveisState>(
        builder: (context, state) {
          if (state is MoveisListadosState) {
            return ListView.builder(
              itemCount: state.moveis.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.moveis[index]),
                );
              },
            );
          } else if (state is MovelErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
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
            value: 'pesquisar',
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text('Pesquisar'),
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
          } else if (value == 'pesquisar') {
            // Código para pesquisar um móvel
          } else if (value == 'excluir') {
            _excluirMovel(context, ScaffoldMessenger.of(context));
          }
        },
        tooltip: 'Opções',
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _adicionarMovel(
      BuildContext context, ScaffoldMessengerState scaffoldMessenger) {
    String nomeMovel = ''; // Variável para armazenar o valor do campo de texto

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Adicionar Móvel"),
          content: TextFormField(
            onChanged: (value) {
              nomeMovel = value; // Atualiza o valor do campo de texto
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
                BlocProvider.of<MoveisBloc>(context).add(AdicionarMovelEvent(
                    nomeMovel)); // Passa o valor do campo de texto para o evento
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
  }

  void _excluirMovel(
      BuildContext context, ScaffoldMessengerState scaffoldMessenger) {
    String nomeMovel = ''; // Variável para armazenar o valor do campo de texto

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Excluir Móvel"),
          content: TextFormField(
            onChanged: (value) {
              nomeMovel = value; // Atualiza o valor do campo de texto
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
                BlocProvider.of<MoveisBloc>(context).add(RemoverMovelEvent(
                    nomeMovel)); // Passa o valor do campo de texto para o evento
                scaffoldMessenger.showSnackBar(const SnackBar(
                  content: Text('Item excluído com sucesso!'),
                  backgroundColor: Colors.red,
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
}
