import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/utils/utils.dart';
import 'package:fuel_pro_360/shared/widgets/custom_popup.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MeterReadingImage extends ConsumerStatefulWidget {
  @override
  _MeterReadingImageState createState() => _MeterReadingImageState();
}

class _MeterReadingImageState extends ConsumerState<MeterReadingImage> {
  void chooseFromPopup() {
    customPopup(
        context: context,
        childWidget: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
          color: Colors.white,
          child: Column(
            children: [
              const Text(
                "Choose from",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          color: UiColors.black,
                          semanticLabel: 'Camera',
                        ),
                        color: Colors.white,
                        iconSize: 50.0,
                        onPressed: () {
                          setImage(imageSource: ImageSource.camera);
                        },
                      ),
                      const Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.insert_photo,
                          color: UiColors.black,
                          semanticLabel: 'Gallery',
                        ),
                        color: Colors.white,
                        iconSize: 50.0,
                        onPressed: () {
                          setImage(imageSource: ImageSource.gallery);
                        },
                      ),
                      const Text(
                        'Library',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Future<XFile?> pickImage({required ImageSource imageSource}) async {
    try {
      return await ImagePicker().pickImage(
        source: imageSource,
        imageQuality: 80,
        maxHeight: 1080,
      );
    } on PlatformException catch (error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Error picking image'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    return null;
  }

  void setImage({required ImageSource imageSource}) async {
    Navigator.of(context).pop();
    XFile? image = await pickImage(imageSource: imageSource);

    if (image != null) {
      File imageFile = File(image.path);

      //Compress image if size if greater than 4MB
      if ((imageFile.lengthSync() / 1048576) > 4) {
        var dir = await (Platform.isIOS
            ? getApplicationSupportDirectory()
            : getApplicationDocumentsDirectory());

        String targetFilePath = '${dir.path}/_compressed.jpg';
        XFile compressedFile =
            await compressAndGetImageFile(File(imageFile.path), targetFilePath);

        setState(() {
          imageFile = File(compressedFile.path);
        });
      } else {
        setState(() {
          imageFile = File(imageFile.path);
        });
      }

      ref.read(meterReadingImageProvider.notifier).state = imageFile;

      // Optionally, you can show a success message or perform any other action
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image selected successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final meterReadingImage = ref.watch(meterReadingImageProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextFieldLabel(label: 'Meter Reading Image (Optional)'),
        Container(
            width: double.infinity,
            height: 200,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: meterReadingImage == null
                ? Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image_outlined,
                            size: 56, color: Colors.black),
                        const SizedBox(height: 16),
                        const Text(
                          'Upload meter reading image',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () {
                            chooseFromPopup();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // Change color as needed
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.upload, color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                  'Upload Image',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Image.file(
                        meterReadingImage,
                        fit: BoxFit.cover,
                        frameBuilder: (BuildContext context, Widget child,
                            int? frame, bool wasSynchronouslyLoaded) {
                          if (frame == null) {
                            return CircularProgressIndicator();
                          } else {
                            return child;
                          }
                        },
                      ),
                      Positioned(
                        right: -10,
                        top: -10,
                        child: IconButton(
                          onPressed: () {
                            ref.read(meterReadingImageProvider.notifier).state =
                                null;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Image removed successfully!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50)),
                            child: const Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
      ],
    );
  }
}
