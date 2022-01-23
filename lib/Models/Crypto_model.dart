// To parse this JSON data, do
//
//     final cryptoModel = cryptoModelFromJson(jsonString);

import 'dart:convert';

CryptoModel cryptoModelFromJson(String str) => CryptoModel.fromJson(json.decode(str));

String cryptoModelToJson(CryptoModel data) => json.encode(data.toJson());

class CryptoModel {
  CryptoModel({
    this.statusCode,
    this.message,
  });

  int statusCode;
  List<Message> message;

  factory CryptoModel.fromJson(Map<String, dynamic> json) => CryptoModel(
    statusCode: json["status_code"],
    message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": List<dynamic>.from(message.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    this.id,
    this.symbol,
    this.type,
    this.tp,
    this.sl,
    this.lot,
    this.profit,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String symbol;
  String type;
  String tp;
  String sl;
  String lot;
  dynamic profit;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    symbol: json["symbol"],
    type: json["type"],
    tp: json["tp"],
    sl: json["sl"],
    lot: json["lot"],
    profit: json["profit"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "type": type,
    "tp": tp,
    "sl": sl,
    "lot": lot,
    "profit": profit,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
