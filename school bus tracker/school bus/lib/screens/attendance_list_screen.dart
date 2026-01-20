import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceListScreen extends StatelessWidget {
  const AttendanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Student Attendance'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // Fetching attendance data in real-time using Supabase stream
        stream: supabase.from('attendance').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No attendance records for today.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final attendanceRecords = snapshot.data!;

          return ListView.builder(
            itemCount: attendanceRecords.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final data = attendanceRecords[index];
              
              // Basic logic: If record exists, status is 'Present'
              String studentName = data['student_name'] ?? data['student_email'] ?? 'Unknown';
              String status = "Present"; 

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                elevation: 2,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    studentName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: data['created_at'] != null 
                    ? Text("Time: ${data['created_at'].toString().substring(11, 16)}") 
                    : null,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.green, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}