import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Loading extends HookWidget {
  final String? message;
  final Size size;
  final double thickness;

  const Loading({
    Key? key,
    this.message,
    this.size = const Size(80, 80),
    this.thickness = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: CircularProgressIndicator(strokeWidth: thickness),
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 33),
              child: Text(
                message!,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
