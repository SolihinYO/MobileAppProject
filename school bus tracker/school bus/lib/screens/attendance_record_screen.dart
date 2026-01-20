import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'qr_scanner_screen.dart'; // Import scanner anda

class AttendanceRecordScreen extends StatelessWidget {
  final String studentId;

  const AttendanceRecordScreen({
    super.key,
    required this.studentId,
  });

  Future<Map<String, dynamic>?> _fetchLatestAttendance() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('attendance')
          .select()
          .eq('student_identifier', studentId)
          .order('recorded_at', ascending: false)
          .limit(1)
          .maybeSingle(); // Menggunakan maybeSingle untuk elakkan ralat jika kosong
      return response;
    } catch (e) {
      debugPrint("Error fetching: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Success'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Sorok butang back default di AppBar
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchLatestAttendance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 10),
                  const Text("Record not found or Database Error."),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                    ),
                    child: const Text("TRY AGAIN"),
                  )
                ],
              ),
            );
          }

          final data = snapshot.data!;
          DateTime recordedAt = DateTime.parse(data['recorded_at']).toLocal();

          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 100),
                const SizedBox(height: 20),
                const Text(
                  "STUDENT ON BOARD",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const Divider(height: 40, thickness: 1),
                _infoRow("Student Email", data['student_identifier']),
                _infoRow("Status", "PRESENT / ON BOARD"),
                _infoRow("Time", "${recordedAt.hour}:${recordedAt.minute.toString().padLeft(2, '0')}"),
                _infoRow("Date", "${recordedAt.day}/${recordedAt.month}/${recordedAt.year}"),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('SCAN NEXT STUDENT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text("Back to Dashboard", style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}