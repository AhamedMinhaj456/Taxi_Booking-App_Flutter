import 'package:flutter/material.dart';

class Dialpad extends StatelessWidget {
  final Function(String) onKeyPressed;

  const Dialpad({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Pass the pressed key to the callback function
            onKeyPressed((index + 1).toString());
          },
          child: Center(
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        );
      },
    );
  }
}
