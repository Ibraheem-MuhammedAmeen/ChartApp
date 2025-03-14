import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImgAvatar extends StatelessWidget {
  const ImgAvatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 150,
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.grey,
                  child: const Center(
                    child: Text('No Image'),
                  ),
                ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image =
                await picker.pickImage(source: ImageSource.gallery);
            if (image == null) {
              return;
            }
            // Get Supabase instance
            final supabase = Supabase.instance.client;
            final userId = supabase.auth.currentUser!.id;
            final imageBytes = await image.readAsBytes();
            final imagePath = '/$userId/profile';

            await supabase.storage
                .from('profiles')
                .uploadBinary(imagePath, imageBytes);
            final imageUrl =
                supabase.storage.from('profiles').getPublicUrl(imagePath);
            onUpload(imageUrl);
          },
          child: const Text('Upload'),
        ),
      ],
    );
  }
}
