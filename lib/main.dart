import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class User {
  final String name;
  final String password;
  final int accountNumber;
  double balance;

  User({
    required this.name,
    required this.password,
    required this.accountNumber,
    required this.balance,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    _createAdminUser();
  }

  void _createAdminUser() {
    users.add(User(
      name: 'admin',
      password: 'admin',
      accountNumber: 99,
      balance: 1000000.0,
    ));
  }

  void _saveUser(String name, String password) {
    int accountNumber = Random().nextInt(90) + 10;
    users.add(User(
      name: name,
      password: password,
      accountNumber: accountNumber,
      balance: 100.0,
    ));
    setState(() {});
  }

  void _login(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final user = users.firstWhere(
                  (user) =>
                      user.name == nameController.text &&
                      user.password == passwordController.text,
                  orElse: () => User(
                    name: '',
                    password: '',
                    accountNumber: 0,
                    balance: 0.0,
                  ),
                );
                if (user.name.isNotEmpty) {
                  loggedInUser = user;
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login realizado com sucesso!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Nome ou senha incorretos!')),
                  );
                }
              },
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: users.isNotEmpty ? () => _login(context) : null,
              child: Text('Entrar'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserFormPage(onSaveUser: _saveUser)),
                );
                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Usuário cadastrado com sucesso!')),
                  );
                }
              },
              child: Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserFormPage extends StatefulWidget {
  final Function(String, String) onSaveUser;

  UserFormPage({required this.onSaveUser});

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dobController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _stateController = TextEditingController();
  final _cepController = TextEditingController();
  final _passwordController = TextEditingController();

  void _addUser() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSaveUser(_nameController.text, _passwordController.text);
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _cpfController.dispose();
    _dobController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _houseNumberController.dispose();
    _stateController.dispose();
    _cepController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o $fieldName';
    }
    return null;
  }

  String? _validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o CPF';
    }
    if (value.length != 11) {
      return 'O CPF deve ter 11 dígitos';
    }
    return null;
  }

  String? _validateCEP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o CEP';
    }
    if (value.length != 8) {
      return 'O CEP deve ter 8 dígitos';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a senha';
    }
    if (value.length != 8) {
      return 'A senha deve ter 8 dígitos';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) => _validateField(value, 'nome'),
                    ),
                    TextFormField(
                      controller: _surnameController,
                      decoration: InputDecoration(labelText: 'Sobrenome'),
                      validator: (value) => _validateField(value, 'sobrenome'),
                    ),
                    TextFormField(
                      controller: _cpfController,
                      decoration: InputDecoration(labelText: 'CPF'),
                      keyboardType: TextInputType.number,
                      validator: _validateCPF,
                    ),
                    TextFormField(
                      controller: _dobController,
                      decoration:
                          InputDecoration(labelText: 'Data de Nascimento'),
                      keyboardType: TextInputType.datetime,
                      validator: (value) =>
                          _validateField(value, 'data de nascimento'),
                    ),
                    TextFormField(
                      controller: _streetController,
                      decoration: InputDecoration(labelText: 'Nome da Rua'),
                      validator: (value) =>
                          _validateField(value, 'nome da rua'),
                    ),
                    TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(labelText: 'Cidade'),
                      validator: (value) => _validateField(value, 'cidade'),
                    ),
                    TextFormField(
                      controller: _houseNumberController,
                      decoration: InputDecoration(labelText: 'Número da Casa'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          _validateField(value, 'número da casa'),
                    ),
                    TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(labelText: 'Estado'),
                      validator: (value) => _validateField(value, 'estado'),
                    ),
                    TextFormField(
                      controller: _cepController,
                      decoration: InputDecoration(labelText: 'CEP'),
                      keyboardType: TextInputType.number,
                      validator: _validateCEP,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Senha'),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: _validatePassword,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addUser,
                child: Text('Cadastrar Usuário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
