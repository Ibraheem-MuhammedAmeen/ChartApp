import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class Helpers {
  static final random = Random();

  static String randomPictureUrl() {
    final randomInt = random.nextInt(1000);
    return 'https://picsum.photos/seed/$randomInt/300/300';
  }

  static DateTime randomDate() {
    final random = Random();
    final currentDate = DateTime.now();
    return currentDate.subtract(Duration(seconds: random.nextInt(200000)));
  }
}

Future<String?> getUserName() async {
  firebase.User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return userDoc.exists ? userDoc['Name'] : null;
}

Future<String?> onSubmitSupbase(File pickedImage) async {
  print(' here we are in the helpers class');
  try {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception("User not authenticated");
    }

    final imageBytes = await pickedImage.readAsBytes();
    final imagePath = '$userId/profile.jpg';

    await supabase.storage.from('profiles').uploadBinary(
          imagePath,
          imageBytes,
          fileOptions: const FileOptions(upsert: true), // Allow overwriting
        );

    final imageUrl = supabase.storage.from('profiles').getPublicUrl(imagePath);
    print('finished the code from the helpers and there is no error');
    return imageUrl;
  } catch (error) {
    print("Error uploading to Supabase: $error");
    print('error from helppers class');
    return null;
  }
}
