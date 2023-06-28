import 'package:att_2_flutter/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.textColor,
          title: Text('Cadastro'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide.none, // remove a borda do campo de texto
                      ),
                    ),
                    obscureText:
                        true, // oculta o texto digitado para proteger a senha
                    validator: (value) {
                      // valida se o valor digitado é válido
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                      height:
                          30.0), // adiciona um espaço entre o campo de senha e o botão
                  ElevatedButton(
                    onPressed: () async {
                      // chama o método para cadastrar o usuário
                      if (_formKey.currentState!.validate()) {
                        try {
                          // Cria um novo usuário com o Firebase Authentication
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: _emailController
                                .text, // usa o email digitado pelo usuário
                            password: _passwordController
                                .text, // usa a senha digitada pelo usuário
                          );
                          // Cria um novo documento de usuário no Firestore
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userCredential.user!.uid)
                              .set({
                            'name': _nameController.text,
                            'email': _emailController.text,
                          });
                          // Volta para a tela de login
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          // Trata erros do Firebase Authentication
                          if (e.code == 'weak-password') {
                            // Senha fraca
                          } else if (e.code == 'email-already-in-use') {
                            // Email já cadastrado
                          }
                        } catch (e) {
                          // Trata outros erros
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        // define o estilo do botão
                        primary: AppColors
                            .textColor, // define a cor de fundo do botão
                        shape: RoundedRectangleBorder(
                            // define a forma do botão como retangular com bordas arredondadas
                            borderRadius: BorderRadius.circular(
                                8)), // define o raio das bordas arredondadas do botão
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical:
                                12)), // define o espaçamento interno do botão para aumentar seu tamanho
                    child: const Text('Cadastrar',
                        style: TextStyle(
                            fontSize:
                                18)), // define o texto e o tamanho da fonte do botão
                  ),
                ],
              ),
            )));
  }
}
