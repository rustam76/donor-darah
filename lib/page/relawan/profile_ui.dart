import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_darah/controller/relawan_controller.dart';
import 'package:donor_darah/page/relawan/edit_profil.dart';
import 'package:donor_darah/widget/display_image_creen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key});

  @override
  State<ProfileUi> createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RelawanController updateUserDonor = RelawanController();

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  void _showLogoutDialog(String userEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin donor darah lagi?"),
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
              child: const Text("Donor Lagi"),
              onPressed: () async {
                bool success = await updateUserDonor.updateUserDonor(userEmail);
                if (success) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Berhasil update status donor darah')));
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal donor darah')));
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
    if (_user == null) {
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(_user!.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User data not found'));
          }

          Map<String, dynamic>? _userData = snapshot.data!.data() as Map<String, dynamic>?;

          return SingleChildScrollView(
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
                              '${_userData!['status'] ? 'Verifikasi' : 'Belum verifikasi'}',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: _userData['status']
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
                          _userData['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text('Relawan Donor Darah'),
                        const SizedBox(height: 5),
                        Text(
                          'Terakhir Donor: ${_userData['lastDonor'] != null ? DateFormat.yMMMMEEEEd().format(DateTime.parse(_userData['lastDonor'])) : 'No date available' }',
                        ),
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
                          Text(_userData['bloodType'] ?? 'N/A'),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text('Umur',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(':'),
                          Text('${_userData['umur'] ?? 'N/A'} Th'),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text('Jenis Kelamin',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(':'),
                          Text(_userData['jenis_kelamin'] ?? 'N/A'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DisplayImageScreen(imagePath: _userData['ktp_file']),
                      DisplayImageScreen(
                          imagePath: _userData['blood_card_file'])
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _userData['status']
                                  ? Colors.red
                                  : Colors.black45,
                              foregroundColor: Colors.white),
                          onPressed: () {
                            if (_userData['status']) {
                              _showLogoutDialog(_userData['email']);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Belum bisa donor data belum diverifikasi!')));
                            }
                          },
                          child: const Text('Donor Darah',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfil(editProfil: _userData),
                              ),
                            );

                            if (result == true) {
                              // No need to manually refresh user data, as StreamBuilder will automatically rebuild on data change
                            }
                          },
                          child: const Text('Ubah Profil'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
