import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/Screens/user/bookAppointmentB.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/getData/getBookedSlots.dart';
import 'package:mysalon/services/getData/getBookingCost.dart';
import 'package:mysalon/services/getData/getCanceledSlots.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';

class BookAppointmentA extends StatefulWidget {
  final dynamic data;
  const BookAppointmentA({super.key, this.data});

  @override
  State<BookAppointmentA> createState() => _BookAppointmentAState();
}

class _BookAppointmentAState extends State<BookAppointmentA> {
  CalendarFormat _calendarFormat = CalendarFormat.week;

  var _morningSlot = [];
  var afternoonSlot = [];
  var eveningSlot = [];

  var cancelList = [];

  var bookedList = [];

  int bookingCost = 0;

  var selectedDate = DateTime.now();

  List<QueryDocumentSnapshot<dynamic>>? bookedSlots = null;

  @override
  void initState() {
    super.initState();
    loadValues();
  }

  DateFormat dateFormat = DateFormat("dd-MM-yyyy hh:mm a");

  setCalender() async {
    DateTime now = DateTime.now();

    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now) + 'Z';

    DateTime parsedDateTime = DateTime.parse(formattedDateTime);

    selectedDate = parsedDateTime;

    print(selectedDate);

    if (mounted) {
      var data =
          await getCanceledSlotsById(context, selectedDate, widget.data["id"]);

      print(data);

      if (data != null) {
        cancelList = data["canceledSlot"];

        setState(() {});
      }
    }

    checkBookedSlotSTatus();
  }

  updateBookingSlot(DateTime date) async {
    var data =
        await getCanceledSlotsById(context, selectedDate, widget.data["id"]);

    print(data);

    if (data != null) {
      cancelList = data["canceledSlot"];
      setState(() {});
    }

    _morningSlot = generateHoursList();
    afternoonSlot = generateHoursListNoon();
    eveningSlot = generateHoursListEve();

    setState(() {});
  }

  List<String> generateHoursList() {
    print("Checking");
    int currentHour = DateTime.now().hour;

    print(selectedDate);

    List<String> hoursList = [];
    for (int i = 8; i <= 12; i++) {
      if (i > currentHour ||
          DateTime.parse(selectedDate.toString().split(" ").first)
              .isAfter(DateTime.now())) {
        hoursList.add('${i.toString().padLeft(2, '0')}:00 AM');
      }
    }
    return hoursList;
  }

  List<String> generateHoursListNoon() {
    int currentHour = DateTime.now().hour % 12;
    currentHour = currentHour == 0 ? 12 : currentHour;

    List<String> hoursList = [];
    for (int i = 1; i <= 6; i++) {
      if (i > currentHour ||
          DateTime.parse(selectedDate.toString().split(" ").first)
              .isAfter(DateTime.now())) {
        hoursList.add('${i.toString().padLeft(2, '0')}:00 PM');
      }
    }
    return hoursList;
  }

  List<String> generateHoursListEve() {
    int currentHour = DateTime.now().hour % 12;
    currentHour = currentHour == 0 ? 12 : currentHour;

    List<String> hoursList = [];
    for (int i = 7; i <= 10; i++) {
      if (i > currentHour ||
          DateTime.parse(selectedDate.toString().split(" ").first)
              .isAfter(DateTime.now())) {
        hoursList.add('${i.toString().padLeft(2, '0')}:00 PM');
      }
    }
    return hoursList;
  }

  loadValues() async {
    _morningSlot = generateHoursList();
    afternoonSlot = generateHoursListNoon();
    eveningSlot = generateHoursListEve();

    var data = await getBookingCost();

    bookingCost = data["cost"];

    setState(() {});

    setCalender();
  }

  checkBookedSlotSTatus() async {
    bookedSlots = await getSalonBookedSlots(widget.data['id']);

    var salonData = await getSalonInfobyId(context, widget.data["id"]);

    DateTime dateTime = DateTime.now();

    // Format the DateTime according to the desired format

    // Format the DateTime according to the desired format

    print("Chairs: " + salonData!["chairs"].toString());

    for (int i = 0; i < bookedSlots!.length; i++) {
      var element = bookedSlots![i].data();

      List<QueryDocumentSnapshot<dynamic>>? slotslist =
          await getSalonBookedSlotByTimeDate(
              widget.data['id'], element["bookedSlot"], selectedDate);

      if (slotslist!.length >= salonData["chairs"]) {
        cancelList.add(element["bookedSlot"]);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          TopBarLabel(label: "Book Appointment"),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(0, 2))
            ], color: primeColor, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(10),
            child: TableCalendar(
              availableGestures: AvailableGestures.horizontalSwipe,
              pageJumpingEnabled: false,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              currentDay: selectedDate,
              calendarFormat: _calendarFormat,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white),
                weekendStyle: TextStyle(color: Colors.white),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(color: Colors.white),
                holidayTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.white),
                selectedTextStyle: TextStyle(color: Colors.black),
                withinRangeTextStyle: TextStyle(color: Colors.white),
                disabledTextStyle: TextStyle(color: Colors.white),
                rangeEndTextStyle: TextStyle(color: Colors.white),
                rangeStartTextStyle: TextStyle(color: Colors.white),
                outsideTextStyle: TextStyle(color: Colors.white),
                weekNumberTextStyle: TextStyle(color: Colors.white),
                selectedDecoration:
                    BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                todayTextStyle: TextStyle(color: Colors.white),
                markerDecoration: BoxDecoration(color: Colors.black),
                todayDecoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(148, 4, 4, 4),
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: Offset(0, 2),
                  )
                ], color: Colors.black, shape: BoxShape.circle),
              ),
              onDaySelected: (a, b) {
                print(a);
                print(b);
                selectedDate = a;
                setState(() {});
                updateBookingSlot(selectedDate);
              },
              headerStyle: HeaderStyle(
                  headerMargin: EdgeInsets.only(bottom: 10, top: 10),
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          lightLabel(label: "Morning"),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: EdgeInsets.all(10),
            child: _morningSlot.isNotEmpty
                ? ListView.builder(
                    itemCount: _morningSlot.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (cancelList.contains(_morningSlot[index])) {
                            return;
                          }
                          bookedList.clear();
                          bookedList.add(_morningSlot[index]);
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.all(2),
                          child: Chip(
                              backgroundColor:
                                  cancelList.contains(_morningSlot[index])
                                      ? Colors.grey
                                      : bookedList.contains(_morningSlot[index])
                                          ? Colors.black
                                          : primeColor,
                              avatar: Icon(
                                Icons.timer,
                                color: Colors.white,
                              ),
                              label: Text(
                                _morningSlot[index],
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      );
                    })
                : SizedBox(),
          ),
          lightLabel(label: "Afternoon"),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: EdgeInsets.all(10),
            child: afternoonSlot.isNotEmpty
                ? ListView.builder(
                    itemCount: afternoonSlot.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (cancelList.contains(afternoonSlot[index])) {
                            return;
                          }
                          bookedList.clear();
                          bookedList.add(afternoonSlot[index]);
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.all(2),
                          child: Chip(
                              backgroundColor: cancelList
                                      .contains(afternoonSlot[index])
                                  ? Colors.grey
                                  : bookedList.contains(afternoonSlot[index])
                                      ? Colors.black
                                      : primeColor,
                              avatar: Icon(
                                Icons.timer,
                                color: Colors.white,
                              ),
                              label: Text(
                                afternoonSlot[index],
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      );
                    })
                : SizedBox(),
          ),
          lightLabel(label: "Evening"),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: EdgeInsets.all(10),
            child: eveningSlot.isNotEmpty
                ? ListView.builder(
                    itemCount: eveningSlot.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (cancelList.contains(eveningSlot[index])) {
                            return;
                          } else {
                            bookedList.clear();
                            bookedList.add(eveningSlot[index]);
                            setState(() {});
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(2),
                          child: Chip(
                              backgroundColor:
                                  cancelList.contains(eveningSlot[index])
                                      ? Colors.grey
                                      : bookedList.contains(eveningSlot[index])
                                          ? Colors.black
                                          : primeColor,
                              avatar: Icon(
                                Icons.timer,
                                color: Colors.white,
                              ),
                              label: Text(
                                eveningSlot[index],
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      );
                    })
                : SizedBox(),
          ),
          lightLabel(label: "Booked Slot"),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: EdgeInsets.all(10),
            child: bookedList.isNotEmpty
                ? ListView.builder(
                    itemCount: bookedList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (bookedList.contains(bookedList[index])) {
                            bookedList.remove(bookedList[index]);
                          }
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.all(2),
                          child: Chip(
                              backgroundColor: primeColor,
                              avatar: Icon(
                                Icons.timer,
                                color: Colors.white,
                              ),
                              label: Text(
                                bookedList[index],
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      );
                    })
                : SizedBox(),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              if (bookedList.isEmpty) {
                Fluttertoast.showToast(msg: "Add Booking Slot");
                return;
              }
              var data = {
                ...widget.data,
                "bookedSlot": bookedList[0],
                "bookingCost": bookingCost,
                "selectedDate": selectedDate.day.toString() +
                    "-" +
                    selectedDate.month.toString() +
                    "-" +
                    selectedDate.year.toString(),
              };

              nextScreen(
                  context,
                  BookAppointmentB(
                    data: data,
                  ));
            },
            child: fullviewbtn(
              text: "book Now in Just $bookingCost INR",
              inverse: true,
              isDisabled: selectedDate.isBefore(DateTime.now()) ? true : false,
              fontSize: 20,
            ),
          )
        ],
      ),
    ));
  }
}
