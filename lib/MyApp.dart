import 'package:att_2_flutter/DataProviders/apartamentos_data_provider.dart';
import 'package:att_2_flutter/GastosFixos.dart';
import 'package:att_2_flutter/GastosVariaveis.dart';
import 'Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Moveis.dart'; // Importe o arquivo moveis.dart
import 'moveis_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'moveis_data_provider.dart';
import 'selectapartment.dart';
import 'Blocs/apartamentos_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => MoveisBloc(MoveisDataProvider()),
        ),
        // Adiciona um BlocProvider para o ApartmentBloc
        BlocProvider(
          create: (context) => ApartmentBloc(ApartamentosDataProvider(),
              FirebaseAuth.instance.currentUser!.uid),
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
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    // O usuário está autenticado
                    // Mostra a tela SelectApartmentScreen
                    return SelectApartmentScreen();
                  } else {
                    // O usuário não está autenticado
                    // Mostra a tela de login
                    return Login();
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
