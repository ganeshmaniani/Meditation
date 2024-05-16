import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:typed_data';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:meditation_new/features/features.dart';

import '../../../core/core.dart';

class MeditationViewUI extends StatefulWidget {
  final int? titleListId;
  final Uint8List playlistImage;
  const MeditationViewUI(
      {super.key, this.titleListId, required this.playlistImage});

  @override
  State<MeditationViewUI> createState() => _MeditationViewUIState();
}

class _MeditationViewUIState extends State<MeditationViewUI> {
  List<MeditationWithDuration> meditationWithDuration = [];
  bool isLoading = true;
  List<Timer> timers = [];
  List<int> remainingDurations = [];
  int currentSubtitleIndex = 0;
  bool isPaused = false;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isRippleAnimationRunning = false;
  @override
  void initState() {
    super.initState();
    isPaused = true;
    getList();
  }

  Future<void> getList() async {
    try {
      dynamic response = await MeditationDetailsRepositories()
          .getSubtitleList(widget.titleListId);
      log(response.toString());

      setState(() {
        isLoading = false;

        if (response.isEmpty) {
          meditationWithDuration = [];
        } else {
          meditationWithDuration = response;
          // Initialize remaining durations with the original durations
          remainingDurations = meditationWithDuration
              .map((model) => int.parse(model.duration!))
              .toList();
        }
      });
    } catch (error) {
      // Handle the error here
      log("Error fetching data: $error");

      setState(() {
        isLoading = false;
        // You might want to set an error state or show a message to the user.
      });
    }
  }

  void startTimer() {
    setState(() {
      isPaused = false;
      isRippleAnimationRunning = true; // Start the animation
    });
    void countdown(int duration) {
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
        if (duration >= 0 && !isPaused) {
          if (mounted) {
            setState(() {
              remainingDurations[currentSubtitleIndex] = duration;
            });
            duration--;
            log(duration.toString());

            if (duration == -1) {
              log('Audio');
              try {
                await _audioPlayer.play(AssetSource(AppAssets.meditationAudio));
                log('Audio play success');
              } catch (error) {
                log('Audio play error: $error');
              }
            }
          }
        } else {
          t.cancel();

          currentSubtitleIndex++;

          // Check if there are more subtitles
          if (currentSubtitleIndex < meditationWithDuration.length &&
              !isPaused) {
            // Delay the start of the next countdown
            Future.delayed(const Duration(seconds: 1), () {
              countdown(int.parse(
                  meditationWithDuration[currentSubtitleIndex].duration!));
            });
          } else {
            setState(() {
              openSuccessMessage();
              isPaused = true;
              isRippleAnimationRunning = false; // Stop the animation
            });
          }
        }
      });
      timers.add(_timer!);
    }

    // Start the countdown with the first duration
    countdown(
        int.parse(meditationWithDuration[currentSubtitleIndex].duration!));
    log(meditationWithDuration[currentSubtitleIndex].duration!.toString());
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;

      if (isPaused) {
        _timer?.cancel();
        isRippleAnimationRunning = false; //
      } else {
        startTimer();
      }
    });
  } // Add a function to toggle pause/resume

  void resetTimer() {
    _timer?.cancel(); // Cancel the current timer
    remainingDurations[currentSubtitleIndex] =
        int.parse(meditationWithDuration[currentSubtitleIndex].duration!);
  }

  bool isTimerRunning() {
    return timers.isNotEmpty && !_timer!.isActive;
  }

  @override
  void dispose() {
    for (var timer in timers) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
              heroTag: 'uniqueTag1',
              backgroundColor: Colors.white,
              elevation: 0,
              onPressed: currentSubtitleIndex > 0
                  ? () {
                      setState(() {
                        isPaused = true;
                        resetTimer();
                        currentSubtitleIndex--;
                      });
                    }
                  : () {},
              child: const Icon(Icons.skip_previous, color: Colors.black)),
          SizedBox(width: 10.w),
          FloatingActionButton(
            heroTag: 'uniqueTag2',
            backgroundColor: Colors.white,
            elevation: 0,
            onPressed: () {
              if (timers.isEmpty) {
                startTimer();
              } else {
                togglePause();
              }
            },
            child: isPaused
                ? const Icon(Icons.play_arrow, color: Colors.black)
                : const Icon(Icons.pause, color: Colors.black),
          ),
          SizedBox(width: 10.w),
          FloatingActionButton(
            heroTag: 'uniqueTag3',
            backgroundColor: Colors.white,
            elevation: 0,
            onPressed: currentSubtitleIndex < meditationWithDuration.length - 1
                ? () {
                    setState(() {
                      isPaused = true;
                      resetTimer();
                      currentSubtitleIndex = currentSubtitleIndex + 1;
                      log(currentSubtitleIndex.toString());
                    });
                  }
                : () {
                    setState(() {
                      currentSubtitleIndex = 0;
                    });
                  },
            child: const Icon(Icons.skip_next, color: Colors.black),
          ),
        ],
      ),
      body: MemoryBackGroundImage(
        playImage: widget.playlistImage,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBarForAdditional(
                  isViewScreen: true,
                  title: currentSubtitleIndex != meditationWithDuration.length
                      ? meditationWithDuration[currentSubtitleIndex].subTitle ??
                          ""
                      : 'Finish'),
              SizedBox(height: 100.h),
              Stack(
                children: [
                  isRippleAnimationRunning
                      ? Positioned(
                          right: 50,
                          bottom: 60.h,
                          top: 60.h,
                          left: 50,
                          child: RippleAnimation(
                              delay: const Duration(milliseconds: 300),
                              repeat: true,
                              minRadius: 60,
                              ripplesCount: 6,
                              color: const Color(0xff6849ef),
                              duration: const Duration(milliseconds: 6 * 300),
                              child: Container()))
                      : Positioned(
                          right: 50,
                          bottom: 60.h,
                          top: 60.h,
                          left: 50,
                          child: SizedBox()),
                  Positioned(
                    right: 50,
                    bottom: 60.h,
                    top: 60.h,
                    left: 50,
                    child: CircularProgressIndicator(
                      strokeAlign: 7,
                      value: remainingDurations.isNotEmpty &&
                              currentSubtitleIndex < remainingDurations.length
                          ? remainingDurations[currentSubtitleIndex]
                                  .toDouble() /
                              double.parse(
                                  meditationWithDuration[currentSubtitleIndex]
                                      .duration!)
                          : 0.0,
                      valueColor:
                          const AlwaysStoppedAnimation(Color(0xff6849ef)),
                      backgroundColor: Colors.white,
                      strokeWidth: 16,
                      // color: const Color(0xff886ff2),
                    ),
                  ),
                  Container(
                    width: 250.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient:
                            RadialGradient(focal: Alignment.topCenter, colors: [
                          Colors.grey.withOpacity(0.7),
                          Colors.white.withOpacity(0.6),
                        ])),
                  ),
                  Positioned(
                    right: 50,
                    bottom: 50,
                    top: 50,
                    left: 50,
                    child: Container(
                      alignment: Alignment.center,
                      width: 200.w,
                      height: 200.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            const Color(0xFFEE811A).withOpacity(0.3),
                            const Color(0xFFFFFAD4).withOpacity(0.3),
                          ])),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: currentSubtitleIndex <
                                  remainingDurations.length,
                              child: currentSubtitleIndex <
                                      remainingDurations.length
                                  ? Text(
                                      '${remainingDurations[currentSubtitleIndex]}',
                                      style: TextStyle(
                                          fontSize: 50.sp,
                                          fontWeight: FontWeight.w700),
                                    )
                                  : Text(
                                      'Finish',
                                      style: TextStyle(
                                          fontSize: 50.sp,
                                          fontWeight: FontWeight.w700),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future openSuccessMessage() {
    return AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.topSlide,
            btnOkOnPress: () {
              Navigator.pop(context);
            },
            title: 'Success')
        .show();
  }
}
