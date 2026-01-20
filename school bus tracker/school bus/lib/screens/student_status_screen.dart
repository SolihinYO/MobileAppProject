import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentStatusScreen extends StatefulWidget {
  const StudentStatusScreen({super.key});

  @override
  State<StudentStatusScreen> createState() => _StudentStatusScreenState();
}

class _StudentStatusScreenState extends State<StudentStatusScreen> {
  int _selectedIndex = 0;
  final supabase = Supabase.instance.client;

  // Dynamically get the logged-in student's email
  String get studentEmail =>
      supabase.auth.currentUser?.email ?? "No Email Found";

  // --- LOGOUT FUNCTION ---
  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await supabase.auth.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/',
        ); // Redirect to login/landing page
      }
    }
  }

  // --- TAB 1: MY QR CODE ---
  Widget _buildQRPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Student Bus Pass (QR)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
              border: Border.all(color: Colors.blue.shade100, width: 2),
            ),
            child: QrImageView(
              data: studentEmail, // Data scanned by the Driver
              version: QrVersions.auto,
              size: 250.0,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'ID: $studentEmail',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Please show this QR code to the driver when boarding or de-boarding the bus.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }

  // --- TAB 2: LIVE TRIP STATUS ---
  Widget _buildStatusPage() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      // Listening for real-time updates from Supabase
      stream: supabase
          .from('students')
          .stream(primaryKey: ['id'])
          .eq('email', studentEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final data = snapshot.data?.firstOrNull;

        // Status Logic
        final String rawStatus = data?['status'] ?? 'WAITING';
        final String lastUpdate = data?['last_update'] ?? 'No record found';

        // UI Mapping
        String displayStatus = "Waiting for Bus...";
        Color statusColor = Colors.orange;
        IconData statusIcon = Icons.access_time_filled;

        if (rawStatus == 'ON BOARD') {
          displayStatus = "On Board (In Bus)";
          statusColor = Colors.green;
          statusIcon = Icons.directions_bus;
        } else if (rawStatus == 'ARRIVED') {
          displayStatus = "Arrived at Destination";
          statusColor = Colors.blue;
          statusIcon = Icons.location_on;
        }

        return Center(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(statusIcon, size: 80, color: statusColor),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'CURRENT STATUS:',
                    style: TextStyle(color: Colors.grey, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    displayStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const Divider(height: 50),
                  const Row(
                    children: [
                      Icon(Icons.history, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        'Last Update:',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      lastUpdate,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [_buildQRPage(), _buildStatusPage()];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'My Bus Pass' : 'Trip Status'),
        centerTitle: true,
        backgroundColor: _selectedIndex == 0
            ? Colors.blue.shade700
            : Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: _selectedIndex == 0
            ? Colors.blue.shade700
            : Colors.green.shade700,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_2), label: 'My QR'),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Status',
          ),
        ],
      ),
    );
  }
}
