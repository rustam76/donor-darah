// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_darah/controller/golongan_darah.dart';
import 'package:donor_darah/page/list_user_ui.dart';
// import 'package:donor_darah/widget/loading.dart';
import 'package:flutter/material.dart';

class SelectBlood extends StatefulWidget {
  const SelectBlood({super.key});

  @override
  State<SelectBlood> createState() => _SelectBloodState();
}

class _SelectBloodState extends State<SelectBlood> {
  String bloodType = "";
  final GolonganDarahController _golonganDarahController =
      GolonganDarahController();

  @override
  void initState() {
    print(_golonganDarahController.getGolonganDarah());
    super.initState();
  }

  void _selectBlood(String blood) {
    setState(() {
      bloodType = blood;
    });
  }

  void _nextPage() {
    if (bloodType == "") {
      const snackBar =
          SnackBar(content: Text('Pilih golongan darah terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ListUser(bloodType: bloodType),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih golongan darah"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(children: [
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
            const SizedBox(
              height: 20,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: Size(MediaQuery.of(context).size.width, 50)),
                onPressed: () {
                  _nextPage();
                },
                child: const Text("Relawan")),
            const SizedBox(
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              // FutureBuilder<QuerySnapshot<Object?>>(
              //     future: _golonganDarahController.getGolonganDarah(),
              //     builder: (builder, snapshot) {
              //       final gollData = snapshot.data!.docs;
              //       print(gollData);
              //       if (snapshot.connectionState == ConnectionState.done) {
              //         return ListView.builder(
              //             scrollDirection: Axis.horizontal,
              //             itemCount: gollData.length,
              //             itemBuilder: (context, index) {
              //               return Expanded(
              //                 child: OutlinedButton(
              //                   onPressed: () {
              //                     const snackBar = SnackBar(
              //                       content: Text(
              //                           'Berhasil Memilih dengan golongan A'),
              //                     );
              //                     ScaffoldMessenger.of(context)
              //                         .showSnackBar(snackBar);
              //                     _selectBlood("A");
              //                   },
              //                   child: Text('${(gollData[index].data() as Map<String, dynamic>)['nama'] }'),
              //                 ),
              //               );
              //             });
              //       }
              //       return LoadingView();
              //     }),

              // ListView.builder(itemBuilder: (itemBuilder, index){

              // }, itemCount: _golonganDarahController.golonganDarah.length),

              OutlinedButton(
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text('Berhasil Memilih dengan golongan A'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  _selectBlood("A");
                },
                child: const Text("A"),
              ),
              OutlinedButton(
                  onPressed: () {
                    const snackBar = SnackBar(
                      content: Text('Berhasil Memilih dengan golongan B'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    _selectBlood("B");
                  },
                  child: const Text("B")),
              OutlinedButton(
                  onPressed: () {
                    const snackBar = SnackBar(
                      content: Text('Berhasil Memilih dengan golongan O'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    _selectBlood("O");
                  },
                  child: const Text("O")),
              OutlinedButton(
                  onPressed: () {
                    const snackBar = SnackBar(
                      content: Text('Berhasil Memilih dengan golongan AB'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    _selectBlood("AB");
                  },
                  child: const Text("AB")),
            ]),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Pastikan Jawaban anda benar. dan Tekan tombol golongan untuk melanjutkan",
              textAlign: TextAlign.center,
            )
          ]),
        ),
      ),
    );
  }
}
