import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  bool loading = false;
  RoundedButton(
      {super.key,
      required this.title,
      required this.onTap,
      required this.loading});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.deepPurple[700],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: loading
                ? const CircularProgressIndicator(
                    strokeWidth: 5,
                    color: Colors.white,
                  )
                : Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  )),
      ),
    );
  }
}
