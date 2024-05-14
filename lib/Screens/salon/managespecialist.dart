import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/specialist.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:mysalon/services/getData/manageSpecialist.dart';

class ManageSpecialist extends StatefulWidget {
  const ManageSpecialist({super.key});

  @override
  State<ManageSpecialist> createState() => _ManageSpecialistState();
}

class _ManageSpecialistState extends State<ManageSpecialist> {
  TextEditingController name = TextEditingController();
  TextEditingController info = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadData();
  }

  var specialist = [];

  Map<String, dynamic>? snapData = null;

  File? profileImage = null;

  loadData() async {
    snapData = await getSpecialist();

    specialist = snapData!["specialist"];

    setState(() {});

    print(specialist);
  }

  Future<XFile?> getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      profileImage = File(image.path);
      setState(() {});
      return image;
    } else {
      return null;
    }
  }

  editValues() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        showDragHandle: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, mystate) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Add Specialist",
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                  ),
                  Container(
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: profileImage != null
                                      ? FileImage(File(profileImage!.path))
                                          as ImageProvider
                                      : NetworkImage(
                                          "https://st4.depositphotos.com/3917667/21802/i/450/depositphotos_218020158-stock-photo-high-fashion-model-woman-in.jpg"),
                                  fit: BoxFit.cover)),
                          width: 140,
                          height: 140,
                          clipBehavior: Clip.hardEdge,
                        ),
                        Positioned(
                            right: 10,
                            bottom: 10,
                            child: InkWell(
                              onTap: () async {
                                await getImage();

                                mystate(() {});
                              },
                              child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomInputBox(
                    placeholder: "Enter Name",
                    icons: Icons.person,
                    controller: name,
                    text: "",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: 120,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(61, 0, 0, 0),
                              blurRadius: 2.2,
                              offset: Offset(0, 3),
                              spreadRadius: 0.2)
                        ]),
                    child: TextField(
                      controller: info,
                      maxLines: 7,
                      decoration: InputDecoration(hintText: "Enter info"),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    child: InkWell(
                      onTap: () async {
                        if (name.text.isNotEmpty &&
                            info.text.isNotEmpty &&
                            profileImage != null) {
                          var check = await addSpecialist(
                              context, name.text, info.text, profileImage!);

                          print(check);

                          Navigator.of(context).pop();
                          loadData();
                        } else {
                          Fluttertoast.showToast(msg: "Enter All Info");
                        }
                      },
                      child: fullviewbtn(
                        inverse: true,
                        isDisabled: true ? false : true,
                        text: "Save",
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  deleteReco(int i) async {
    print("Deleting Object : " + i.toString());

    var check = await DeleteSpecialist(context, i);
    print(check);

    loadData();
  }

  editData(int i, Map<String, Object?> data) async {
    print("Editing Object Index: " + i.toString());

    print(data);

    var respo = await EditSpecialist(context, i, data);

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: InkWell(
        onTap: () {
          editValues();
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: primeColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: snapData == null
          ? screenLoader()
          : Column(
              children: [
                SizedBox(
                  child: TopBarLabel(
                    label: "Manage Specialist",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                lightLabel(label: "Our Specialist"),
                SizedBox(height: 20),
                Expanded(
                    child: Container(
                  child: ListView.builder(
                      itemCount: specialist!.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: EdgeInsets.all(10),
                            child: SpecialistCard(
                              name: specialist![index]["name"],
                              info: specialist![index]["info"],
                              profile: specialist![index]["profile"],
                              delete: deleteReco,
                              edit: editData,
                            ));
                      }),
                ))
              ],
            ),
    ));
  }
}
