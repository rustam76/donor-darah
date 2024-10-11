import 'package:flutter/material.dart';

class BagaimanLogin extends StatelessWidget {
  const BagaimanLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("1 Registrasi terlebih dahulu jika belum terdaftar"),
          SizedBox(height: 10),
          Image.asset("assets/help/sc_1.png", height: 300),
          SizedBox(height: 10),
          Text("2 isi form registrasi dengan benar"),
          SizedBox(height: 10),
          Image.asset("assets/help/sc_2.png", height: 300),
          SizedBox(height: 10),
          Text("3 Login dengan akun anda"),
          SizedBox(height: 10),
          Image.asset("assets/help/sc_3.png", height: 300),
        ],
      ),
    );
  }
}
