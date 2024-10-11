import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_darah/widget/display_image_creen.dart';
import 'package:flutter/material.dart';
import 'package:donor_darah/controller/relawan_controller.dart';


class DetailUsers extends StatefulWidget {
  final String userEmail;
  const DetailUsers({super.key, required this.userEmail});

  @override
  State<DetailUsers> createState() => _DetailUsersState();
}

class _DetailUsersState extends State<DetailUsers> {
  RelawanController relawanController = RelawanController();
  DocumentSnapshot? userSnapshot;

  @override
  void initState() {
    super.initState();
    _listenToUserUpdates();
  }

  void _listenToUserUpdates() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userEmail)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        userSnapshot = snapshot;
      });
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin verifikasi relawan ini?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              child: const Text("Ya"),
              onPressed: () async {
                var st = !userSnapshot!['status'];
                
                bool success = await relawanController.updateUserStatus(
                    widget.userEmail, st);

                if (success) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Berhasil')));
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal Verifikasi')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userSnapshot == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Badge(
                      label: Text(
                          '${userSnapshot!['status'] ? 'Verifikasi' : 'Belum verifikasi'}',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: userSnapshot!['status']
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 50.0,
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userSnapshot!['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text('Relawan Donor Darah'),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FixedColumnWidth(20),
                  2: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    children: [
                      Text('Gol darah',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(':'),
                      Text(userSnapshot!['bloodType'] ?? 'N/A'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Umur',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(':'),
                      Text('${userSnapshot!['umur'] ?? 'N/A'} Th'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Jenis Kelamin',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(':'),
                      Text(userSnapshot!['jenis_kelamin'] ?? 'N/A'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DisplayImageScreen(
                    imagePath: userSnapshot!['ktp_file'],
                  ),
                  DisplayImageScreen(
                    imagePath: userSnapshot!['blood_card_file'],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: userSnapshot!['status']
                              ? Colors.red
                              : Colors.grey[400],
                          foregroundColor: Colors.white),
                      onPressed: _showLogoutDialog,
                      child: Text(
                          '${userSnapshot!['status'] ? 'Batalkan Verifikasi' : 'Belum verifikasi'}',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
