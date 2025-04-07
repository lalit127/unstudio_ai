import 'package:fal_client/src/common.dart';

class TrainingResult {
  final String? loraName;
  final String? modelName;
  final String? requestId;
  String? previewImage;
  final List<String> trainingImages;

  TrainingResult({
    this.loraName,
    this.modelName,
    this.requestId,
    this.previewImage,
    this.trainingImages = const [],
  });

  factory TrainingResult.fromJson(Map<String, dynamic> json) => TrainingResult(
    loraName: json['loraName'],
    modelName: json['modelName'],
    requestId: json['requestId'],
    previewImage: json['previewImage'],
    trainingImages: List<String>.from(json['trainingImages'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'loraName': loraName,
    'modelName': modelName,
    'requestId': requestId,
    'previewImage': previewImage,
    'trainingImages': trainingImages,
  };

  factory TrainingResult.fromFalOutput(FalOutput result, String loraName) {
    return TrainingResult(
      loraName: loraName,
      modelName: result.data['lora_name'] ?? loraName,
      requestId: result.requestId,
      previewImage: result.data['preview_image_url'],
      trainingImages: List<String>.from(
        result.data['instance_data']?.map((e) => e['image']) ?? [],
      ),
    );
  }
}
