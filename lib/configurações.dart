import 'package:att_2_flutter/Login.dart';
import 'package:att_2_flutter/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textColor,
        title: Text('Configurações'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Desconectar'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),
    );
  }
}
