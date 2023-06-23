import 'package:att_2_flutter/GastosFixos.dart';
import 'package:att_2_flutter/GastosVariaveis.dart';
import 'Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Moveis.dart'; // Importe o arquivo moveis.dart
import 'moveis_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'moveis_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => MoveisBloc(MoveisDataProvider()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Apto 293",
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                print(
                    'Alteração no estado de autenticação: ${snapshot.data?.email}');
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    // O usuário está autenticado
                    return Scaffold(
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
                    );
                  } else {
                    // O usuário não está autenticado
                    // Redireciona para a tela de login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                    return Container();
                  }
                } else {
                  // O estado de autenticação ainda não está estabilizado
                  // Mostra um indicador de progresso
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
        '/moveis': (context) => Moveis(),
        '/login': (context) => Login(),
        '/gastosFixos': (context) => GastosFixos(),
        '/gastosariaveis': (context) => GastosVariaveis(),
      },
    );
  }
}
