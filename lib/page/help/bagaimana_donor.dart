import 'package:flutter/material.dart';

class BagaimanDonor extends StatelessWidget {
  const BagaimanDonor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("1 Login dengan akun anda"),
          SizedBox(height: 10),
          Image.asset("assets/help/sc_3.png", height: 300),
          SizedBox(height: 10),
           Text("2. Jika sudah di halaman awal silahkan pilih Relawan Pendonor"),
          SizedBox(height: 10),
          Image.asset("assets/help/sc_4.png", height: 300),
          SizedBox(height: 10),
          Text("3. isi dan lengkapi form registrasi dengan benar lalu tekan register"),
          Image.asset("assets/help/sc_9.jpg", height: 300),
          SizedBox(height: 10),
          Text("4. maka akan tampil profil relawan "),
          SizedBox(height: 10),
          Image.asset("assets/help/sc_12.jpg", height: 300),
          SizedBox(height: 10),
          Text("5. selanjunya jika kamu sudah terverifikasi maka kamu nanti akan di kontak oleh orang yang butuh darah"),
          Image.asset("assets/help/sc_11.jpg", height: 300),
        ],
      ),
    );
  }
}
