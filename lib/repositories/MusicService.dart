import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import '../models/Song.dart';
import '../utils/constant.dart';

class MusicService {
  final storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;

  ///POST
  Future<void> addMusic(PlatformFile file) async {
    late final Metadata metadata;
    if (kIsWeb) {
      metadata = await MetadataRetriever.fromBytes(file.bytes!);
    } else {
      metadata = await MetadataRetriever.fromFile(File(file.path!));
    }
    final String? musicFileUrl = await uploadMusicFile(metadata);
    final String? artworkUrl = await uploadArtwork(metadata);
    if (musicFileUrl == null) {
      return;
    }
    final id = db.collection("music").id;
    final music = Song(
      id: id,
      trackName: metadata.trackName,
      trackArtistNames: metadata.trackArtistNames,
      albumName: metadata.albumName,
      albumArtistName: metadata.albumArtistName,
      year: metadata.year,
      genre: metadata.genre,
      mimeType: metadata.mimeType,
      filePath: metadata.filePath,
      musicFileUrl: musicFileUrl,
      artworkFileUrl: artworkUrl,
    );
    await uploadMusicData(music);
  }

  Future<bool> uploadMusicData(Song music) async {
    try {
      await db.collection("music").doc(music.id).set(music.toMap());
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<String?> uploadMusicFile(Metadata file) async {
    try {
      final musicFilename = "${DateTime.now()} - ${file.trackName}";
      final musicStorageRef = storage.ref('music/').child(musicFilename);

      if (file.filePath != null) {
        await musicStorageRef.putFile(File(file.filePath!));
      }
      final musicFileUrl = await musicStorageRef.getDownloadURL();
      return musicFileUrl;
    } on FirebaseException catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<String?> uploadArtwork(Metadata file) async {
    try {
      final artworkFilename = "${DateTime.now()} - ${file.albumName}";
      final artworkStorageRef = storage.ref('artwork/').child(artworkFilename);

      if (file.albumArt != null) {
        await artworkStorageRef.putData(file.albumArt!);
      }
      final artworkUrl = await artworkStorageRef.getDownloadURL();
      return artworkUrl;
    } on FirebaseException catch (e) {
      print(e.message);
    }
    return null;
  }

  ///GET
  Future<List<Song>?> getMusics() async {
    try {
      final querySnapshot = await db.collection(musicCollection).get();
      return querySnapshot.docs.map((e) {
        return Song.fromMap(e.data(), id: e.id);
      }).toList();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  ///DELETE

  Future<bool> deleteMusic(String id) async {
    try {
      await db.collection("music").doc(id).delete();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
