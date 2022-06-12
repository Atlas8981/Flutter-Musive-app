import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:spotify_clone/utils/MusicDataViewer.dart';

import '../repositories/MusicService.dart';
import '../utils/constant.dart';

class AddMusicPage extends StatefulWidget {
  const AddMusicPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddMusicPage> createState() => _AddMusicPageState();
}

class _AddMusicPageState extends State<AddMusicPage> {
  final musicService = MusicService();
  FilePickerResult? result;
  Metadata? metadata;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Music"),
        actions: [
          (result != null)
              ? IconButton(
                  onPressed: () {
                    confirmMusicAdd();
                  },
                  icon: Icon(Icons.check),
                )
              : Container(),
        ],
      ),
      body: highLevelWidget(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                openFilePicker();
              },
              child: Text("Add Music File"),
            ),
          ),
          MusicDataViewer(music: metadata),
        ],
      ),
    );
  }

  Future<void> confirmMusicAdd() async {
    if (result == null) {
      return;
    }
    setState(() {
      isVisible = true;
    });
    final selectedMusicFile = result!.files[0];
    await musicService.addMusic(selectedMusicFile);
    setState(() {
      isVisible = false;
    });
    showToast("Done");
  }

  Future<void> openFilePicker() async {
    final tempResult = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
      lockParentWindow: true,
      withData: true,
      withReadStream: true,
    );
    if (tempResult != null) {
      result = tempResult;
      final file = result!.files[0];
      if (kIsWeb) {
        metadata = await MetadataRetriever.fromBytes(file.bytes!);
      } else {
        metadata = await MetadataRetriever.fromFile(File(file.path!));
      }
      setState(() {});
    }
  }

  Widget highLevelWidget({required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          Visibility(
            visible: isVisible,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                ...children
              ],
            ),
          ),
        ],
      ),
    );
  }
}
