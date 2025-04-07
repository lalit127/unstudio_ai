import 'dart:convert';
import 'dart:typed_data';

class CaptionModelResponse {
  final String? caption;
  final Uint8List? imageBytes;

  CaptionModelResponse({this.caption, this.imageBytes});

  factory CaptionModelResponse.fromJson(Map<String, dynamic> json) {
    return CaptionModelResponse(
      caption: json['caption'],
      imageBytes:
          json['imageBytes'] != null ? base64Decode(json['imageBytes']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'imageBytes': imageBytes != null ? base64Encode(imageBytes!) : null,
    };
  }
}
