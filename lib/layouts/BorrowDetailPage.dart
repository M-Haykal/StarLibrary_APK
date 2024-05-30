import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BorrowDetailPage extends StatelessWidget {
  final Map<String, dynamic> borrowItem;

  BorrowDetailPage({required this.borrowItem});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    String formatDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return 'N/A';
      final dateTime = DateTime.parse(dateStr);
      return dateFormatter.format(dateTime);
    }

    Future<void> _cancelBorrowing(BuildContext context) async {
      final url =
          'http://perpus.amwp.website/api/auth/cancel/${borrowItem['id']}';
      final response = await http.put(Uri.parse(url));

      if (response.statusCode == 200) {
        Alert(
          context: context,
          type: AlertType.success,
          title: "Success",
          desc: "Peminjaman berhasil dibatalkan",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              width: 120,
            )
          ],
        ).show();
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Error",
          desc: "Gagal membatalkan peminjaman",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              width: 120,
            )
          ],
        ).show();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(borrowItem['judul'] ?? 'Borrow Detail'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (borrowItem['thumbnail'] != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      'http://perpus.amwp.website/storage/${borrowItem['thumbnail']}',
                      height: 250, // Set a smaller height
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                borrowItem['judul'] ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          'Pengarang', borrowItem['pengarang'] ?? ''),
                      _buildDetailRow('Penerbit', borrowItem['penerbit'] ?? ''),
                      _buildDetailRow(
                          'Deskripsi', borrowItem['deskripsi'] ?? 'N/A'),
                      _buildDetailRow('Status', borrowItem['status'] ?? ''),
                      _buildDetailRow(
                          'Created At', formatDate(borrowItem['created_at'])),
                      _buildDetailRow('Confirmed At',
                          formatDate(borrowItem['confirmed_at'])),
                      _buildDetailRow(
                          'Returned At', formatDate(borrowItem['returned_at'])),
                    ],
                  ),
                ),
              ),
              if (borrowItem['status'] == 'waiting')
                Center(
                  child: ElevatedButton(
                    onPressed: () => _cancelBorrowing(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('Batalkan Peminjaman'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
