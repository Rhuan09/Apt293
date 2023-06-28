import 'package:att_2_flutter/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Blocs/apartamentos_bloc.dart';

class CreateApartmentScreen extends StatefulWidget {
  const CreateApartmentScreen({Key? key}) : super(key: key);

  @override
  _CreateApartmentScreenState createState() => _CreateApartmentScreenState();
}

class _CreateApartmentScreenState extends State<CreateApartmentScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textColor,
        title: Text('Criar novo apartamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nome do apartamento',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Adiciona o novo apartamento ao Cloud Firestore
                context
                    .read<ApartmentBloc>()
                    .add(AddApartment(_controller.text));
                // Redireciona para a tela de seleção de apartamentos
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
