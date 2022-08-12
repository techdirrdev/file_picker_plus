import 'package:file_picker_plus/file_data.dart';
import 'package:file_picker_plus/files.dart';
import 'package:flutter/material.dart';

/// pre-define file picker widget
class FilePicker extends StatefulWidget {
  final BuildContext context;
  final FileData fileData;
  final Function(FileData fileData) onSelected;
  final Function(String message)? onCancel;
  final Function(FileData fileData)? onDeleted;
  final Function(FileData fileData)? onView;
  final bool camera;
  final bool gallery;
  final bool document;
  final bool view;
  final bool delete;
  final bool crop;
  final int? maxFileSizeInMb;
  final bool cropOnlySquare;
  final String cropperToolbarTitle;
  final Color cropperToolbarColor;
  final Color cropperToolbarWidgetsColor;
  final List<String> allowedExtensions;
  final double? width;
  final double? height;
  final Widget? child;

  const FilePicker(
      {Key? key,
      required this.context,
      required this.fileData,
      required this.onSelected,
      this.onCancel,
      this.onDeleted,
      this.onView,
      this.camera = true,
      this.gallery = true,
      this.document = true,
      this.view = true,
      this.delete = true,
      this.crop = true,
      this.maxFileSizeInMb,
      this.cropOnlySquare = false,
      this.cropperToolbarTitle = Files.cropperToolbarTitle,
      this.cropperToolbarColor = Files.cropperToolbarColor,
      this.cropperToolbarWidgetsColor = Files.cropperToolbarWidgetsColor,
      this.allowedExtensions = Files.allowedAllExtensions,
      this.width,
      this.height,
      this.child})
      : super(key: key);

  @override
  State<FilePicker> createState() => _FilePickerState();
}

class _FilePickerState extends State<FilePicker> {
  final String _imgAttachment = "assets/images/img_attachment.png";
  final String _imgAttachmentAttached =
      "assets/images/img_attachment_attached.png";
  final String _imgFileSelectionCamera =
      "assets/images/img_selection_camera.png";
  final String _imgFileSelectionGallery =
      "assets/images/img_selection_gallery.png";
  final String _imgFileSelectionDocument =
      "assets/images/img_selection_document.png";
  final String _imgFileSelectionDelete =
      "assets/images/img_selection_delete.png";
  final String _imgFileSelectionView = "assets/images/img_selection_view.png";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: (widget.view && widget.fileData.hasFile),
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.onView != null) {
                                    widget.onView!(widget.fileData);
                                  } else {
                                    Files.viewFile(fileData: widget.fileData);
                                  }
                                },
                                child: Column(
                                  children: [
                                    _assetImage(_imgFileSelectionView,
                                        width: 40, height: 40),
                                    const SizedBox(height: 10),
                                    const Text("View")
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Visibility(
                              visible: widget.camera,
                              child: GestureDetector(
                                onTap: () async {
                                  await Files.filePickerOptions(
                                      context: context,
                                      fileData: widget.fileData,
                                      fileMode: FileMode.camera,
                                      crop: widget.crop,
                                      maxFileSizeInMB: widget.maxFileSizeInMb,
                                      cropOnlySquare: widget.cropOnlySquare,
                                      cropperToolbarTitle:
                                          widget.cropperToolbarTitle,
                                      cropperToolbarColor:
                                          widget.cropperToolbarColor,
                                      cropperToolbarWidgetsColor:
                                          widget.cropperToolbarWidgetsColor,
                                      onSelected: (fileData) {
                                        widget.onSelected(fileData);
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      onCancel: (message) {
                                        if (widget.onCancel != null) {
                                          widget.onCancel!(message);
                                        }
                                      });
                                },
                                child: Column(
                                  children: [
                                    _assetImage(_imgFileSelectionCamera,
                                        width: 40, height: 40),
                                    const SizedBox(height: 10),
                                    const Text("Camera")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible:
                                  (widget.delete && widget.fileData.hasFile),
                              child: GestureDetector(
                                onTap: () async {
                                  await Files.deleteFile(
                                      fileData: widget.fileData,
                                      onDeleted: (fileData) {
                                        widget.onSelected(fileData);
                                        if (widget.onDeleted != null) {
                                          widget.onDeleted!(fileData);
                                        }
                                        Navigator.pop(context);
                                        setState(() {});
                                      });
                                },
                                child: Column(
                                  children: [
                                    _assetImage(_imgFileSelectionDelete,
                                        width: 40, height: 40),
                                    const SizedBox(height: 10),
                                    const Text("Delete")
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Visibility(
                              visible: widget.gallery,
                              child: GestureDetector(
                                onTap: () async {
                                  await Files.filePickerOptions(
                                      context: context,
                                      fileData: widget.fileData,
                                      fileMode: FileMode.gallery,
                                      crop: widget.crop,
                                      maxFileSizeInMB: widget.maxFileSizeInMb,
                                      cropOnlySquare: widget.cropOnlySquare,
                                      cropperToolbarTitle:
                                          widget.cropperToolbarTitle,
                                      cropperToolbarColor:
                                          widget.cropperToolbarColor,
                                      cropperToolbarWidgetsColor:
                                          widget.cropperToolbarWidgetsColor,
                                      onSelected: (fileData) {
                                        widget.onSelected(fileData);
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      onCancel: (message) {
                                        if (widget.onCancel != null) {
                                          widget.onCancel!(message);
                                        }
                                      });
                                },
                                child: Column(
                                  children: [
                                    _assetImage(_imgFileSelectionGallery,
                                        width: 40, height: 40),
                                    const SizedBox(height: 10),
                                    const Text("Gallery")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(height: 30),
                            Visibility(
                              visible: widget.document,
                              child: GestureDetector(
                                onTap: () async {
                                  await Files.filePickerOptions(
                                      context: context,
                                      fileData: widget.fileData,
                                      fileMode: FileMode.file,
                                      maxFileSizeInMB: widget.maxFileSizeInMb,
                                      allowedExtensions:
                                          widget.allowedExtensions,
                                      onSelected: (fileData) {
                                        widget.onSelected(fileData);
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      onCancel: (message) {
                                        if (widget.onCancel != null) {
                                          widget.onCancel!(message);
                                        }
                                      });
                                },
                                child: Column(
                                  children: [
                                    _assetImage(_imgFileSelectionDocument,
                                        width: 40, height: 40),
                                    const SizedBox(height: 10),
                                    const Text("File")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "* File must be less than ${widget.maxFileSizeInMb} MB",
                      style: const TextStyle(fontSize: 10, color: Colors.red),
                    )
                  ],
                ),
              );
            });
      },
      child: widget.child ??
          Container(
            width: widget.width,
            height: widget.height,
            padding: const EdgeInsets.all(10),
            color: Colors.grey,
            child: Center(
                child: _assetImage(widget.fileData.hasFile
                    ? _imgAttachmentAttached
                    : _imgAttachment)),
          ),
    );
  }
}

_assetImage(String path, {double? width, double? height}) {
  return Image.asset(
    path,
    width: width,
    height: height,
    package: 'file_picker_plus',
  );
}
