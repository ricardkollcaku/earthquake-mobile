class ErrorModel {
  int status;
  String title;
  String message;
  String path;
  String timeStamp;

  ErrorModel({this.status, this.title, this.message, this.path, this.timeStamp});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    title = json['title'];
    message = json['message'];
    path = json['path'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['title'] = this.title;
    data['message'] = this.message;
    data['path'] = this.path;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}