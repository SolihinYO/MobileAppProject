import 'package:flutter/material.dart';
import 'driver_home_screen.dart';
import 'parent_home_screen.dart';
import 'student_status_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // LOGIN FUNCTION (Hardcoded for testing)
  void _login() {
    String email = _emailController.text.trim().toLowerCase();
    String password = _passwordController.text.trim();

    // 1. Check for Admin / Driver
    if (email == 'admin@gmail.com' && password == 'admin123') {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const DriverHomeScreen())
      );
    } 
    // 2. Check for Parent
    else if (email == 'parent@gmail.com' && password == 'parent123') {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const ParentHomeScreen())
      );
    }
    // 3. Check for Student
    else if (email == 'student@gmail.com' && password == 'student123') {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const StudentStatusScreen())
      );
    }
    // 4. Handle Incorrect Credentials
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect Email or Password!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Icon(Icons.bus_alert, size: 100, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                "School Bus Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  onPressed: _login,
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Use admin@gmail.com / admin123 for testing", 
                style: TextStyle(color: Colors.grey, fontSize: 12)
              ),
            ],
          ),
        ),
      ),
    );
  }
}