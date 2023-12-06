import 'package:firebase_app/ui/auth/verify_login.dart';
import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_app/widgets/rouded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController = TextEditingController();
  bool loading = false;
  String countryCode = '+92';
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: phoneNumberController,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  hintText: '301 234567',
                  helperText: '301 234567',
                  labelText: 'Phone Number',
                  prefixIcon: TextButton(
                    onPressed: () {
                      showCountryPicker(
                          countryListTheme: const CountryListThemeData(
                            inputDecoration: InputDecoration(
                              hintText: 'Pakistan',
                              labelText: 'Search',
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: Colors.deepPurple,
                              hintStyle: TextStyle(
                                  color: Colors.deepPurple, fontSize: 16),
                              labelStyle: TextStyle(
                                  color: Colors.deepPurple, fontSize: 16),
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
                          ),
                          context: context,
                          showPhoneCode: true,
                          onSelect: (Country value) {
                            setState(() {
                              countryCode = '+${value.phoneCode.toString()}';
                            });
                          });
                    },
                    child: Text(
                      countryCode,
                      style: const TextStyle(
                          color: Colors.deepPurple, fontSize: 16),
                    ),
                  ),
                  hintStyle:
                      const TextStyle(color: Colors.deepPurple, fontSize: 16),
                  labelStyle:
                      const TextStyle(color: Colors.deepPurple, fontSize: 16),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.deepPurple,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
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
                    return 'Phone number is required';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedButton(
                title: 'Send code',
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  _auth
                      .verifyPhoneNumber(
                    phoneNumber: countryCode + phoneNumberController.text,
                    verificationCompleted: (_) {},
                    verificationFailed: (error) {
                      Utils().toastMessage('Verification failed', Colors.red);
                      setState(() {
                        loading = false;
                      });
                    },
                    codeSent: (verificationId, forceResendingToken) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyCode(
                                verificationId: verificationId,
                                forceResendingToken: forceResendingToken),
                          ));
                      setState(() {
                        loading = false;
                      });
                    },
                    codeAutoRetrievalTimeout: (e) {
                      Utils().toastMessage('Timeout error', Colors.red);
                      setState(() {
                        loading = false;
                      });
                    },
                  )
                      .onError(
                    (error, stackTrace) {
                      Utils().toastMessage(error.toString(), Colors.red);
                      setState(() {
                        loading = false;
                      });
                    },
                  );
                },
                loading: loading)
          ],
        ),
      ),
    );
  }
}
