import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../features.dart';
import 'widgets/custom_time_picker.dart';

class MeditationAddUi extends StatefulWidget {
  const MeditationAddUi({super.key});

  @override
  State<MeditationAddUi> createState() => _MeditationAddUiState();
}

class _MeditationAddUiState extends State<MeditationAddUi> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  List<MeditationWithDuration> meditationWithDurationList = [];
  MeditationWithDescription meditationWithDescription =
      MeditationWithDescription();

  // String selectPlaylistProfile = '';
  List playlistProfile = [
    AppAssets.playlistProfileOne,
    AppAssets.playlistProfileTwo,
    AppAssets.playlistProfileThree,
    AppAssets.playlistProfileFour,
    AppAssets.carouselImageOne,
    AppAssets.carouselImageTwo,
    AppAssets.carouselImageThree
  ];

  int selectedPlaylistIndex = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddPlaylistSelectionProvider>(context);
    return Scaffold(
      floatingActionButton: CustomFAButton(
        buttonText: "   Done   ",
        onPressed: () async {
          if (formKey.currentState!.validate() &&
              meditationWithDurationList.isNotEmpty) {
            ByteData data = await rootBundle.load(provider.selectedProfile);
            Uint8List playlistImage = data.buffer.asUint8List();
            AddMeditationRepository().addMeditationTask(
                MeditationWithDescription(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    playlistImage: playlistImage,
                    meditationWithDurationList: meditationWithDurationList,
                    createdAt: DateTime.now()));
            Navigator.pop(context, true);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomBackGround(
          image: AppAssets.backgroundImage,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const AppBarForAdditional(
                    title: "Add Your Meditation",
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Select Background Image",
                            style: TextStyle(
                                color: TColor.secondary,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600))),
                  ),
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
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40.h,
                    child: RoundedButton(
                      title: "Add Steps",
                      type: RoundedButtonType.primary,
                      onPressed: () {
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
                                        borderRadius:
                                            BorderRadius.circular(16)),
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
                                                  onDurationSelected:
                                                      (Duration duration) {
                                                    durationController.text =
                                                        formatDuration(
                                                            duration);
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          height: 40.h,
                                          child: RoundedButton(
                                              title: "Submit",
                                              type: RoundedButtonType.primary,
                                              onPressed: () async {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  MeditationWithDuration
                                                      meditationWithDuration =
                                                      MeditationWithDuration();
                                                  meditationWithDuration
                                                          .subTitle =
                                                      subtitleController.text
                                                          .trim();
                                                  meditationWithDuration
                                                          .duration =
                                                      durationController.text
                                                          .trim();

                                                  meditationWithDuration
                                                          .createdAt =
                                                      DateTime.now();
                                                  setState(() {
                                                    meditationWithDurationList.add(
                                                        meditationWithDuration);
                                                    Navigator.pop(context);
                                                  });
                                                  subtitleController.clear();
                                                  durationController.clear();
                                                }
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12.h),
                  meditationWithDurationList.isEmpty
                      ? Column(
                          children: [
                            Image.asset(AppAssets.noDataFound, height: 200.h),
                            Text('No List Found',
                                style: TextStyle(
                                    color: TColor.secondary, fontSize: 16.sp)),
                          ],
                        )
                      : Column(
                          children: List.generate(
                              meditationWithDurationList.length,
                              (index) => CustomListTile(
                                    vertical: 4,
                                    title: meditationWithDurationList[index]
                                            .subTitle ??
                                        '',
                                    duration: meditationWithDurationList[index]
                                            .duration ??
                                        '',
                                    isMoreVert: false,
                                    onTapEdit: () {
                                      setState(() {
                                        meditationWithDurationList
                                            .removeAt(index);
                                      });
                                    },
                                  )),
                        ),
                ],
              ),
            ),
          )),
    );
  }

  Widget imageContainer({
    required String playListImage,
    required int index,
  }) {
    final provider = Provider.of<AddPlaylistSelectionProvider>(context);
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

  String formatDuration(Duration duration) {
    String seconds = duration.inSeconds.toString().padLeft(2, '0');
    return '$seconds';
  }
}
