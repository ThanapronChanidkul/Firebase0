import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/create_account_screen.dart';
import 'package:flutter_firebase_auth/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'กรุณากรอกอีเมลและรหัสผ่าน';
      });
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: _emailController.text,
    password: _passwordController.text,
);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'เกิดข้อผิดพลาด';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบ'),
        backgroundColor: Color(0xFF3C80C1), // ปรับสีของ AppBar
        elevation: 0,
      ),
      body: SingleChildScrollView(  // ทำให้หน้าจอสามารถเลื่อนเมื่อคีย์บอร์ดขึ้น
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // เพิ่ม logo หรือข้อความต้อนรับ
              Center(
                child: Text(
                  'ยินดีต้อนรับกลับ!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C80C1),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // อีเมล
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'อีเมล',
                  labelStyle: TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3C80C1), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // รหัสผ่าน
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  labelStyle: TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3C80C1), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // ปุ่มเข้าสู่ระบบ
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3C80C1), // ปรับสีของปุ่ม
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ข้อความแสดงข้อผิดพลาด
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // ลิงก์สำหรับลืมรหัสผ่านและสร้างบัญชี
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ForgotPasswordScreen();
                      }));
                    },
                    child: Text(
                      'ลืมรหัสผ่าน?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 19, 66, 104),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text(' หรือ '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CreateAccountScreen();
                      }));
                    },
                    child: Text(
                      'สร้างบัญชี',
                      style: TextStyle(
                        color: Color.fromARGB(255, 19, 66, 104),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
