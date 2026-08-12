import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'f4vugqmv'; 
  static const String uploadPreset = 'food_delivery_preset'; 

  static final Uri _cloudinaryUri = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );

  static Future<String?> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest('POST', _cloudinaryUri)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] = 'products'
        ..files.add(
          await http.MultipartFile.fromPath('file', imageFile.path),
        );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonMap = jsonDecode(responseData);
        return jsonMap['secure_url'] as String?; 
      } else {
        print("Cloudinary HTTP Error Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Cloudinary Upload Exception: $e");
      return null;
    }
  }
}