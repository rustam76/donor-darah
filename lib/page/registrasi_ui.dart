import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegistrasiUi extends StatefulWidget {
  RegistrasiUi({super.key});

  @override
  State<RegistrasiUi> createState() => _RegistrasiUiState();
}

class _RegistrasiUiState extends State<RegistrasiUi> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _file;
  String? _selectedGender;
  String? _selectedBlood;
  final name = TextEditingController();
  final blood = TextEditingController();
  final umur = TextEditingController();
  final jenis = TextEditingController();
  final fileKTP = TextEditingController();
  final fileDarah = TextEditingController();

  final picker = ImagePicker();

  Future<void> chooseFile() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
        print('File selected.');
      } else {
        print('No file selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registrasi relawan donor danarah",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Nama Lengkap"),
                    ),
                    controller: name,
                  ),
                  SizedBox(height: 10),

                  // TextFormField(
                  //   decoration: const InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     label: Text("Golongan Darah"),
                  //   ),
                  // ),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Golongan Darah",
                    ),
                    value: _selectedBlood,
                    items: <String>['A', 'B', 'AB', 'O'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedBlood = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Pilih golongan darah' : null,
                  ),

                  SizedBox(height: 10),
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Umur",
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Jenis Kelamin",
                          ),
                          value: _selectedGender,
                          items: <String>['Laki-Laki', 'Perempuan']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Pilih jenis kelamin' : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
// _file == null
                  //     ? Text('No file selected.')
                  //     : Image.file(_file!),
                  OutlinedButton(
                      onPressed: () {
                        chooseFile();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        fixedSize: Size(MediaQuery.of(context).size.width, 60),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _file == null
                                ? Text('Upload KTP')
                                : Text(_file!.path),
                            Icon(Icons.add_a_photo)
                          ])),
                  SizedBox(height: 10),

                  OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        fixedSize: Size(MediaQuery.of(context).size.width, 60),
                      ),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upload Kartu Darah',
                            ),
                            Icon(Icons.add_a_photo)
                          ])),
                  SizedBox(height: 10),

                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 60)),
                      onPressed: () {},
                      child: const Text("Registrasi"))
                ]),
          ),
        ),
      )),
    );
  }
}
