import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 

// Screen imports (Ensure these paths match your folder structure)
import 'screens/driver_home_screen.dart';
import 'screens/student_status_screen.dart';
import 'screens/parent_home_screen.dart';
import 'screens/add_route_bus.dart'; 
import 'screens/attendance_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://uomxftuzqfaceswkxyqe.supabase.co',
    anonKey: 'sb_publishable_495BvwknKkmCgvjHcCySAw_hkEYHl5O',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Bus System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/driver': (context) => const DriverHomeScreen(),
        '/student': (context) => const StudentStatusScreen(),
        '/parent': (context) => const ParentHomeScreen(),
        '/add_route': (context) => const AddRouteBusScreen(),
        '/attendance_list': (context) => const AttendanceListScreen(),
        '/register_parent': (context) => const ParentRegisterScreen(),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _checkLogin(String targetRoute) async {
    String email = _emailController.text.trim().toLowerCase();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields"))
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      // --- ADMIN DUMMY LOGIN LOGIC ---
      if (email == "admin@gmail.com" && password == "admin123") {
        if (targetRoute == '/driver') {
          if (mounted) Navigator.pushReplacementNamed(context, '/driver');
          return; // End here, do not call Supabase Auth
        }
      }
      // -------------------------------------

      // ACTUAL LOGIN PROCESS FOR PARENT & STUDENT
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email, 
        password: password
      );
      
      final String userId = res.user!.id;
      bool isAuthorized = false;

      // Role-Based Access Control (RBAC)
      if (targetRoute == '/parent') {
        final data = await supabase.from('parents').select().eq('id', userId).maybeSingle();
        if (data != null) isAuthorized = true;
      } 
      else if (targetRoute == '/student') {
        final data = await supabase.from('students').select().eq('id', userId).maybeSingle();
        if (data != null) isAuthorized = true;
      }
      else if (targetRoute == '/driver') {
        // For drivers other than admin dummy
        final data = await supabase.from('drivers').select().eq('id', userId).maybeSingle();
        if (data != null) isAuthorized = true;
      }

      if (isAuthorized) {
        if (mounted) Navigator.pushReplacementNamed(context, targetRoute);
      } else {
        await supabase.auth.signOut(); 
        throw "Access Denied: Your role is not authorized for this portal.";
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Error: $e"), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.directions_bus_filled_rounded, size: 80, color: Colors.blue),
                  const Text('SchoolNow', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 25),
                  TextField(
                    controller: _emailController, 
                    decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email))
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passwordController, 
                    obscureText: true, 
                    decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock))
                  ),
                  const SizedBox(height: 25),
                  
                  if (_isLoading) 
                    const CircularProgressIndicator()
                  else ...[
                    _buildLoginBtn('LOGIN AS DRIVER/ADMIN', Colors.blue.shade800, '/driver'),
                    const SizedBox(height: 10),
                    _buildLoginBtn('LOGIN AS STUDENT', Colors.green.shade700, '/student'),
                    const SizedBox(height: 10),
                    _buildLoginBtn('LOGIN AS PARENT', Colors.orange.shade800, '/parent'),
                    const Divider(height: 40),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register_parent'),
                      child: const Text("New Parent? Register here", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBtn(String label, Color color, String route) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, 
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => _checkLogin(route),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// --- PARENT REGISTRATION SCREEN ---
class ParentRegisterScreen extends StatefulWidget {
  const ParentRegisterScreen({super.key});

  @override
  State<ParentRegisterScreen> createState() => _ParentRegisterScreenState();
}

class _ParentRegisterScreenState extends State<ParentRegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _register() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty || _nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please complete all information")));
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      if (res.user != null) {
        await Supabase.instance.client.from('parents').insert({
          'id': res.user!.id,
          'full_name': _nameCtrl.text.trim(),
          'email': _emailCtrl.text.trim(),
          'address': _addrCtrl.text.trim(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Successful!"), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Parent"), backgroundColor: Colors.orange, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _addrCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Address", border: OutlineInputBorder())),
            const SizedBox(height: 30),
            _loading ? const CircularProgressIndicator() : ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.orange, foregroundColor: Colors.white),
              onPressed: _register, 
              child: const Text("REGISTER NOW")
            ),
          ],
        ),
      ),
    );
  }
}