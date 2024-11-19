import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/util/permission_handler.dart';

class MediaController extends GetxController {
  Rx<File?> selectedFile = Rx<File?>(null);

  Rx<TextEditingController> textController = Rx(TextEditingController());
  final ImagePicker _picker = ImagePicker();

  RxString base64String = ''.obs;

  bool get isImage =>
      (selectedFile.value?.path ?? "").endsWith(".jpg") ||
      (selectedFile.value?.path ?? "").endsWith(".png");
  bool get isMediaPicked => (selectedFile.value?.path ?? "").isNotEmpty;

  Future<void> pickMediaFromCamera() async {
    return Get.dialog(
      AlertDialog(
        title: const Text('Select an Option'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              captureImage();
              Get.back(); // Close the dialog
            },
            child: const Text('Image'),
          ),
          TextButton(
            onPressed: () {
              captureVideo();
              Get.back(); // Close the dialog
            },
            child: const Text('Video'),
          ),
        ],
      ),
    );
  }

  Future<void> captureImage() async {
    bool isGranted = await PermissionHandler.checkCameraAccess();
    if (!isGranted) return;
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedFile.value = File(image.path);
      base64String.value = base64Encode(await image.readAsBytes());
      update();
    }
  }

  // Capture a video with the camera
  Future<void> captureVideo() async {
    bool isGranted = await PermissionHandler.checkCameraAccess();
    if (!isGranted) return;
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      selectedFile.value = File(video.path);
      base64String.value = base64Encode(await video.readAsBytes());
      update();
    }
  }

  // Share Base64 string or perform any operation
  void shareMedia() {
    textController.value.clear();
    if (base64String.isNotEmpty) {
      textController.value.text = base64String.value;
      update();
    } else {
      Get.snackbar("No Media", "Please select or capture a media first");
    }
  }

  Future<void> pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowCompression: false,
    );
    if (result != null) {
      // Get the selected file path
      String? filePath = result.files.single.path;

      if (filePath != null) {
        // Read the file into a byte array
        File file = File(filePath);
        selectedFile.value = File(filePath);

        List<int> fileBytes = await file.readAsBytes();

        // Convert the byte array to a Base64 string
        base64String.value = base64Encode(fileBytes);
      } else {
        print("File path is null.");
      }
    } else {
      print("No file selected.");
    }
    update();
  }

  Future<void> decodeBase64AndSaveToFile(
      String base64String, String filePath) async {
    try {
      // Decode the Base64 string into bytes
      List<int> fileBytes = base64Decode(base64String);

      // Create a file and write the bytes to it
      File file = File(filePath);
      await file.writeAsBytes(fileBytes);

      print("File saved at: $filePath");
    } catch (e) {
      print("Error decoding Base64: $e");
    }
  }

  void clearMedia() {
    selectedFile = Rx<File?>(null);
    base64String = "".obs;
    update();
  }
}
