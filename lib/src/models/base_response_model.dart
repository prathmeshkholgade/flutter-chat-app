class BaseResponseModel<T> {
  final int? status;
  final bool? success;
  final String? message;
  final T? data;

  BaseResponseModel({this.status, this.success, this.message, this.data});

  factory BaseResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return BaseResponseModel<T>(
      status: json["status"],
      success: json["success"],
      message: json["message"],
      data: fromJsonT != null ? fromJsonT(json["data"]) : json["data"],
    );
  }
}
