import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> avatars = [
    AppAssets.manProfile,
    AppAssets.womenProfile,
    AppAssets.boyProfile,
    AppAssets.girlProfile
  ];

  String selectGenderImage = "";
  String selectedAvatar = '';
  String selectGender = '';
  final userNameController = TextEditingController();
  final ageController = TextEditingController();
  bool isLoading = false;
  final AuthRepositories authRepositories = AuthRepositories();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 229, 229),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const RegisterAppBar(),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) => Container(
                            padding: const EdgeInsets.all(8),
                            height: 200.h,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 8,
                                      mainAxisExtent: 100,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 10,
                                      crossAxisCount: 2),
                              itemCount: avatars.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedAvatar = avatars[index];
                                  });
                                  Navigator.pop(context);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    avatars[index],
                                    width: 30.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            )));
                  },
                  child: selectedAvatar == ''
                      ? Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 80.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade400),
                              child: Icon(Icons.person,
                                  size: 70.h, color: Colors.grey.shade200),
                            ),
                            Positioned(
                                bottom: 12,
                                right: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade400,
                                      border: Border.all(
                                          width: 4, color: Colors.white)),
                                  child: Icon(Icons.add,
                                      size: 16.h, color: Colors.white),
                                ))
                          ],
                        )
                      : Container(
                          height: 80.h,
                          width: 80.w,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: Image.asset(selectedAvatar),
                        ),
                ),
                SizedBox(height: 16.h),
                RoundedTextField(
                  hintText: "Username",
                  controller: userNameController,
                ),
                SizedBox(height: 8.h),
                RoundedTextField(
                  hintText: "Age",
                  controller: ageController,
                  type: TextInputType.number,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) => Container(
                            color: Colors.grey.shade300,
                            height: 200.h,
                            child: ListView(children: [
                              GenderSelectionItem(
                                  text: "Male",
                                  image: AppAssets.male,
                                  onSelect: (text) => setState(() {
                                        if (selectGender != "Male") {
                                          selectGender = text;
                                          selectGenderImage = AppAssets.male;
                                        }
                                        context.pop();
                                      })),
                              GenderSelectionItem(
                                  text: "Female",
                                  image: AppAssets.female,
                                  onSelect: (text) => setState(() {
                                        selectGender = text;
                                        selectGenderImage = AppAssets.female;
                                        context.pop();
                                      })),
                              GenderSelectionItem(
                                  text: "Others",
                                  image: AppAssets.others,
                                  onSelect: (text) => setState(() {
                                        selectGender = text;
                                        selectGenderImage = AppAssets.others;
                                        context.pop();
                                      }))
                            ])));
                  },
                  child: Container(
                    height: 50.h,
                    width: context.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: TColor.primaryTextW,
                        borderRadius: BorderRadius.circular(15)),
                    child: selectGender == ""
                        ? Text(
                            'Select Gender',
                            style: TextStyle(
                                color: TColor.secondaryText, fontSize: 16.sp),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectGender,
                                style: TextStyle(fontSize: 18.sp),
                              ),
                              Image.asset(
                                selectGenderImage,
                                height: 30.h,
                              )
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 16.h),
                isLoading
                    ? const CircularProgressIndicator()
                    : RoundedButton(
                        title: 'Register',
                        type: RoundedButtonType.primary,
                        onPressed: selectedAvatar == ''
                            ? () {}
                            : () async {
                                await onRegisterSubmit(context);
                              },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  onRegisterSubmit(BuildContext context) async {
    setState(() => isLoading = true);
    if (formKey.currentState!.validate() && selectGender != '') {
      ByteData data = await rootBundle.load(selectedAvatar);
      Uint8List profileImage = data.buffer.asUint8List();

      final userName = userNameController.text.trim();
      final age = ageController.text.trim();

      final gender = selectGender;
      await authRepositories.insertUser(userName, age, gender, profileImage);
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeUI()),
          (route) => false);
      setState(() => isLoading = true);
    }
  }
}
