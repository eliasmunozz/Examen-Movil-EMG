import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Error'),
      body: const Center(
        child: Text('ErrorScreen'),
      ),
    );
  }
}
