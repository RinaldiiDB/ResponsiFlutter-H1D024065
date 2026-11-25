import 'package:flutter/material.dart';

class LoadingStateView extends StatelessWidget {
  final String message;

  const LoadingStateView({
    super.key,
    this.message = 'Memuat data cuaca...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
          ),
          const SizedBox(height: 18),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
