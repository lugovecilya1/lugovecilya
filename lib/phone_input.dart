import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'otp_screen.dart';

class PhoneInputScreen extends StatefulWidget {
  static const routeName = '/phone';
  const PhoneInputScreen({Key? key}) : super(key: key);

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _sending = false;
  final String baseUrl = 'https://example.com';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    try {
      await http.post(Uri.parse('$baseUrl/send_otp'), body: {'phone': _controller.text});
      if (!mounted) return;
      Navigator.pushNamed(context, OTPScreen.routeName, arguments: _controller.text);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Введите номер')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Телефон'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите номер';
                  final digitsOnly = RegExp(r'^\d{10,15}$');
                  if (!digitsOnly.hasMatch(value)) return 'Неверный формат номера';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _sending ? null : _sendOtp,
                child: _sending ? const CircularProgressIndicator() : const Text('Отправить OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
