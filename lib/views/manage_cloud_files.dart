import 'package:flutter/material.dart';

import '../utils/cloud_data_handlers/firebase_cloud_handler.dart';
import '../widgets/listing_card.dart';

class ManageCloudFiles extends StatefulWidget {
  @override
  _ManageCloudFilesState createState() => _ManageCloudFilesState();
}

class _ManageCloudFilesState extends State<ManageCloudFiles> {
  bool _isFileListLoading = true;

  _loadCloudFiles() async {
    setState(() {
      _isFileListLoading = true;
    });
    await cloudHandler.getFiles().whenComplete(() {
      setState(() {
        _isFileListLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCloudFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloud Files"),
        backgroundColor: Colors.blue[700],
      ),
      body: _isFileListLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : cloudHandler.cloudFiles.length > 0
              ? ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final fileName = cloudHandler.cloudFiles[index].name
                        .substring(
                            0,
                            cloudHandler.cloudFiles[index].name
                                .lastIndexOf('.'));
                    return buildCloudListItem(
                        context, fileName, cloudHandler.cloudFiles[index],
                        () async {
                      await cloudHandler.getFiles();
                      setState(() {});
                    });
                  },
                  itemCount: cloudHandler.cloudFiles.length,
                )
              : Center(
                  child: Text(
                    'No file found\nUpload files on cloud storage',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.2,
                  ),
                ),
    );
  }
}
