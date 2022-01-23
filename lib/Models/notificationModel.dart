class Notifications {
  String title;
  String body;

  Notifications(String t, String b) {
    title = t;
    body = b;
  }

 static Notifications fromMap(Map<String, dynamic> map) {
    return Notifications(
      map['title'],
      map['body'],
    );
  }
}
