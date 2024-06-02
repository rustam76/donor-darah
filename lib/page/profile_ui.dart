import 'package:flutter/material.dart';

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key});

  @override
  State<ProfileUi> createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
          // alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: Image.network(
                            "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg")
                        .image,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "ANDRA\nRelawan Donor Danar",
                    textAlign: TextAlign.center,
                  ),
                  const Text('Terahir Donor 19 Mei 2024'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Text('Nama'),
                Text(':'),
                  ],
                ),
              
                Text('Rustam'),
              ],
            ),

            Row(
              
              children: [
                Text('Umur'),
                Text(':'),
                Text('20 Tahun'),
              ],
            ),

            Row(
              children: [
                Text('Jenis Kelamin'),
                Text(':'),
                Text('Laki Laki'),
              ],
            ),


          ])),
    );
  }
}
