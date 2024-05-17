import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadToFirebase(File imageFile, String uid) async {
  try {
    // Create a reference to the Firebase Storage bucket
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child(uid)
        .child("Media")
        .child('images/${DateTime.now()}.jpg');

    // Upload the file to Firebase Storage
    final UploadTask uploadTask = storageRef.putFile(imageFile);

    // Wait for the upload to complete
    final TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});

    // Get the download URL for the file
    final String downloadUrl = await storageSnapshot.ref.getDownloadURL();

    // Return the download URL
    return downloadUrl;
  } catch (error) {
    // Handle any errors that occur during the process
    print('Error uploading image: $error');
    return null;
  }
}
