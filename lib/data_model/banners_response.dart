// To parse this JSON data, do
//
//     final categoryResponse = categoryResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

BannersResponse bannersResponseFromJson(String str) => BannersResponse.fromJson(json.decode(str));

String bannersResponseToJson(BannersResponse data) => json.encode(data.toJson());

class BannersResponse {
  BannersResponse({
    this.banners,
    this.success,
    this.status,
  });

  List<Banners> banners;
  bool success;
  int status;

  factory BannersResponse.fromJson(Map<String, dynamic> json) => BannersResponse(
    banners: List<Banners>.from(json["data"].map((x) => Banners.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(banners.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Banners {
  Banners({
    this.photo,
    this.url,
    this.position,
  });

  String photo;
  String url;
  int position;

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
    photo: json["photo"],
    url: json["url"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "photo": photo,
    "url": url,
    "position": position,
  };
}
