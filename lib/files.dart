import 'dart:developer' as dev;
import 'dart:convert';
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

  static setFileDataFromUpdate({required String? fileUrl}) {
    if (!Files._isNullOREmpty(fileUrl)) {
      Files.fileData.hasFile = true;
      Files.fileData.fileName = Files.getFileName(fileUrl);
      Files.fileData.path = fileUrl!;
      Files.setFileData(isActionUpdate: true);
    }
  }

  static setFileData({bool isActionUpdate = false}) {
    if (Files.fileData.hasFile) {
      Files.setDeletedFiles();
      Files.fileDataList.clear();
      if (!isActionUpdate) {
        Files.fileDataList.add(FileData(
            fileName: Files.fileData.fileName,
            filePath: Files.fileData.filePath,
            fileMimeType: Files.fileData.fileMimeType,
            path: Files.fileData.path));
      } else {
        Files.fileDataList.add(FileData(
            fileName: Files.fileData.fileName, path: Files.fileData.path));
      }
    } else {
      Files.clearFileData();
    }
  }

  static Future<FileData> clearFileData(
      {bool deletedFileListClear = false}) async {
    Files.setDeletedFiles(deletedFileListClear: deletedFileListClear);
    Files.fileData.hasFile = false;
    Files.fileData.fileName = "";
    Files.fileData.filePath = "";
    Files.fileData.fileMimeType = "";
    Files.fileData.path = "";
    Files.fileDataList.clear();
    return Files.fileData;
  }

  static setDeletedFiles(
      {List<FileData>? fileDataList, bool deletedFileListClear = false}) {
    for (var obj in Files.fileDataList) {
      if (!Files._isNullOREmpty(obj.fileName)) {
        if (!Files._isNullOREmpty(obj.path) && Files.webFilePath(obj.path)) {
          Files.deletedFileList.add(obj.fileName);
        }
      }
    }
    if (deletedFileListClear) {
      Files.deletedFileList.clear();
    }
  }

  static String getDeletedFiles() {
    return jsonEncode(Files.deletedFileList);
  }

  static List<FileData> getFileDataList() {
    return Files.fileDataList;
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

  static deleteFile({required BuildContext context}) async {
    await Files.clearFileData();
  }

  static fileSelectionWithFileData(
      {required BuildContext context, required FileMode fileMode}) async {
    fileMode == FileMode.camera
        ? await Files.cameraPicker(fileData: fileData)
        : fileMode == FileMode.gallery
            ? await Files.imagePicker()
            : await Files.filePicker();
  }

  static Future<FileData> cameraPicker({required FileData fileData, int maxFileSizeInMb = 10}) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      CroppedFile? croppedImage = await Files.imageCrop(image.path);
      if (croppedImage != null && !Files._isNullOREmpty(croppedImage.path)) {
        if (Files.mb(File(croppedImage.path).readAsBytesSync().lengthInBytes) <=
            maxFileSizeInMb) {
          fileData.hasFile = true;
          fileData.fileName = Files.getFileName(croppedImage.path);
          fileData.filePath = croppedImage.path;
          fileData.fileMimeType = Files.getMimeType(croppedImage.path);
          fileData.path = croppedImage.path;

          Files.setFileData();
        } else {
          dev.log(Files._fileMoreThanMB(maxFileSizeInMb));
        }
      }
    }
    return Files.fileData;
  }

  static Future<FileData> imagePicker({int maxFileSizeInMb = 10}) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedImage = await Files.imageCrop(image.path);
      if (croppedImage != null && !Files._isNullOREmpty(croppedImage.path)) {
        if (Files.mb(File(croppedImage.path).readAsBytesSync().lengthInBytes) <=
            maxFileSizeInMb) {
          Files.fileData.hasFile = true;
          Files.fileData.fileName = Files.getFileName(croppedImage.path);
          Files.fileData.filePath = croppedImage.path;
          Files.fileData.fileMimeType = Files.getMimeType(croppedImage.path);
          Files.fileData.path = croppedImage.path;

          Files.setFileData();
        } else {
          dev.log(Files._fileMoreThanMB(maxFileSizeInMb));
        }
      }
    }
    return Files.fileData;
  }

  static Future<FileData> filePicker({int maxFileSizeInMb = 10}) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
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
    ]);
    if (result != null && result.files.single.path != null) {
      if (Files.mb(result.files.single.size) <= maxFileSizeInMb) {
        Files.fileData.hasFile = true;
        Files.fileData.fileName = result.files.single.name;
        Files.fileData.filePath = result.files.single.path!;
        Files.fileData.fileMimeType =
            Files.getMimeType(result.files.single.path!);
        Files.fileData.path = result.files.single.path!;

        Files.setFileData();
      } else {
        dev.log(Files._fileMoreThanMB(maxFileSizeInMb));
      }
    }
    return Files.fileData;
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
