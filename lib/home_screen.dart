import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าหลัก'),
        backgroundColor: Color(0xFF3C80C1), // ปรับสี AppBar ให้ดูสดใส
        elevation: 0,
      ),
      body: SingleChildScrollView(  // ทำให้หน้าจอสามารถเลื่อนเมื่อคีย์บอร์ดขึ้น
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // แสดงข้อความยินดีต้อนรับ
              Center(
                child: Text(
                  'ยินดีต้อนรับ!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C80C1),  // ใช้สีเดียวกับ AppBar
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // แสดงอีเมลของผู้ใช้งาน
              Text(
                userEmail == null ? 'กำลังโหลด...' : 'อีเมลของคุณ: $userEmail',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),

              // ปุ่มออกจากระบบ
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3C80C1), // ปรับสีปุ่ม
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'ออกจากระบบ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
