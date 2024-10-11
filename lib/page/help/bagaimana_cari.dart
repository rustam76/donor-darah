import 'package:flutter/material.dart';

class BagaimanCari extends StatelessWidget {
  const BagaimanCari({super.key});

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
           Text("2. Jika sudah di halaman awal silahkan pilih donor darah"),
          SizedBox(height: 10),
          Image.asset("assets/help/sc_4.png", height: 300),
          SizedBox(height: 10),
          Text("3. Pilih donor darah yang ingin anda cari dan klik tombol relawan"),
          SizedBox(height: 10),
          Image.asset("assets/help/sc_5.png", height: 300),
          SizedBox(height: 10),
          Text("4. maka akan tampil relawan berdasarkan golongan darah yang anda pilih lalu klik relawan yang anda pilih"),
          SizedBox(height: 10),
          Image.asset("assets/help/sc_6.png", height: 300),
          SizedBox(height: 10,),
          Text('5. maka tampil detail relawan lalu klik kirim pesan'),
            SizedBox(height: 10,),
          Image.asset("assets/help/sc_7.png", height: 300),
          SizedBox(height: 10,),
          Text('5. silahkan lakukan komunikasi dengan relawan'),
            SizedBox(height: 10,),
          Image.asset("assets/help/sc_8.png", height: 300),
        ],
      ),
    );
  }
}
