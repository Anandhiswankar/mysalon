import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';
import 'package:mysalon/Screens/salonRegister/registerSalonD.dart';

class registerSalonC extends StatefulWidget {
  bool isUpdate;
  final Map<String, dynamic> salonData;
  registerSalonC({super.key, required this.salonData, this.isUpdate = false});

  @override
  State<registerSalonC> createState() => _registerSalonCState();
}

class _registerSalonCState extends State<registerSalonC> {
  int selected = 0;

  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  List<dynamic> dayOfWeekSelected = [];

  List<String> solonOffers = [
    'Haircut',
    'Hairstyling',
    'Hair Coloring',
    'Manicure',
    'Pedicure',
    'Facial',
    'Waxing',
    'Massage',
    'Makeup',
    'Spa Treatments',
    'Nail Extensions',
    'Bridal Packages',
    'Men\'s Grooming',
    'Eyebrow Shaping',
    'Lash Extensions',
    'Body Scrubs',
    'Threading',
    'Hair Extensions',
    'Hot Oil Treatment',
    'Perms',
    'Blowouts',
    'Permanent Makeup',
    'Shellac Nails',
    'Microblading',
    'Chemical Peels',
    'Teeth Whitening',
    'Tanning',
    'Balayage',
    'Ombre Coloring',
    'Hair Straightening',
    'Foot Massage',
    'Body Wraps',
    'Acrylic Nails',
    'French Manicure',
    'Gel Manicure',
    'Aromatherapy',
    'Anti-Aging Treatments',
    'HydraFacial',
    'Balayage',
    'Ombre Coloring',
    'Hair Extensions',
    'Hot Oil Treatment',
    'Perms',
    'Blowouts',
    'Permanent Makeup',
    'Shellac Nails',
    'Microblading',
    'Chemical Peels',
    'Teeth Whitening',
    'Tanning',
    'Balayage',
    'Ombre Coloring',
    'Hair Straightening',
    'Foot Massage',
    'Body Wraps',
    'Acrylic Nails',
    'French Manicure',
    'Gel Manicure',
    'Aromatherapy',
    'Anti-Aging Treatments',
    'HydraFacial',
  ];
  List<dynamic> solonOffersSelected = [];

  List<String> salonTypes = [
    'Hair Salon',
    'Nail Salon',
    'Beauty Salon',
    'Spa Salon',
    'Barber Shop',
    'Tanning Salon',
    'Day Spa',
    'Med Spa',
    'Waxing Salon',
    'Massage Salon',
    'Skin Care Clinic',
    'Bridal Salon',
    'Men\'s Grooming Salon',
    'Nail Bar',
    'Wellness Spa',
    'Eyebrow Studio',
    'Lash Studio',
    'Beauty Lounge',
    'Makeup Studio',
    'Fitness and Beauty Center',
    'Organic Salon',
    'Blow Dry Bar',
    'Hair Extensions Salon',
    'Children\'s Salon',
    'Aromatherapy Spa',
    'Holistic Wellness Center',
    'Boutique Salon',
    'Color Bar',
    'Vintage Barber Shop',
    'Luxury Spa Retreat',
    'Ayurvedic Wellness Center',
    'Trendy Hair Studio',
    'Urban Day Spa',
    'Mobile Salon Services',
    'Nail Art Studio',
    'Men\'s Grooming Lounge',
    'Glamour Beauty Bar',
    'Foot Spa',
    'Organic Nail Studio',
    'Ethnic Hair Salon',
    'Wellness and Beauty Spa',
    'Oxygen Bar and Spa',
    'Teen Spa',
    'Express Beauty Salon',
    'Sustainable Beauty Studio',
    'Floatation Therapy Center',
    'Keratin Treatment Salon',
    'Salt Room Therapy Spa',
    'Bamboo Massage Studio',
    'Celebrity Hairstyling Studio',
  ];

  List<dynamic> salonTypeSelected = [];

  getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      return image.name;
    } else {
      return null;
    }
  }

  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isUpdate) {
      updateData();
    } else {
      loading = false;
    }
  }

  updateData() async {
    var salonService = await getSalonServices(context);

    if (salonService != null) {
      salonTypeSelected = salonService["salonType"];
      solonOffersSelected = salonService["salonOffer"];
      dayOfWeekSelected = salonService["salonWorking"];
    }

    loading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: loading
            ? screenLoader()
            : Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Create Account",
                      style: GoogleFonts.inter(
                          color: primeColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  lightLabel(label: "Salon Type"),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.96,
                    height: salonTypes.length * 33,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: salonTypes.map((day) {
                        return InkWell(
                          onTap: () {
                            if (salonTypeSelected.contains(day)) {
                              salonTypeSelected.remove(day);
                            } else {
                              salonTypeSelected.add(day);
                            }

                            setState(() {});
                          },
                          child: Chip(
                            label: Text(day),
                            avatar: Icon(
                              salonTypeSelected.contains(day)
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              color: Colors.white,
                            ),
                            elevation: 2.0,
                            backgroundColor: primeColor,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  lightLabel(label: "Service Offered"),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: solonOffers.map((day) {
                        return InkWell(
                          onTap: () {
                            if (solonOffersSelected.contains(day)) {
                              solonOffersSelected.remove(day);
                            } else {
                              solonOffersSelected.add(day);
                            }

                            setState(() {});
                          },
                          child: Chip(
                            label: Text(day),
                            avatar: Icon(
                              solonOffersSelected.contains(day)
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              color: Colors.white,
                            ),
                            elevation: 2.0,
                            backgroundColor: primeColor,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  lightLabel(label: "Working Day"),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.96,
                    height: daysOfWeek.length * 20,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: daysOfWeek.map((day) {
                        return InkWell(
                          onTap: () {
                            if (dayOfWeekSelected.contains(day)) {
                              dayOfWeekSelected.remove(day);
                            } else {
                              dayOfWeekSelected.add(day);
                            }

                            setState(() {});
                          },
                          child: Chip(
                            label: Text(day),
                            avatar: Icon(
                              dayOfWeekSelected.contains(day)
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              color: Colors.white,
                            ),
                            elevation: 2.0,
                            backgroundColor: primeColor,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Text("Select min 3 from each options"),
                  Container(
                    child: InkWell(
                      onTap: () {
                        if (dayOfWeekSelected.length >= 3 &&
                            salonTypeSelected.length >= 3 &&
                            solonOffersSelected.length >= 3) {
                          var data = {
                            "salonType": salonTypeSelected,
                            "salonOffer": solonOffersSelected,
                            "wokringDays": dayOfWeekSelected
                          };

                          widget.salonData.addAll(data);

                          nextScreen(
                              context,
                              registerSalonD(
                                isUpdate: widget.isUpdate,
                                salonData: widget.salonData,
                              ));
                        } else {
                          Fluttertoast.showToast(
                              msg: "Select min 3 choice from option");
                        }
                      },
                      child: fullviewbtn(
                        inverse: true,
                        isDisabled: dayOfWeekSelected.length >= 3 &&
                                salonTypeSelected.length >= 3 &&
                                solonOffersSelected.length >= 3
                            ? false
                            : true,
                        text: "Next",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                ],
              ),
      ),
    ));
  }
}
