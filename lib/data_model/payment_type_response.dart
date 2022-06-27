// To parse this JSON data, do
//
//     final paymentTypeResponse = paymentTypeResponseFromJson(jsonString);

import 'dart:convert';

List<PaymentTypeResponse> paymentTypeResponseFromJson(String str) => List<PaymentTypeResponse>.from(json.decode(str).map((x) => PaymentTypeResponse.fromJson(x)));

String paymentTypeResponseToJson(List<PaymentTypeResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentTypeResponse {
  PaymentTypeResponse({
    this.payment_type,
    this.payment_type_key,
    this.image,
    this.name,
    this.title,
    this.description,
    this.bank_info
  });

  String payment_type;
  String payment_type_key;
  String image;
  String name;
  String title;
  String description;
  List<BankInfo> bank_info=[];

  factory PaymentTypeResponse.fromJson(Map<String, dynamic> json) => PaymentTypeResponse(
    payment_type: json["payment_type"],
    payment_type_key: json["payment_type_key"],
    image: json["image"],
    name: json["name"],
    title: json["title"],
    description: json["description"],
    bank_info: List<BankInfo>.from(json["bank_info"].map((x) => BankInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "payment_type": payment_type,
    "payment_type_key": payment_type_key,
    "image": image,
    "name": name,
    "title": title,
    "description": description,
    "bank_info": List<dynamic>.from(bank_info.map((x) => x.toJson()))
  };

}

class BankInfo {
  BankInfo({
    this.bank_name_trans,
    this.bank_name,
    this.account_name_trans,
    this.account_name,
    this.account_number_trans,
    this.account_number,
    this.routing_number_trans,
    this.routing_number,
  });
  String bank_name_trans;
  String bank_name;
  String account_name_trans;
  String account_name;
  String account_number_trans;
  String account_number;
  String routing_number_trans;
  String routing_number;
  factory BankInfo.fromJson(Map<String, dynamic> json) => BankInfo(
    bank_name_trans: json["bank_name_trans"],
    bank_name: json["bank_name"],
    account_name_trans: json["account_name_trans"],
    account_name: json["account_name"],
    account_number_trans: json["account_number_trans"],
    account_number: json["account_number"],
    routing_number_trans: json["routing_number_trans"],
    routing_number: json["routing_number"],
  );
  Map<String, dynamic> toJson() => {
    "bank_name_trans": bank_name_trans,
    "bank_name": bank_name,
    "account_name_trans": account_name_trans,
    "account_name": account_name,
    "account_number_trans": account_number_trans,
    "account_number": account_number,
    "routing_number_trans": routing_number_trans,
    "routing_number": routing_number,
  };
}