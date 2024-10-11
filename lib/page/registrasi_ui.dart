import 'dart:io';

import 'package:donor_darah/controller/auth_controller.dart';
import 'package:donor_darah/controller/relawan_controller.dart';
import 'package:donor_darah/page/relawan/profile_ui.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegistrasiUi extends StatefulWidget {
  final Map<String, dynamic> userRelawan;
  RegistrasiUi({super.key, required this.userRelawan});

  @override
  State<RegistrasiUi> createState() => _RegistrasiUiState();
}

class _RegistrasiUiState extends State<RegistrasiUi> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RelawanController relawanController = RelawanController();
  LoginController loginController = LoginController();

  String? _selectedGender;
  String? _selectedBlood;
  final name = TextEditingController();
  final blood = TextEditingController();
  final umur = TextEditingController();
  final jenis = TextEditingController();
  final fileKTP = TextEditingController();
  final fileDarah = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _file;
  File? _fileDarah;
  String? imageKtp;
  String? imageDarah;

  Future<void> openCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
    }
  }


 Future<void> openGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
    }
  }

  
  Future<void> chooseFile(String imageType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      switch (imageType) {
        case "ktp":
          _file = File(pickedFile.path);
          imageKtp = pickedFile.name;
          print('KTP image selected. ${imageKtp}');
          break;
        case "darah":
          _fileDarah = File(pickedFile.path);
          imageDarah = pickedFile.name;
          print('Blood image selected. ${imageDarah}');
          break;
      }
    } else {
      print('No file selected.');
    }
    setState(() {});
  }

  Future<void> pickImage(String imageType, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (imageType == "ktp") {
          _file = File(pickedFile.path);
          imageKtp = pickedFile.name;
        } else if (imageType == "darah") {
          _fileDarah = File(pickedFile.path);
          imageDarah = pickedFile.name;
        }
      });
    }
  }

 void showImageSourceSelection(BuildContext context, String imageType) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () {
                      pickImage(imageType, ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    pickImage(imageType, ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }



  Future<String> uploadFile(File file) async {
    final storage = FirebaseStorage.instance;
    final referencePath =
        'uploads/${file.path.split('/').last}'; // Replace with your desired storage path
    final reference = storage.ref().child(referencePath);
    final uploadTask = reference.putFile(file);

    // Monitor upload progress (optional)
    uploadTask.snapshotEvents.listen((event) {
      final progress = (event.bytesTransferred / event.totalBytes) * 100;
      print('Upload progress: $progress%');
    });

    // Wait for the upload to complete
    await uploadTask.whenComplete(() => null);

    // Get the download URL
    final downloadUrl = await reference.getDownloadURL();
    print('File uploaded successfully! Download URL: $downloadUrl');
    return downloadUrl;
  }

  void registerRelawan() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        "name": name.text,
        "bloodType": _selectedBlood,
        "umur": umur.text,
        "jenis_kelamin": _selectedGender,
        "isRelawan": true,
        "status": false
      };
      String emailKu = widget.userRelawan["email"];

      if (_file != null) {
        String ktpUrl = await uploadFile(_file!);
        data['ktp_file'] = ktpUrl;
      }

      if (_fileDarah != null) {
        String darahUrl = await uploadFile(_fileDarah!);
        data['blood_card_file'] = darahUrl;
      }

      bool userR = await relawanController.updateUser(emailKu, data);

      if (userR) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProfileUi()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal register')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registrasi relawan donor darah",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

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
                          controller: umur,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Umur",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else if (int.tryParse(value) == null) {
                              return 'Umur harus berupa angka';
                            } else if (int.tryParse(value)! < 17) {
                              return 'Umur harus lebih 17 tahun';
                            }
                            return null;
                          },
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
                  OutlinedButton(
                       onPressed: () => showImageSourceSelection(context, "ktp"),
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
                                : Text(imageKtp.toString()),
                            Icon(Icons.add_a_photo)
                          ])),
                  SizedBox(height: 10),

                  OutlinedButton(
                       onPressed: () => showImageSourceSelection(context, "darah"),
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
                                ? Text('Upload Kartu Darah')
                                : Text(imageDarah.toString()),
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
                      onPressed: () {
                        registerRelawan();
                      },
                      child: const Text("Registrasi"))
                ]),
          ),
        ),
      )),
    );
  }
}
