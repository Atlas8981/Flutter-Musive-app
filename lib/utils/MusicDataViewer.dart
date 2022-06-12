import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import 'constant.dart';

class MusicDataViewer extends StatefulWidget {
  const MusicDataViewer({
    Key? key,
    this.music,
  }) : super(key: key);
  final Metadata? music;

  @override
  State<MusicDataViewer> createState() => _MusicDataViewerState();
}

class _MusicDataViewerState extends State<MusicDataViewer> {
  @override
  Widget build(BuildContext context) {
    final Metadata? metadata = widget.music;
    if (metadata == null) {
      return Center(
        child: Text("Pick music to display data"),
      );
    }
    return Column(
      children: [
        SizedBox(height: 8),
        albumWidget(metadata),
        songWidget(metadata),
      ],
    );
  }

  Widget albumWidget(Metadata metadata) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Album",
          style: TextStyle(fontSize: 24),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: albumArtworkWidget(metadata.albumArt),
          title: Text(
            metadata.albumName ?? " ",
          ),
          subtitle: Text(metadata.albumArtistName ?? ""),
        ),
      ],
    );
  }

  Widget songWidget(Metadata metadata) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Song Info",
          style: TextStyle(fontSize: 24),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            metadata.trackName ?? "",
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Row(
            children: [
              ...metadata.trackArtistNames?.map((e) {
                    return Text(
                      e,
                      style: TextStyle(fontSize: 16),
                    );
                  }).toList() ??
                  [],
            ],
          ),
          trailing: Text(formatDateTimeFromInt(metadata.trackDuration)),
        ),
      ],
    );
  }

  Widget albumArtworkWidget(Uint8List? artwork) {
    if (artwork == null) {
      return Container();
    }

    return ExtendedImage.memory(
      artwork,
      fit: BoxFit.contain,
      height: 60,
      // width: double.infinity,
    );
  }
}
