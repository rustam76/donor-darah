import 'package:donor_darah/controller/login_controller.dart';
import 'package:donor_darah/page/login_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterLoginUI extends StatefulWidget {
  const RegisterLoginUI({super.key});

  @override
  State<RegisterLoginUI> createState() => _RegisterLoginUIState();
}

class _RegisterLoginUIState extends State<RegisterLoginUI> {
  LoginController registerController = LoginController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        User? user = await registerController.register(
            name.text, email.text, password.text, "relawan");
        setState(() {
          isLoading = false;
        });

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User registered successfully!')));
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        alignment: Alignment.center,
        // margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Text(
                  "DAFTAR\nAplikasi SIDAKK",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Name"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter your Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Email"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter your Email';
                    }
                    if (!value.contains('@')) {
                      return 'Please Enter a valid Email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: password,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Password"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter your Password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: Size(MediaQuery.of(context).size.width, 60)),
                    onPressed: () {
                      _register();
                    },
                    child: const Text("Registrasi")),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah punya Akun ?"),
                    TextButton(
                      style: TextButton.styleFrom(),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginUi()));
                      },
                      child: Text("Login"),
                    )
                  ],
                )
              ]),
        ),
      )),
    );
  }
}
