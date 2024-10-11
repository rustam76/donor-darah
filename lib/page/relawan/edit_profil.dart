import 'dart:io';
import 'package:donor_darah/controller/auth_controller.dart';
import 'package:donor_darah/controller/relawan_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfil extends StatefulWidget {
  final Map<String, dynamic> editProfil;
  EditProfil({Key? key, required this.editProfil}) : super(key: key);

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RelawanController relawanController = RelawanController();
  final LoginController loginController = LoginController();

  String? _selectedGender;
  String? _selectedBlood;

  final TextEditingController name = TextEditingController();
  final TextEditingController umur = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _fileKTP;
  File? _fileDarah;
  String? imageKtp;
  String? imageDarah;

  @override
  void initState() {
    super.initState();
    name.text = widget.editProfil['name'] ?? '';
    umur.text = widget.editProfil['umur']?.toString() ?? '';
    _selectedBlood = widget.editProfil['bloodType'];
    _selectedGender = widget.editProfil['jenis_kelamin'];
    imageKtp = widget.editProfil['ktp_file'];
    imageDarah = widget.editProfil['blood_card_file'];
  }

  Future<void> chooseFile(String imageType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imageType == "ktp") {
          _fileKTP = File(pickedFile.path);
          imageKtp = pickedFile.name;
        } else if (imageType == "darah") {
          _fileDarah = File(pickedFile.path);
          imageDarah = pickedFile.name;
        }
      });
    } else {
      print('No file selected.');
    }
  }

  Future<String> uploadFile(File file) async {
    final storage = FirebaseStorage.instance;
    final referencePath = 'uploads/${file.path.split('/').last}';
    final reference = storage.ref().child(referencePath);
    final uploadTask = reference.putFile(file);

    uploadTask.snapshotEvents.listen((event) {
      final progress = (event.bytesTransferred / event.totalBytes) * 100;
      print('Upload progress: $progress%');
    });

    await uploadTask.whenComplete(() => null);
    final downloadUrl = await reference.getDownloadURL();
    // print('File uploaded successfully! Download URL: $downloadUrl');
    return downloadUrl;
  }

  String truncateFileName(String fileName, int maxLength) {
    if (fileName.length <= maxLength) {
      return fileName;
    } else {
      return fileName.substring(0, maxLength - 3) + '...';
    }
  }

  void registerRelawan() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        "name": name.text,
        "bloodType": _selectedBlood,
        "umur": umur.text,
        "jenis_kelamin": _selectedGender,
        "isRelawan": true,
        // "status": false
      };
      String emailKu = widget.editProfil["email"];

      if (_fileKTP != null) {
        String ktpUrl = await uploadFile(_fileKTP!);
        data['ktp_file'] = ktpUrl;
      }

      if (_fileDarah != null) {
        String darahUrl = await uploadFile(_fileDarah!);
        data['blood_card_file'] = darahUrl;
      }

      bool userR = await relawanController.updateUser(emailKu, data);

      if (userR) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Berhasil update!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update')),
        );
      }
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah kamu yakin untuk update data kamu?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text("Ya"),
              onPressed: () {
                Navigator.of(context).pop();
                registerRelawan();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profil",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nama Lengkap",
                ),
                controller: name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama lengkap';
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
                          return 'Masukkan umur';
                        } else if (int.tryParse(value) == null) {
                          return 'Umur harus berupa angka';
                        } else if (int.parse(value) < 17) {
                          return 'Umur harus lebih dari 17 tahun';
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
                onPressed: () {
                  chooseFile('ktp');
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
                    Text(
                      imageKtp != null
                          ? truncateFileName(imageKtp!, 30)
                          : 'Pilih file KTP',
                      overflow: TextOverflow.ellipsis,
                    ),
                    Icon(Icons.add_a_photo),
                  ],
                ),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  chooseFile('darah');
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
                    Text(
            imageDarah != null ? truncateFileName(imageDarah!, 30) : 'Pilih file KTP',
            overflow: TextOverflow.ellipsis,
          ),
            
                    Icon(Icons.add_a_photo),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(MediaQuery.of(context).size.width, 60),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showUpdateDialog();
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
