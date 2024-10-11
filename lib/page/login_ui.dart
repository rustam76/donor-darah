import 'package:donor_darah/controller/auth_controller.dart';
import 'package:donor_darah/main.dart';
import 'package:donor_darah/page/help_ui.dart';
import 'package:donor_darah/page/register_login_ui.dart';
import 'package:flutter/material.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({Key? key}) : super(key: key);

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController loginController = LoginController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        String? user = await loginController.login(email.text, password.text);

        setState(() {
          isLoading = false;
        });
        if (user != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Login successful!')));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyApp()), // Replace MyApp() with your main page widget
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to login: Unknown error')));
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to login: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                "Welcome to SIDORAH",
                style: TextStyle(fontSize: 20
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: "Enter your Email",
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your Email';
                        }
                        if (!value.contains('@')) {
                          return 'Please Enter valid Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      
                      controller: password,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            fixedSize:
                                Size(MediaQuery.of(context).size.width, 60)),
                        onPressed: () {
                          _login();
                        },
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Text("Login"),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.red),
                            ),
                            fixedSize:
                                Size(MediaQuery.of(context).size.width, 60)),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HelpPage(),
                            ),
                          );
                        },
                        child: const Text("Help"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Belum punya Akun ?"),
                        TextButton(
                          style: TextButton.styleFrom(),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterLoginUI()));
                          },
                          child: Text("Register"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
