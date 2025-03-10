import 'dart:math';

class GetImage {
  static String getRandomImage() {
    List<String> images = [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-XnUdhIOa2PJSwmG24hWPx-9Re15MlBNdyw&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxjBJX7zl6GYSaZ6d9dJfskmhsYsFv7peEJw&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdKPKmvPNbBEVyTfoaYavk2MA3YO6sObpU8A&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-XnUdhIOa2PJSwmG24hWPx-9Re15MlBNdyw&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzG1EoMRhjp2htb5J12Pk50AAMaPJhbOBF4w&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-hNcumdslPPmpOkWaamIdZn1B5ufzBIXNKA&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdKPKmvPNbBEVyTfoaYavk2MA3YO6sObpU8A&s',
    ];
    return images[Random().nextInt(images.length)];
  }
}

String Randimage = GetImage.getRandomImage(); // ✅ Call a static method
