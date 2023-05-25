import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'moveis_bloc.dart';
import 'moveis_data_provider.dart';
import 'Moveis.dart'; // Importe o arquivo moveis.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox<double>('_box');
  await Firebase.initializeApp();

  // Crie uma instância do MoveisDataProvider
  final moveisDataProvider = MoveisDataProvider();
  // Crie uma instância do MoveisBloc e passe o MoveisDataProvider como parâmetro
  final moveisBloc = MoveisBloc(moveisDataProvider);

  runApp(BlocProvider<MoveisBloc>.value(
    value: moveisBloc,
    child: MyApp(moveisBloc: moveisBloc),
  ));
}

class MyApp extends StatelessWidget {
  final MoveisBloc moveisBloc;

  const MyApp({Key? key, required this.moveisBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Apto 293",
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Apto 293'),
                backgroundColor: const Color(0xff764abc),
              ),
              drawer: AppDrawer(),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo293.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Apto 293',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'O app perfeito para organizar a vida em um apartamento compartilhado. Cadastre seus móveis, divida os gastos fixos e variáveis, e mantenha um histórico das compras conjuntas. Tudo de forma simples e fácil!',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        '/moveis': (context) => Moveis(), // Remova o parâmetro moveisBloc
      },
    );
  }
}
