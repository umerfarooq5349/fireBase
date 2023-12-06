import 'package:firebase_app/ui/posts/post_screen.dart';
import 'package:firebase_app/utils/utils.dart';
import 'package:firebase_app/widgets/rouded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyCode extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final verificationId, forceResendingToken;
  const VerifyCode(
      {super.key,
      required this.verificationId,
      required this.forceResendingToken});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final verifyCodeController = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify',
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
                controller: verifyCodeController,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  hintText: 'Enter 6 digit code sent to your number',
                  helperText: '0 0 0 0 0 0',
                  labelText: 'Verification code',
                  hintStyle: TextStyle(color: Colors.deepPurple, fontSize: 16),
                  labelStyle: TextStyle(color: Colors.deepPurple, fontSize: 16),
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
                title: 'Verify',
                onTap: () async {
                  setState(() {
                    loading = true;
                  });

                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verifyCodeController.text.toString());
                  try {
                    setState(() {
                      loading = true;
                    });
                    _auth.signInWithCredential(credential);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostScreen(),
                        ));
                  } catch (e) {
                    Utils().toastMessage(e.toString(), Colors.red);
                    setState(() {
                      loading = true;
                    });
                  }
                },
                loading: loading)
          ],
        ),
      ),
    );
  }
}
