import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/adRequestCard.dart';
import 'package:mysalon/services/getData/getAdsRequestAndData.dart';

class AdsRequest extends StatefulWidget {
  const AdsRequest({super.key});

  @override
  State<AdsRequest> createState() => _AdsRequestState();
}

class _AdsRequestState extends State<AdsRequest> {
  List<dynamic>? AllAdsRequestApproved = [];
  List<dynamic>? AllAdsRequestPending = [];

  @override
  void initState() {
    super.initState();

    load();
  }

  load() async {
    AllAdsRequestApproved = await GetAllAdsRequest();
    AllAdsRequestPending = await GetAllAdsRequest(isPending: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopBarLabel(label: "Ads Request"),
            lightLabel(label: "Running Ads"),
            AllAdsRequestApproved!.isEmpty
                ? Text("No data found")
                : Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: 200,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: AllAdsRequestApproved!.length,
                        itemBuilder: (context, index) {
                          return AdRequestCard(
                            adRequestData: AllAdsRequestApproved![index],
                            load: load,
                          );
                        }),
                  ),
            SizedBox(
              height: 20,
            ),
            lightLabel(label: "New Request"),
            AllAdsRequestPending!.isEmpty
                ? Text("No Data Found")
                : Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: (200 * AllAdsRequestPending!.length).toDouble(),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: AllAdsRequestPending!.length,
                        itemBuilder: (context, index) {
                          return AdRequestCard(
                            adRequestData: AllAdsRequestPending![index],
                            load: load,
                          );
                        }),
                  ),
          ],
        ),
      ),
    ));
  }
}
