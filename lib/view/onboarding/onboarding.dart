import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../components/app_button_widget.dart';
import '../../components/logo_component.dart';
import '../../utils/app/constant.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';
import '../auth/login.dart';
import '../terms/terms_and_conditon.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  fetchtermsandcondition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      agreedtermandcondition = prefs.getString("agree").toString();
      print("object mashwai");
      print(agreedtermandcondition);
    });
  }

  String agreedtermandcondition = "";
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  // late PlayerState _playerState;
  // late YoutubeMetaData _videoMetaData;
  // final double _volume = 100;
  // final bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _videoIds = [
    YoutubePlayer.convertUrlToId('https://youtu.be/Oy_XDSRVe3U')!,
    YoutubePlayer.convertUrlToId(
        'https://www.youtube.com/watch?v=JcxzXxqxb1Y&feature=youtu.be')!,
    YoutubePlayer.convertUrlToId('https://youtu.be/KbxHiyJ4q3Y')!,

    // 'PLvQ2RGpesg2YG2ES7hsZ',
    // 'gQDByCdjUXw',
    // 'iLnmTe5Q2Qw',
    // '_WoCV4c6XOE',
    // 'KmzdUe0RSJo',
    // '6jZDSSZZxjQ',
    // 'p2lYr3vM_1w',
    // '7QUtEmBT_-w',
    // '34_PXCzGw1M',
  ];

  String? video1 = YoutubePlayer.convertUrlToId('url');

  // String? videoId(String url) {
  //   return YoutubePlayer.convertUrlToId(url);
  // }
  int pageIndex = 0;
  void next() {
    setState(() {
      pageIndex = pageIndex + 1;
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: _videoIds.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    // _videoMetaData = const YoutubeMetaData();
    // _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        // _playerState = _controller.value.playerState;
        // _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenHeight(18),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller.load(_videoIds[
              (_videoIds.indexOf(data.videoId) + 1) % _videoIds.length]);
          // _showSnackBar('Next Video Started!');
        },
      ),
      builder: (context, player) => SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(getProportionateScreenHeight(8)),
            child: Column(
              children: [
                buildVerticleSpace(20),
                const LogoWidget(),
                // buildVerticleSpace(20),
                const Spacer(),
                kTextBentonSansMed(
                  _controller.metadata.title.capitalize!,
                  textAlign: TextAlign.center,
                  fontSize: getProportionateScreenHeight(20),
                ),
                buildVerticleSpace(20),
                player,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      height: getProportionateScreenHeight(5),
                      width: getProportionateScreenWidth(50),
                      margin: EdgeInsets.all(getProportionateScreenHeight(20)),
                      decoration: BoxDecoration(
                        color: pageIndex == index
                            ? ColorManager.ambar
                            : ColorManager.grey,
                        borderRadius: BorderRadius.circular(
                          getProportionateScreenHeight(20),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  child: AppButtonWidget(
                    bgColor: Colors.white,
                    text: 'For More Details  |  Visit Our Website Now',
                    textColor: Colors.black,
                    ontap: () {
                      launchUrl(Uri.parse("https://sehr.pk/"));
                    },
                  ),
                ),
                const Spacer(flex: 2),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  child: AppButtonWidget(
                    text: 'Next',
                    ontap: () async {
                      await fetchtermsandcondition();

                      next();
                      pageIndex == 3
                          ? navigate()
                          : (_isPlayerReady
                              ? _controller.load(_videoIds[(_videoIds.indexOf(
                                          _controller.metadata.videoId) +
                                      1) %
                                  _videoIds.length])
                              : null);
                    },
                  ),
                ),
                buildVerticleSpace(50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  navigate() {
    if (agreedtermandcondition == "null") {
      Get.offAll(() => const TermsConditionView());
    } else {
      Get.offAll(() => LoginView());
    }
  }
}

_launchURL() async {
  const url = 'https://sehr.pk/';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
