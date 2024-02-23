import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class showData extends StatefulWidget {
  const showData({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _showData createState() => _showData();
}

class _showData extends State<showData> {
  List<dynamic> _jsonData = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');
    String jsonString = await file.readAsString();
    setState(() {
      _jsonData = json.decode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Daten'),
      ),
      body: _jsonData.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _jsonData.length,
              itemBuilder: (context, index) {
                var data = _jsonData[index];
                return ListTile(
                  title: Text('RaumCode: ${data['RaumCode']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CountDRT: ${data['countDRT']}'),
                      Text('MeanDRT: ${data['meanDRT']}'),
                      Text('TotalElapsedTime: ${data['totalElapsedTime']}'),
                      Text('drtTimes: ${data['drtTimes']}'),
                      Text('exceedsBoxFrame: ${data['exceedsBoxFrame']}'),
                      Text('maxIntensityError: ${data['maxIntensityError']}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
