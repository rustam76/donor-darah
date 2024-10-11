import 'package:donor_darah/page/help/bagaiman_login.dart';
import 'package:donor_darah/page/help/bagaimana_cari.dart';
import 'package:donor_darah/page/help/bagaimana_donor.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  bool _isExpanded1 = false; // Separate state variables for each section
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;
  void _onItemTapped(int number) {
    switch (number) {
      case 1:
        setState(() {
          _isExpanded1 = !_isExpanded1; // Update _isExpanded1
        });
        break;
      case 2:
        setState(() {
          _isExpanded2 = !_isExpanded2; // Update _isExpanded2
        });
        break;

      case 3:
        setState(() {
          _isExpanded3 = !_isExpanded3; // Update _isExpanded2
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          children: [
            ExpansionPanel(
              isExpanded: _isExpanded3, // Use separate states
              headerBuilder: (context, isExpanded) => ListTile(
                title: Text('bagaimana saya masuk aplikasi?'),

                onTap: () => _onItemTapped(3), // Call _onItemTapped with 1
              ),
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: BagaimanLogin(),
              ),
            ),
            ExpansionPanel(
              isExpanded: _isExpanded1, // Use separate states
              headerBuilder: (context, isExpanded) => ListTile(
                title: Text('bagaimana saya mendapatkan pendonoran darah?'),

                onTap: () => _onItemTapped(1), // Call _onItemTapped with 1
              ),
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: BagaimanCari(),
              ),
            ),
            ExpansionPanel(
              isExpanded: _isExpanded2, // Use separate states
              headerBuilder: (context, isExpanded) => ListTile(
                title: Text('bagamana jadi relawan?'),
                onTap: () => _onItemTapped(2), // Call _onItemTapped with 2
              ),
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: BagaimanDonor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
