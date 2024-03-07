import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class LoginProvider extends ChangeNotifier {
  Future<void> signIn(
      String username, String password, BuildContext context) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        _showSnackBar(context, 'Preencha todos os campos');
        return;
      }
      final ParseUser user = ParseUser(username, password, null);
      final response = await user.login();

      if (response.success) {
        // Login bem-sucedido
        print('Login bem-sucedido: ${user.objectId}');
        Navigator.pushReplacementNamed(context, '/ranking');
      } else {
        // Tratar erro de login
        _showSnackBar(
            context, 'Erro ao fazer login: ${response.error!.message}');
      }
      notifyListeners();
    } catch (e) {
      print('Erro ao fazer login: $e');
      rethrow;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../assets/login.png',
              width: 200, // largura do logo
              height: 200, // altura do logo
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white)),
              obscureText: true,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.black), // Cor de fundo preta
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            6.0), // Borda levemente arredondada
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(200, 50)), // Tamanho mínimo do botão
                  ),
                  onPressed: () async {
                    final loginProvider =
                        Provider.of<LoginProvider>(context, listen: false);
                    await loginProvider.signIn(
                      _usernameController.text.trim(),
                      _passwordController.text.trim(),
                      context,
                    );
                  },
                  child: Text('Entrar', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 16),
                Divider(
                  color:
                      const Color.fromARGB(255, 184, 184, 184), // Cor da linha
                  thickness: 1, // Espessura da linha
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.black), // Cor de fundo preta
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            6.0), // Borda levemente arredondada
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(200, 50)), // Tamanho mínimo do botão
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child:
                      Text('Cadastro', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
