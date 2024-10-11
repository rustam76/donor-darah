import 'package:donor_darah/page/list_user_ui.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectBlood extends StatefulWidget {
  const SelectBlood({Key? key}) : super(key: key);

  @override
  State<SelectBlood> createState() => _SelectBloodState();
}

class _SelectBloodState extends State<SelectBlood> {
  String bloodType = "";

  void _selectBlood(String blood) {
    setState(() {
      bloodType = blood;
    });
  }

  void _nextPage() {
    if (bloodType == "") {
      const snackBar = SnackBar(content: Text('Pilih golongan darah terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Navigator.push to the next page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserList(bloodType :bloodType),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih golongan darah"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(97, 195, 188, 188),
                ),
                constraints: const BoxConstraints(
                  maxHeight: 200,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "Silahkan pilih golongan darah sesuai dengan kebuatan anda",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(MediaQuery.of(context).size.width, 50),
                ),
                onPressed: _nextPage,
                child: const Text("Relawan"),
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('blood_types').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No blood types available');
                  } else {
                    final bloodTypes = snapshot.data!.docs;
                    return Wrap(
                      spacing: 10, // Jarak antara tombol
                      alignment: WrapAlignment.spaceEvenly,
                      children: [
                        for (var bloodType in bloodTypes)
                          OutlinedButton(
                            onPressed: () {
                              final typeName = bloodType['name'];
                              var snackBar = SnackBar(content: Text('Berhasil Memilih dengan golongan $typeName'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              _selectBlood(typeName);
                            },
                            child: Text(bloodType['name']),
                          ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              Text(
                "Pastikan Jawaban anda benar. dan Tekan tombol golongan untuk melanjutkan",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
