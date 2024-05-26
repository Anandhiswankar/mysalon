import 'dart:convert';
import 'package:http/http.dart' as http;

class FCMService {
  final String serverKey =
      'AAAAnlE3zz8:APA91bGAiRZw_bOn_rA42JjTptOL4mC1tadV9pPcvxL_l1hyBeSJ_8OAFjH4lcINUZE8O9Xo9cwpdRDRi4cCbHXE4T9WOdRy_MF96IFgYc5BOjYhuy5WVGWMASq7ugnD2MUMV4g_Zo05';

  Future<void> sendNotification({
    required String title,
    required String body,
    required String fcmToken,
  }) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final payload = {
      'to': fcmToken,
      'notification': {
        'title': title,
        'body': body,
      },
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
