import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:unstudio_ai/common/app_text_field.dart';
import 'package:unstudio_ai/controllers/prompt_controller.dart';
import 'package:unstudio_ai/models/training_result.dart';
import 'package:unstudio_ai/modules/feed/widgets/feed_model_progress_screen.dart';

class PromptGenerationScreen extends StatefulWidget {
  final TrainingResult result;

  const PromptGenerationScreen({super.key, required this.result});

  @override
  State<PromptGenerationScreen> createState() => _PromptGenerationScreenState();
}

class _PromptGenerationScreenState extends State<PromptGenerationScreen> {
  late PromptGenerationController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(PromptGenerationController(result: widget.result));
    controller.fetchModelStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: const Text('Generate Image')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  AppTextField(
                    onChanged: (value) => controller.prompt.value = value,
                    hintText: 'Enter Prompt',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : controller.generateImage,
                    child: const Text('Generate'),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      itemCount: controller.result.trainingImages.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        return Image.network(
                          controller.result.trainingImages[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  if (controller.generatedImageUrl.value != null) ...[
                    const SizedBox(height: 20),
                    const Text("Generated Image:"),
                    Image.network(controller.generatedImageUrl.value!),
                  ],
                ],
              ),
            ),

            // Overlay loader
            if (controller.isLoading.value)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
