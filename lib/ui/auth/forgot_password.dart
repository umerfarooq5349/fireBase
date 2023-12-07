// import 'package:firebase_app/ui/auth/signup_screen.dart';
// import 'package:firebase_app/ui/posts/post_screen.dart';
import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_app/widgets/rouded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController emailController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void login() {
    if (isEmail(emailController.text.toString())) {
      setState(() {
        loading = true;
      });
      _auth
          .sendPasswordResetEmail(
        email: emailController.text.toString(),
      )
          .then(
        (value) {
          Utils().toastMessage(
              "Reset link sent to ${emailController.text.toString()}",
              Colors.green);
          setState(() {
            loading = false;
          });
        },
      ).catchError(
        (error, stackTrace) {
          setState(() {
            loading = false;
          });
          Utils().toastMessage(error.toString(), Colors.red);
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password ",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 90,
                ),
                const SizedBox(
                  height: 90,
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          helperText: 'example@gmail.com',
                          labelText: 'Email',
                          suffixIcon: Icon(Icons.email),
                          suffixIconColor: Colors.deepPurple,
                          hintStyle:
                              TextStyle(color: Colors.deepPurple, fontSize: 16),
                          labelStyle:
                              TextStyle(color: Colors.deepPurple, fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.deepPurple,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.deepPurple,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required!';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                RoundedButton(
                  title: 'Forgot Password',
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      login();
                    }
                  },
                  loading: loading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
