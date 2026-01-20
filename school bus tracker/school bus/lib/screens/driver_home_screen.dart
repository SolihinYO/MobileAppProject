import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Tukar import ke Supabase
import 'qr_scanner_screen.dart';
import 'add_driver_screen.dart';
import 'add_bus_screen.dart';
import 'view_bookings_screen.dart';
// import 'attendance_list_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool isTripStarted = false;
  // Inisialisasi client Supabase
  final supabase = Supabase.instance.client;

  // FUNGSI TOGGLE TRIP MENGGUNAKAN SUPABASE
  void _toggleTrip() async {
    setState(() {
      isTripStarted = !isTripStarted;
    });

    try {
      // Menggunakan upsert: Jika ID 'bus_001' wujud, ia akan update. Jika tak wujud, ia akan create.
      await supabase.from('bus_locations').upsert({
        'id': 'bus_001',
        'is_live': isTripStarted,
        'latitude': 3.1390, // Koordinat contoh
        'longitude': 101.6869,
        'last_update': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isTripStarted
                  ? 'Trip started! Location is being shared.'
                  : 'Trip ended.',
            ),
            backgroundColor: isTripStarted ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error Supabase: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating trip: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // LOGOUT FUNCTION
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Tambah logik logout Supabase jika perlu
              await supabase.auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver & Admin Dashboard'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome,', style: TextStyle(color: Colors.white70)),
                      Text(
                        'Admin/Driver',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trip Management',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  _buildMainActionCard(
                    context,
                    title: isTripStarted ? 'Stop Trip' : 'Start Trip',
                    subtitle: isTripStarted
                        ? 'Bus is being tracked by Parents'
                        : 'Click to share live location',
                    icon: isTripStarted
                        ? Icons.stop_circle
                        : Icons.play_circle_fill,
                    color: isTripStarted ? Colors.red : Colors.green,
                    onTap: _toggleTrip,
                  ),

                  const SizedBox(height: 15),

                  _buildMainActionCard(
                    context,
                    title: 'Scan Student QR',
                    subtitle: 'Click to open camera and scan',
                    icon: Icons.qr_code_scanner,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QRScannerScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    'Management (Admin)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildAdminCard(
                        context,
                        'Add Driver',
                        Icons.person_add,
                        Colors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddDriverScreen(),
                          ),
                        ),
                      ),
                      _buildAdminCard(
                        context,
                        'Add Bus',
                        Icons.directions_bus,
                        Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddBusScreen(),
                          ),
                        ),
                      ),
                      _buildAdminCard(
                        context,
                        'Add Route',
                        Icons.map,
                        Colors.purple,
                        onTap: () => Navigator.pushNamed(context, '/add_route'),
                      ),
                      _buildAdminCard(
                        context,
                        'Attendance',
                        Icons.assignment,
                        Colors.red,
                        onTap: () =>
                            Navigator.pushNamed(context, '/attendance_list'),
                      ),
                      _buildAdminCard(
                        context,
                        'View Bookings',
                        Icons.list_alt_rounded,
                        Colors.teal,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ViewBookingsScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
