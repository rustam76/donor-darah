import 'package:donor_darah/controller/login_controller.dart';
import 'package:donor_darah/controller/relawan_controller.dart';
import 'package:donor_darah/page/profile_ui.dart';
import 'package:donor_darah/page/registrasi_ui.dart';
import 'package:flutter/material.dart';
import 'select_blood_ui.dart';

class HomeUi extends StatefulWidget {
  final Map<String, dynamic> userCredentials;
  const HomeUi({super.key, required this.userCredentials});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  bool isLogin = true;
  final LoginController auth = LoginController();
  RelawanController relawanController = RelawanController();
  void _checkStatusRelawan() {
    print("_checkStatusRelawan");

      if (widget.userCredentials['isDonor'] == true) {
           Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ProfileUi()),
      );
      }else{
        Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RegistrasiUi()),
      );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat datang\n${widget.userCredentials['name']}', style: TextStyle(fontSize: 14),),
        actions: [
          IconButton(
            onPressed: () {
              auth.logout();
            },
            icon: Icon(isLogin ? Icons.login : Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          // padding: const EdgeInsets.all(32),
          child: Column(
            children: [
            Image.network(
              "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcfoclubindonesia.co.id%2Fwp-content%2Fuploads%2F2020%2F04%2FBlood-Donation.png&f=1&nofb=1&ipt=e1a7fd7b7b108706772c1dc8e7dbb378adc89be3e531af97ca56a0997bd605b1&ipo=images",
            ),
            const SizedBox(height: 30),
            TextButton(
                style: TextButton.styleFrom(
                    maximumSize: Size(300, 50),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: Size(MediaQuery.of(context).size.width, 50)),
                onPressed: () {
                  _checkStatusRelawan();
                },
                child: const Text("Relawan Pendonor")),
            const SizedBox(height: 10),
            TextButton(
                style: TextButton.styleFrom(
                    maximumSize: Size(300, 50),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: Size(MediaQuery.of(context).size.width, 50)),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SelectBlood())),
                child: const Text("Butuh Darah"))
          ]),
        ),
      ),
    );
  }
}
