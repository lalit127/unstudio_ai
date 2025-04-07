class CommonApiModel {
  CommonApiModel({this.status, this.message, this.data});

  CommonApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as int;
    message = json['message']?.toString();
    data = json['data'];
  }
  int? status;
  String? message;
  dynamic data;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data;
    }
    return data;
  }
}
