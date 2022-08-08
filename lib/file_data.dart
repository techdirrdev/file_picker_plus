class FileData {
  bool hasFile;
  String fileName;
  String filePath;
  String fileMimeType;
  String path;

  FileData(
      {this.hasFile = false,
      this.fileName = "",
      this.filePath = "",
      this.fileMimeType = "",
      this.path = ""});
}
