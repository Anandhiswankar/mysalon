import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysalon/elements/lodingbar.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/services/upload/uploadImage.dart';
import 'package:mysalon/services/getData/getUserSlider.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class EditBanner extends StatefulWidget {
  const EditBanner({super.key});

  @override
  State<EditBanner> createState() => _EditBannerState();
}

class _EditBannerState extends State<EditBanner> {
  List<dynamic> slideShowImages = [
    "https://img.freepik.com/free-photo/interior-latino-hair-salon_23-2150555185.jpg",
    "https://shilpaahuja.com/wp-content/uploads/2019/04/top-salons-india-hair-coloring-costs-color-service-haircolor.jpg",
    "https://media.istockphoto.com/id/1271712634/photo/young-woman-looking-for-changes-trying-new-hairstyle-at-beauty-salon.jpg?s=612x612&w=0&k=20&c=Ylwrr2lDHn9F9y2lP5oFqc7CqzadLJAIcfWYx1l7Vjc="
  ];

  List<Widget> slideChild = [];

  int activePage = 0;

  @override
  void initState() {
    super.initState();

    load();
  }

  Future<XFile?> getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      return image;
    } else {
      return null;
    }
  }

  uploadImage() async {
    alertBox(context);
    var file = await getImage();

    var uploadedPath = await uploadToFirebase(
        File(file!.path), FirebaseAuth.instance.currentUser!.uid);

    slideShowImages.add(uploadedPath);

    await updateUserSlider(slideShowImages);
    Navigator.of(context).pop();
    setState(() {});
  }

  deleteImage(index) {
    slideShowImages.removeAt(index);
    setState(() {});

    updateUserSlider(slideShowImages);
  }

  load() async {
    var data = await getUserSlider();

    if (data != null) {
      slideShowImages.clear();
      slideShowImages.addAll(data);

      setState(() {});
    }

    if (slideShowImages.isNotEmpty) {
      for (int i = 0; i < slideShowImages.length; i++) {
        var wid = Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 1.5,
                    offset: Offset(0, 5),
                    color: Color.fromARGB(156, 61, 61, 61))
              ],
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: NetworkImage(slideShowImages[i]), fit: BoxFit.cover)),
        );

        slideChild.add(wid);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: slideShowImages.isEmpty
              ? screenLoader()
              : Column(
                  children: [
                    TopBarLabel(label: "Edit Banner"),
                    SizedBox(
                      height: 20,
                    ),
                    slideShowImages.isEmpty
                        ? screenLoader()
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: 200,
                            child: slideChild.isEmpty
                                ? screenLoader()
                                : ImageSlideshow(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    initialPage: 0,
                                    indicatorRadius: 0,
                                    onPageChanged: (e) {
                                      activePage = e;
                                      setState(() {});
                                    },
                                    children: slideChild.toList()),
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      alignment: Alignment.center,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: slideShowImages.length,
                          itemBuilder: (context, index) {
                            return Icon(
                              Icons.circle,
                              size: 15,
                              color: activePage == index
                                  ? primeColor
                                  : Colors.grey,
                            );
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    lightLabel(
                      label: "Add Banners",
                      isblack: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: (170 * slideShowImages.length).toDouble(),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: slideShowImages.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {},
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: 150,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: primeColor),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 160,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          color: Colors.black,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  slideShowImages[index]),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Banner $index",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        deleteImage(index);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    InkWell(
                      onTap: () {
                        uploadImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 150,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: primeColor),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 160,
                              height: 120,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                Icons.add,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Add Banner",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
