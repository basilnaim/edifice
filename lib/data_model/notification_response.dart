
import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) => NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) => json.encode(data.toJson());

class NotificationResponse {
  NotificationResponse({
    this.notification_item_list,
    this.success,
    this.status,
  });

  List<NotificationItem> notification_item_list;
  bool success;
  int status;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
    notification_item_list: List<NotificationItem>.from(json["data"].map((x) => NotificationItem.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(notification_item_list.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class NotificationItem {
  NotificationItem({
    this.id,
    this.type,
    this.read_at,
    this.title,
    this.body,
    this.icon,
    this.action_url,
    this.created,
    this.created_date,
    this.created_time,
  });

  int id;
  int type;
  String read_at;
  int title;
  String body;
  String icon;
  String action_url;
  int created;
  int created_date;
  DateTime created_time;

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: json["id"],
    type: json["type"],
    read_at: json["read_at"],
    title: json["title"],
    body: json["body"],
    icon: json["icon"],
    action_url: json["action_url"],
    created: json["created"],
    created_date: json["created_date"],
    created_time: (json["created_time"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "read_at": read_at,
    "title": title,
    "body": body,
    "icon": icon,
    "action_url": action_url,
    "created": created,
    "created_date": created_date,
    "created_time": created_time,
  };
}
