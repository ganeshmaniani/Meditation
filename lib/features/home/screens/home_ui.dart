import 'dart:developer';
// import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../features.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  Uint8List? profileImage;
  String? userName;
  String? _greeting;
  List carouselList = [
    AppAssets.carouselImageOne,
    AppAssets.carouselImageTwo,
    AppAssets.carouselImageThree
  ];

  List<MeditationWithDescription> meditationWithDescription = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    await getMeditationListView();
    await getUserDetails();
    _updateGreeting();
  }

  Future<void> getMeditationListView() async {
    isLoading = true;
    try {
      dynamic response = await HomeRepositories().getMeditationList();
      // log("HomeResponse:${response.toString()}");
      if (response.isNotEmpty) {
        meditationWithDescription = response;
        isLoading = false;
      } else {
        isLoading = false;
      }
    } catch (e) {
      print('Error in getMeditationListView: $e');
    }
  }

  Future<void> getUserDetails() async {
    try {
      var resultUserData = await AuthRepositories().getUser();
      // log("User Details ${resultUserData.toString()}");

      if (resultUserData.isNotEmpty) {
        setState(() {
          profileImage = Uint8List.fromList(resultUserData['profile_image']);
          userName = resultUserData['user_name'];
          log(userName!);
        });
      } else {
        setState(() {});
      }
    } catch (e) {
      log('Error in getUserDetails: $e');
    }
  }

  void _updateGreeting() {
    String greeting = _getGreeting();
    setState(() {
      _greeting = greeting;
    });
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        floatingActionButton: CustomFAButton(
          buttonText: "Add Meditation",
          onPressed: () async {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MeditationAddUi()));
            if (result == true) {
              await getMeditationListView();
              setState(() {});
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: CustomBackGround(
          image: AppAssets.backgroundImage,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                profileImage != null
                    ? CustomAppBar(
                        profileImage: profileImage!,
                        greeting: _greeting ?? '',
                        userName: userName ?? '',
                      )
                    : const SizedBox(),
                SizedBox(height: 16.h),
                Text("Meditation",
                    style: TextStyle(
                        fontSize: 24.sp, fontWeight: FontWeight.w800)),
                SizedBox(height: 8.h),
                CarouselSlider(
                    items: carouselList
                        .map((e) => Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(e), fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(16)),
                            ))
                        .toList(),
                    options: CarouselOptions(
                        autoPlay: true, height: 150.h, viewportFraction: 1)),
                meditationWithDescription.isEmpty || isLoading
                    ? Center(
                        child: LottieBuilder.asset(
                            reverse: true,
                            AppAssets.emptyMeditationImage,
                            height: 250.h))
                    : SizedBox(
                        height: 250.h,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: meditationWithDescription.length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => MeditationViewUI(
                                              titleListId:
                                                  meditationWithDescription[
                                                          index]
                                                      .id,
                                              playlistImage:
                                                  meditationWithDescription[
                                                          index]
                                                      .playlistImage!)));
                                },
                                child: CustomListTile(
                                  title:
                                      meditationWithDescription[index].title ??
                                          "",
                                  playlistImage:
                                      meditationWithDescription[index]
                                          .playlistImage,
                                  duration: "",
                                  description: meditationWithDescription[index]
                                      .description,
                                  vertical: 2,
                                  isHome: true,
                                  isMoreVert: true,
                                  onSelectedDelete: (result) async {
                                    if (result == "Edit") {
                                      final navigateResult =
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (_) => MeditationEditUI(
                                                            id: meditationWithDescription[
                                                                        index]
                                                                    .id ??
                                                                0,
                                                            title: meditationWithDescription[
                                                                        index]
                                                                    .title ??
                                                                "",
                                                            description:
                                                                meditationWithDescription[
                                                                            index]
                                                                        .description ??
                                                                    "",
                                                            meditationSubTitleModels:
                                                                meditationWithDescription[
                                                                            index]
                                                                        .meditationWithDurationList ??
                                                                    [],
                                                          )));
                                      if (navigateResult == true) {
                                        await getMeditationListView();
                                        setState(() {});
                                      }
                                    }
                                    if (result == "Delete") {
                                      showAlertBox(context,
                                          btnOkOnPress: () async {
                                        var result = await HomeRepositories()
                                            .deleteMeditationList(
                                                meditationWithDescription[index]
                                                    .id
                                                    .toString());

                                        if (result == null) {
                                          await getMeditationListView();
                                          setState(() {});
                                        }
                                      }, btnCancelOnPress: () {});
                                    }
                                  },
                                ),
                              );
                            }),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
