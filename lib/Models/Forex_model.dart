// To parse this JSON data, do
//
//     final forexModel = forexModelFromJson(jsonString);

import 'dart:convert';

ForexModel forexModelFromJson(String str) => ForexModel.fromJson(json.decode(str));

String forexModelToJson(ForexModel data) => json.encode(data.toJson());

class ForexModel {
  ForexModel({
    this.statusCode,
    this.data,
  });

  int statusCode;
  List<Datum> data;

  factory ForexModel.fromJson(Map<String, dynamic> json) => ForexModel(
    statusCode: json["status_code"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
