import 'package:flutter/material.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:mysalon/elements/notificationCard.dart';
import 'package:mysalon/services/getData/getNotification.dart';

class NotificationSalonOwner extends StatefulWidget {
  const NotificationSalonOwner({super.key});

  @override
  State<NotificationSalonOwner> createState() => _NotificationSalonOwnerState();
}

class _NotificationSalonOwnerState extends State<NotificationSalonOwner> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    load();
  }

  dynamic notificationData = [];

  load() async {
    notificationData = await GetNotification();

    print(notificationData);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopBarLabel(label: "Notification"),
              notificationData == null
                  ? const Text("No Data Found")
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.90,
                      child: ListView.builder(
                          itemCount: notificationData.length,
                          itemBuilder: (context, index) {
                            return NotificationCard(
                              notificationData: notificationData[index],
                            );
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
