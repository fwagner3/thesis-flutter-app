import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class NativeFeaturesPage extends StatefulWidget {
  const NativeFeaturesPage({ super.key });

  @override
  State<NativeFeaturesPage> createState() => _NativeFeaturesPageState();
}

class _NativeFeaturesPageState extends State<NativeFeaturesPage> {
  var _image;
  var imagePicker;

  Position? _position;

  Map<String, String> _keyValuePairs = {};

  final keyController = TextEditingController();
  final valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    _loadKeyValuePairs();
  }

  // Load all stored key-value pairs from the preferences storage and set them as state
  Future<void> _loadKeyValuePairs() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();

    Map<String, String> map = {};

    keys.forEach((element) {
      map[element] = prefs.get(element) as String;
    });

    setState(() {
      _keyValuePairs = map;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Show an error dialog, if the needed permission for getting the geolocation is missing
    showErrorDialog(String message) {
      showCupertinoDialog(
        context: context, 
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Location Permission'),
          content: Text(message),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok')
            )
          ]
        )
      );
    }

    // Ask the user for permission to get the geolocation
    Future<bool> getLocationPermission() async {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showErrorDialog("Location services disabled");
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showErrorDialog("The location permission is denied");
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showErrorDialog("The location permission is permanently denied");
        return false;
      }
      
      return true;
    }

    // Generate a list of widgets from the state
    List<Text> generateKeyValueWidgets() {
      List<Text> list = [];

      _keyValuePairs.forEach((key, value) {
        list.add(Text('$key: $value'));
      });

      return list;
    }

    // Add an entry to the shared preferences
    void addEntry(String key, String value) async {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(key, value);

      await _loadKeyValuePairs();

      keyController.text = "";
      valueController.text = "";
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: (
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gallery Image Picker',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                ),
                Container(height: 16),
                CupertinoButton.filled(
                  onPressed: () async {
                    XFile image = await imagePicker.pickImage(
                      source: ImageSource.gallery, imageQuality: 50
                    );
                    setState(() {
                      _image = File(image.path);
                    });
                  },
                  child: const Text('Gallery Image Picker')
                ),
                Container(height: 8.0),
                _image != null
                  ? Image.file(
                    _image,
                    width: 200,
                    height: 200,
                    fit: BoxFit.fitHeight
                  )
                  : Container (
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.black
                    )
                  ),
                Container(height: 32),
                const Text(
                  'Geolocation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                ),
                Container(height: 16),
                CupertinoButton.filled(
                  onPressed: () async {
                    var permissionCheck = await getLocationPermission();
            
                    if (!permissionCheck) {
                      return;
                    } 
            
                    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            
                    setState(() {
                      _position = pos;
                    });
                  },
                  child: const Text('Get Location')
                ),
                Container(height: 8),
                Text('Latitude: ${_position?.latitude ?? ''}'),
                Text('Longitude: ${_position?.longitude ?? ''}'),
                Container(height: 32.0),
                const Text(
                  'Preferences',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                ),
                Container(height: 16),
                CupertinoTextField(
                  placeholder: 'Enter a key',
                  controller: keyController
                ),
                CupertinoTextField(
                  placeholder: 'Enter a value',
                  controller: valueController
                ),
                Container(height: 8.0),
                CupertinoButton.filled(
                  onPressed: () {
                    addEntry(keyController.text, valueController.text);
                  },
                  child: const Text('Store')
                ),
                Container(height: 8.0),
                ...generateKeyValueWidgets(),
                Container(height: 32.0),
                const Text(
                  'Share API',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                ),
                Container(height: 16),
                CupertinoButton.filled(
                  onPressed: () {
                    Share.share('This is the share text', subject: 'Share API Test');
                  },
                  child: const Text('Share API')
                )
              ]
            )
          ),
        ),
      ),
    );
  }
}