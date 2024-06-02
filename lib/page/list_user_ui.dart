import 'package:flutter/material.dart';

class ListUser extends StatelessWidget {
  final String bloodType;
  const ListUser({super.key, required this.bloodType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List User ${bloodType}"),
      ),
      body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
              // crossAxisAlignment: Cross,
              children: [
                Row(children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                        "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg"),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(width: 20),
                  Text(
                    "ANDRA",
                    style: TextStyle(fontSize: 20),
                  )
                ]),
                SizedBox(height: 10),
                Row(children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                        "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg"),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(width: 20),
                  Text(
                    "ABDUL",
                    style: TextStyle(fontSize: 20),
                  )
                ]),
                SizedBox(height: 10),
                Row(children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                        "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg"),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(width: 20),
                  Text(
                    "ECA",
                    style: TextStyle(fontSize: 20),
                  )
                ]),
                SizedBox(height: 10),
                Row(children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                        "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg"),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(width: 20),
                  Text(
                    "ECI",
                    style: TextStyle(fontSize: 20),
                  )
                ]),
              ])),
    );
  }
}
