import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skin_detection/cubit/skin_cubit.dart';
import 'package:skin_detection/utilites/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final picker = ImagePicker();
  File? img;
  var url = "https://skin-app-production-e519.up.railway.app/predictApi";

  Future pickImageGallery() async {
    PickedFile? pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    setState(() {
      img = File(pickedFile!.path);
    });
  }

  Future pickImageCamera() async {
    PickedFile? pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    setState(() {
      img = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.bottomCenter, children: [
        Container(
            padding: const EdgeInsets.only(left: 20, top: 100, right: 20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: AppColors.primaryColor),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Welcome to skin detection app !',
                  textStyle: const TextStyle(
                    fontSize: 30.0,
                    color: Colors.white54,
                    fontWeight: FontWeight.w700,
                  ),
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              pause: const Duration(milliseconds: 1000),
              // displayFullTextOnTap: true,
            )),
        Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                topLeft: Radius.circular(40.0)),
          ),
          child: BlocProvider(
            create: (context) => SkinCubit(),
            child: Column(
              children: [
                img == null
                    ? const CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage(
                          "assets/images/img.jpg",
                        ),
                      )
                    : CircleAvatar(
                        radius: 100,
                        backgroundImage: FileImage(
                          File(img!.path),
                        ),
                      ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<SkinCubit, SkinState>(
                  builder: (context, state) {
                    return img == null
                        ? Container(
                            height: 1,
                          )
                        : Text(
                            SkinCubit().get(context).result ??
                                "Click upload image ",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Take Image",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Choose image'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    OutlinedButton(
                                        onPressed: () {
                                          pickImageGallery();
                                        },
                                        child: const Text("Gallery")),
                                    OutlinedButton(
                                        onPressed: () {
                                          pickImageCamera();
                                        },
                                        child: const Text("Camera")),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<SkinCubit, SkinState>(
                  builder: (context, state) {
                    return state is SkinLoadingState
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Upload Image",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                onPressed: () {
                                  SkinCubit().get(context).upload(img: img);
                                }),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
