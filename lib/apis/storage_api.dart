import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/core/provider.dart';

final storageAPIProvider = Provider((ref) {
  return StorageApi(storage: ref.watch(Dependency.storage));
});

class StorageApi {
  final Storage _storage;
  StorageApi({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImages(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteEnvironment.imageBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      imageLinks.add(AppwriteEnvironment.imageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }
}
