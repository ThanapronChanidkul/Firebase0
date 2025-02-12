import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _createAccount() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      print('กรุณากรอกอีเมลและรหัสผ่าน');
      return;
    }

    if (password != confirmPassword) {
      print('รหัสผ่านไม่ตรงกัน');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('สร้างบัญชีเสร็จสิ้น: ${userCredential.user?.uid}');
      
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'weak-password') {
        errorMessage = 'รหัสผ่านที่ให้มามีความปลอดภัยต่ำเกินไป';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'บัญชีผู้ใช้นี้มีอยู่แล้วสำหรับอีเมลนี้';
      } else {
        errorMessage = e.message ?? 'เกิดข้อผิดพลาด';
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ข้อผิดพลาด'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สร้างบัญชี'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'อีเมล',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'ยืนยันรหัสผ่าน',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createAccount,
              child: Text('สร้างบัญชี'),
            ),
          ],
        ),
      ),
    );
  }
}
