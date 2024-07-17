import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../features.dart';
import '../../meditation_add/screens/widgets/custom_time_picker.dart';

class MeditationEditUI extends StatefulWidget {
  final int id;
  final String title;
  final String description;

  final List meditationSubTitleModels;
  const MeditationEditUI({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.meditationSubTitleModels,
  });

  @override
  State<MeditationEditUI> createState() => _MeditationEditUIState();
}

class _MeditationEditUIState extends State<MeditationEditUI> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  List<MeditationWithDuration> meditationWithDuration = [];
  bool isLoading = false;
  List playlistProfile = [
    AppAssets.playlistProfileOne,
    AppAssets.playlistProfileTwo,
    AppAssets.playlistProfileThree,
    AppAssets.playlistProfileFour,
    AppAssets.carouselImageOne,
    AppAssets.carouselImageTwo,
    AppAssets.carouselImageThree
  ];
  @override
  void initState() {
    super.initState();
    getList();
    setState(() {
      titleController.text = widget.title;
      descriptionController.text = widget.description;
    });
  }

  Future<void> getList() async {
    try {
      dynamic response =
          await MeditationDetailsRepositories().getSubtitleList(widget.id);

      log(response.toString());

      setState(() {
        isLoading = false;

        if (response.isEmpty) {
          meditationWithDuration = [];
        } else {
          meditationWithDuration = response;
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditPlaylistSelectionProvider>(context);
    return Scaffold(
      floatingActionButton: CustomFAButton(
          buttonText: "Update",
          onPressed: meditationWithDuration.isNotEmpty
              ? () async {
                  if (formKey.currentState!.validate()) {
                    ByteData data =
                        await rootBundle.load(provider.selectedProfile);
                    Uint8List playlistImage = data.buffer.asUint8List();
                    Map<String, dynamic> editData = {
                      'id': widget.id,
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'playlist_image_path': playlistImage
                    };
                    log("editData:$editData");
                    await EditRepositories().editInTitle(editData);

                    Navigator.pop(context, true);
                  }
                }
              : () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomBackGround(
          image: AppAssets.backgroundImage,
          child: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const AppBarForAdditional(title: "Edit Your Meditation"),
                    SizedBox(height: 8.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              playlistProfile.length,
                              (index) => imageContainer(
                                    index: index,
                                    playListImage: playlistProfile[index],
                                  ))),
                    ),
                    SizedBox(height: 8.h),
                    RoundedTextField(
                        controller: titleController, hintText: 'Title'),
                    SizedBox(height: 8.h),
                    RoundedTextField(
                        controller: descriptionController,
                        hintText: 'Description...',
                        maxLine: 4),
                    SizedBox(height: 16.h),
                    Column(
                      children: List.generate(
                          meditationWithDuration.length,
                          (index) => GestureDetector(
                                onTap: () {
                                  _openShowDialog(
                                      subtitle: meditationWithDuration[index]
                                              .subTitle ??
                                          "",
                                      duration: meditationWithDuration[index]
                                              .duration ??
                                          "",
                                      id: meditationWithDuration[index].id ??
                                          0);
                                },
                                child: CustomListTile(
                                  title:
                                      meditationWithDuration[index].subTitle ??
                                          "",
                                  duration:
                                      meditationWithDuration[index].duration ??
                                          "",
                                  vertical: 2,
                                  isMoreVert: false,
                                  isNoMoreVertAndDelete: true,
                                ),
                              )),
                    )
                  ],
                )),
          )),
    );
  }

  Widget imageContainer({
    required String playListImage,
    required int index,
  }) {
    final provider = Provider.of<EditPlaylistSelectionProvider>(context);
    final isSelected = provider.selectedIndex == index;
    return GestureDetector(
      onTap: () {
        provider.updateSelection(index, playListImage);
      },
      child: Container(
        height: 50.h,
        width: 50.w,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border:
                isSelected ? Border.all(color: TColor.primary, width: 4) : null,
            image: DecorationImage(
                image: AssetImage(playListImage), fit: BoxFit.fill)),
      ),
    );
  }

  _openShowDialog(
      {required int id, required String subtitle, required String duration}) {
    GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();
    setState(() {
      subtitleController.text = subtitle;
      durationController.text = duration;
    });
    showDialog(
      context: context,
      builder: (context) {
        return Builder(
          builder: (context) {
            return Dialog(
              child: Container(
                height: 250.h,
                decoration: BoxDecoration(
                    color: TColor.txtBG,
                    borderRadius: BorderRadius.circular(16)),
                child: Form(
                  key: dialogFormKey,
                  child: ListView(
                    children: [
                      SizedBox(height: 16.h),
                      RoundedTextField(
                        controller: subtitleController,
                        hintText: "Subtitle",
                      ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomTimePicker(
                                onDurationSelected: (Duration duration) {
                                  durationController.text =
                                      formatDuration(duration);
                                },
                              );
                            },
                          );
                        },
                        child: AbsorbPointer(
                          child: RoundedTextField(
                            controller: durationController,
                            hintText: "Seconds",
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 40.h,
                        child: RoundedButton(
                            title: "Submit",
                            type: RoundedButtonType.primary,
                            onPressed: () async {
                              if (dialogFormKey.currentState != null &&
                                  dialogFormKey.currentState!.validate()) {
                                Map<String, dynamic> data = {
                                  'id': id,
                                  'title_list_id': widget.id,
                                  'sub_title': subtitleController.text,
                                  'duration': durationController.text
                                };
                                await EditRepositories().editInSubtitle(data);
                                setState(() {
                                  getList();
                                  Navigator.pop(context);
                                });
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    String seconds = duration.inSeconds.toString().padLeft(2, '0');
    return '$seconds';
  }
}
