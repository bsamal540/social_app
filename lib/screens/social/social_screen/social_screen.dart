import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/screens/social/social_media_controller/media_controller.dart';

class MediaScreen extends GetView<MediaController> {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaController controller = Get.put(MediaController());
    return Scaffold(
      appBar: _appBarWidget(),
      body: _mediaScreenBody(),
    );
  }

  AppBar _appBarWidget() {
    return AppBar(
      title: const Text("Compose"),
      actions:  [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: InkWell(
              onTap: (){
                controller.shareMedia();
              },
              child: const Icon(Icons.send)),
        )
      ],
    );
  }

  Widget _mediaScreenBody() {
    return GetBuilder<MediaController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blueAccent,
              child: Text(
                "B",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              "Biswajit Samal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ]),
          const SizedBox(height: 16),
          TextField(
            controller: controller.textController.value,
            maxLines: 6,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter your notes here...",
            ),
          ),
          const SizedBox(height: 16),
          if (controller.isMediaPicked)
            Flexible(
                child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: controller.isImage
                        ? Image.file(
                            controller.selectedFile.value!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            color: Colors.black,
                            child: const Icon(Icons.play_arrow,
                                color: Colors.white),
                          ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      controller.clearMedia();
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ],
            )),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              controller.pickMedia();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.image),
                Text(
                    controller.isMediaPicked
                        ? "Photos/Videos"
                        : "Select Photo or Video",
                    style: textStyle),
              ],
            ),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () {
              controller.pickMediaFromCamera();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.camera_alt),
                Text(
                    controller.isMediaPicked ? "Camera" : "Take Photo or Video",
                    style: textStyle),
              ],
            ),
          ),
        ]),
      );
    });
  }

  TextStyle get textStyle =>
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
}
