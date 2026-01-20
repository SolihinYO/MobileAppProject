import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';
import 'attendance_record_screen.dart'; 

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isScanCompleted = false;
  final supabase = Supabase.instance.client;

  // Function to record attendance and update student status
  Future<void> _recordAttendance(String studentIdOrEmail) async {
    try {
      // 1. Insert record into 'attendance' table
      await supabase.from('attendance').insert({
        'student_identifier': studentIdOrEmail,
        'status': 'Present',
        'recorded_at': DateTime.now().toIso8601String(),
      });

      // 2. Update student status in 'students' table
      // Note: Make sure 'status' and 'last_update' columns exist in your Supabase table
      await supabase.from('students').update({
        'status': 'ON BOARD',
        'last_update': DateTime.now().toIso8601String(),
      }).eq('email', studentIdOrEmail); // Assuming the QR contains the student's email

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attendance recorded for $studentIdOrEmail!'), 
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to the record screen and replace the scanner so user can't go back and re-scan
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AttendanceRecordScreen(
              studentId: studentIdOrEmail, 
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error saving data: $e");
      if (mounted) {
        // Show specific error message to help troubleshooting
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Database Error: $e'), 
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      // Re-enable scanning if an error occurs
      setState(() => isScanCompleted = false); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Student QR'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background: The Camera Scanner
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
              facing: CameraFacing.back,
            ),
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && !isScanCompleted) {
                setState(() {
                  isScanCompleted = true; // Stop multiple scans at once
                });
                
                final String code = barcodes.first.rawValue ?? "Unknown";
                _recordAttendance(code);
              }
            },
          ),
          
          // QR Scanner Overlay (Visual frame for user)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                   // Optional: Add a simple scanning line animation here if desired
                ],
              ),
            ),
          ),
          
          // Instructions at the bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Align Student QR within the frame',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),

          // Loading indicator overlay when processing scan
          if (isScanCompleted)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}