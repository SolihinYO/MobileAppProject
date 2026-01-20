import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewBookingsScreen extends StatelessWidget {
  const ViewBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Student Bookings'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // Menggunakan Stream supaya data update secara live jika ada booking baru
        stream: supabase
            .from('bookings')
            .stream(primaryKey: ['id'])
            .order('created_at'),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final bookings = snapshot.data!;

          if (bookings.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final data = bookings[index];
              
              // Kerana rujukan (Join) dalam Stream sedikit berbeza, 
              // kita gunakan FutureBuilder kecil untuk ambil nama murid & rute berdasarkan ID
              return FutureBuilder(
                future: Future.wait([
                  supabase.from('students').select('student_name').eq('id', data['student_id']).single(),
                  supabase.from('bus_routes').select('route_name').eq('id', data['route_id']).single(),
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> info) {
                  String studentName = info.hasData ? info.data![0]['student_name'] : "Loading...";
                  String routeName = info.hasData ? info.data![1]['route_name'] : "Loading...";

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getStatusColor(data['status']),
                        child: const Icon(Icons.directions_bus, color: Colors.white),
                      ),
                      title: Text(studentName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Route: $routeName"),
                          Text("Duration: ${data['duration_days']} Days"),
                          Text("Fare: RM ${data['total_fare']}"),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(data['status'].toUpperCase(), 
                            style: TextStyle(color: _getStatusColor(data['status']), fontWeight: FontWeight.bold, fontSize: 10)),
                          const Icon(Icons.arrow_forward_ios, size: 14),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid': return Colors.green;
      case 'pending': return Colors.orange;
      default: return Colors.grey;
    }
  }
}