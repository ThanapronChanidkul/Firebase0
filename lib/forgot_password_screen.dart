import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _message;

  Future<void> _sendPasswordResetEmail() async {
    final email = _emailController.text;
    
    if (email.isEmpty) {
      setState(() {
        _message = 'กรุณากรอกอีเมลของคุณ';
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _message = 'อีเมลสำหรับรีเซ็ตรหัสผ่านถูกส่งไปแล้ว! กรุณาตรวจสอบกล่องข้อความของคุณ';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = e.message ?? 'เกิดข้อผิดพลาด';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลืมรหัสผ่าน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'อีเมล',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              child: const Text('ส่งอีเมลสำหรับรีเซ็ตรหัสผ่าน'),
            ),
            const SizedBox(height: 20),
            if (_message != null)
              Text(
                _message!,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
