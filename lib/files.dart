import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:date_time_pro/date_times.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_plus/file_data.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';

enum FileMode {
  /// open camera
  camera,

  /// open gallery
  gallery,

  /// open file manager
  file
}

class Files {
  Files._();

  static String _fileMoreThanMB(int maxFileSizeInMb) =>
      "File more than $maxFileSizeInMb MB, Please select another file";

  static const pdf = "pdf";
  static const doc = "doc";
  static const docx = "docx";
  static const xls = "xls";
  static const xlsx = "xlsx";
  static const ppt = "ppt";
  static const pptx = "pptx";
  static const jpg = "jpg";
  static const jpeg = "jpeg";
  static const png = "png";
  static const gif = "gif";

  static List<String> deletedFileList = [];
  static List<FileData> fileDataList = [];

  static FileData fileData = FileData();

  static bool _isNullOREmpty(String? str) {
    if (str == null || str.isEmpty) {
      return true;
    }
    return false;
  }

  static bool _equals(String str1, String str2, {bool ignoreCase = true}) {
    if (ignoreCase) {
      return (str1.toLowerCase() == str2.toLowerCase());
    } else {
      return (str1 == str2);
    }
  }

  static openFile(BuildContext context, String? filePath) async {
    try {
      if (!Files._isNullOREmpty(filePath)) {
        if (Files.webFilePath(filePath!)) {
          /*Navigate.to(context, Routes.viewer, arguments: {'filePath': filePath});*/
        } else {
          OpenFile.open(filePath);
        }
      } else {
        dev.log("File not found");
      }
    } catch (e) {
      dev.log("Could not load");
    }
  }

  static bool webFilePath(String filePath) {
    if ((filePath.toLowerCase()).startsWith('http')) {
      return true;
    } else {
      return false;
    }
  }

  static String createFileName(String fileStr) {
    String fileName = "";
    if (!Files._isNullOREmpty(fileStr)) {
      fileName =
          "attachment_${DateTimes.getCurrentDateTime(format: DateTimes.fyyyyMMddHHmmss)}_${Random().nextInt(999)}${Files.getFileExtension(fileStr)}";
    }
    return fileName;
  }

  static String getFileName(String? fileStr, {bool withExtension = true}) {
    String fileName = "";
    if (withExtension) {
      if (!Files._isNullOREmpty(fileStr)) {
        if (fileStr.toString().contains("/")) {
          fileName = (fileStr
                  .toString()
                  .substring(fileStr.toString().lastIndexOf("/")))
              .replaceAll("/", "");
        } else {
          fileName = fileStr.toString();
        }
      }
    } else {
      if (!Files._isNullOREmpty(fileStr)) {
        if (fileStr.toString().contains("/")) {
          fileName = ((fileStr
                      .toString()
                      .substring(fileStr.toString().lastIndexOf("/")))
                  .replaceAll("/", ""))
              .replaceAll(Files.getFileExtension(fileStr), "");
        } else {
          fileName = (fileStr.toString())
              .replaceAll(Files.getFileExtension(fileStr), "");
        }
      }
    }
    return fileName;
  }

  static String getFileExtension(String? fileStr, {bool withDot = true}) {
    String extension = "";
    if (withDot) {
      if (!Files._isNullOREmpty(fileStr)) {
        if (fileStr.toString().contains(".")) {
          extension =
              fileStr.toString().substring(fileStr.toString().lastIndexOf("."));
        } else {
          extension = ".${fileStr.toString()}";
        }
      }
    } else {
      if (!Files._isNullOREmpty(fileStr)) {
        if (fileStr.toString().contains(".")) {
          extension = (fileStr
                  .toString()
                  .substring(fileStr.toString().lastIndexOf(".")))
              .replaceAll(".", "");
        } else {
          extension = fileStr.toString();
        }
      }
    }
    return extension;
  }

  static String getMimeType(String? fileStr) {
    String? mimeType = lookupMimeType(fileStr!);
    if (Files._isNullOREmpty(mimeType)) {
      mimeType = "";
    }
    return mimeType.toString();
  }

  static deleteFile(
      {required FileData fileData,
      required Function(FileData fileData) onDeleted}) async {
    fileData.hasFile = false;
    fileData.fileName = "";
    fileData.filePath = "";
    fileData.fileMimeType = "";
    fileData.path = "";
    onDeleted(fileData);
  }

  static double kb(int size) {
    return size / 1024;
  }

  static double mb(int size) {
    return Files.kb(size) / 1024;
  }

  static viewFile({required BuildContext context}) {
    openFile(context, Files.fileData.path);
  }

  static filePickerOptions(
      {required BuildContext context,
      required FileData fileData,
      required FileMode fileMode,
      bool crop = false,
      required Function(FileData fileData) onSelected}) async {
    fileMode == FileMode.camera
        ? await Files.cameraPicker(
            fileData: fileData,
            crop: crop,
            onSelected: (fileData) {
              onSelected(fileData);
            })
        : fileMode == FileMode.gallery
            ? await Files.imagePicker(
                fileData: fileData,
                crop: crop,
                onSelected: (fileData) {
                  onSelected(fileData);
                })
            : await Files.filePicker(
                fileData: fileData,
                onSelected: (fileData) {
                  onSelected(fileData);
                });
  }

  static cameraPicker(
      {required FileData fileData,
      bool crop = false,
      int maxFileSizeInMb = 10,
      required Function(FileData fileData) onSelected}) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      String filePath = "";
      if (crop) {
        CroppedFile? croppedImage = await Files.imageCrop(image.path);
        if (croppedImage != null) {
          filePath = croppedImage.path;
        }
      } else {
        filePath = image.path;
      }
      if (!Files._isNullOREmpty(filePath)) {
        if (Files.mb(File(filePath).readAsBytesSync().lengthInBytes) <=
            maxFileSizeInMb) {
          fileData.hasFile = true;
          fileData.fileName = Files.getFileName(filePath);
          fileData.filePath = filePath;
          fileData.fileMimeType = Files.getMimeType(filePath);
          fileData.path = filePath;

          onSelected(fileData);
        } else {
          dev.log(Files._fileMoreThanMB(maxFileSizeInMb));
        }
      }
    }
  }

  static imagePicker(
      {required FileData fileData,
      bool crop = false,
      int maxFileSizeInMb = 10,
      required Function(FileData fileData) onSelected}) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      String filePath = "";
      if (crop) {
        CroppedFile? croppedImage = await Files.imageCrop(image.path);
        if (croppedImage != null) {
          filePath = croppedImage.path;
        }
      } else {
        filePath = image.path;
      }
      if (!Files._isNullOREmpty(filePath)) {
        if (Files.mb(File(filePath).readAsBytesSync().lengthInBytes) <=
            maxFileSizeInMb) {
          fileData.hasFile = true;
          fileData.fileName = Files.getFileName(filePath);
          fileData.filePath = filePath;
          fileData.fileMimeType = Files.getMimeType(filePath);
          fileData.path = filePath;

          onSelected(fileData);
        } else {
          dev.log(Files._fileMoreThanMB(maxFileSizeInMb));
        }
      }
    }
  }

  static filePicker(
      {required FileData fileData,
      int maxFileSizeInMb = 10,
      List<String> allowedExtensions = const [
        Files.pdf,
        Files.doc,
        Files.docx,
        Files.xls,
        Files.xlsx,
        Files.ppt,
        Files.pptx,
        Files.png,
        Files.jpg,
        Files.jpeg
      ],
      required Function(FileData fileData) onSelected}) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: allowedExtensions);
    if (result != null && result.files.single.path != null) {
      if (Files.mb(result.files.single.size) <= maxFileSizeInMb) {
        fileData.hasFile = true;
        fileData.fileName = result.files.single.name;
        fileData.filePath = result.files.single.path!;
        fileData.fileMimeType = Files.getMimeType(result.files.single.path!);
        fileData.path = result.files.single.path!;

        onSelected(fileData);
      } else {
        dev.log(Files._fileMoreThanMB(maxFileSizeInMb));
      }
    }
  }

  static Future<CroppedFile?> imageCrop(String imagePath) async {
    return await ImageCropper()
        .cropImage(sourcePath: imagePath, aspectRatioPresets: [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(title: 'Crop')
    ]);
  }
}
