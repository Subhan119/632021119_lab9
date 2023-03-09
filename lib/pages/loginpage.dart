import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lab9/pages/homepage.dart';
import 'package:lab9/pages/registerpage.dart';
import 'package:lab9/services/auth_service.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 320,
                      child: Column(
                        children: [
                          buildEmailInput(),
                           buildPasswordInput(),
                        ],
                      ),
                    ),
                    buildEmailSignin(),
                    buildEmailSignup(),
                  ],
                ), 
              ),
              const Divider(
                thickness: 2,
                color: Colors.grey,
              ),
            ],
          ),
          ),
      ),
    );
  }
  Widget buildEmailSignup(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Don't have an account?"),
          TextButton(onPressed: () {
            Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => const Registerpage(),
                ));
          }, 
          child: const Text("Register now !"),
          )
        ],
      ),
      );
  }
  Widget buildEmailSignin(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: EmailAuthButton(
        onPressed: () {
          AuthService()
          .signInWithEmail(_email.text, _password.text)
          .then((value) => Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => const Homepage(),
            )));
        },
      ),
      );
  }
  TextFormField buildEmailInput(){
    return TextFormField(
      controller: _email,
      decoration: const InputDecoration(
        labelText: "E-mail"
      ),
    );
  }
  TextFormField buildPasswordInput() {
    return TextFormField(
      controller: _password,
      obscureText: true,
      decoration:  const  InputDecoration(
        labelText: "Password",
      ),
    );
  }
}