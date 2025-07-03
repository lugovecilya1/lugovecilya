import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';

class OTPScreen extends StatefulWidget {
  static const routeName = '/otp';
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _verifying = false;
  final String baseUrl = 'https://example.com';
  late String phone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    phone = ModalRoute.of(context)?.settings.arguments as String? ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _verifying = true);
    try {
      await http.post(Uri.parse('$baseUrl/verify_otp'), body: {
        'phone': phone,
        'code': _controller.text,
      });
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Код из SMS')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Код'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите код';
                  final digitsOnly = RegExp(r'^\d{4,6}$');
                  if (!digitsOnly.hasMatch(value)) return 'Неверный код';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _verifying ? null : _verifyOtp,
                child: _verifying ? const CircularProgressIndicator() : const Text('Подтвердить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
