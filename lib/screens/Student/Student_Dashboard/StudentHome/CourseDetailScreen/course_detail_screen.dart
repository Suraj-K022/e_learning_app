import 'dart:async';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/PdfDetailScreen/pdf_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../../../customWidgets/custom_buttons.dart';
import '../../../../../customWidgets/customtext.dart';
import '../../../../../customWidgets/pdf_card_widget.dart';
import '../../../../../utils/images.dart';
import '../student_home.dart';

class CourseDetailScreen extends StatefulWidget {
  final String title;
  final String imgUrl;
  final String videoUrl;
  final String pdfUrl;
  final String description;

  const CourseDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.pdfUrl,
    required this.imgUrl,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _hasError = false;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
      setState(() {
        _isVideoInitialized = true;
        _isPlaying = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      debugPrint("Error initializing video: $e");
      Get.snackbar("Error", "Could not load video: $e");
    }
  }

  void _togglePlayPause() {
    if (!_isVideoInitialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _seekTo(double value) {
    if (!_isVideoInitialized) return;
    final duration = _controller.value.duration;
    if (duration != Duration.zero) {
      final newPosition = duration * value;
      _controller.seekTo(newPosition);
    }
  }

  void _goFullScreen() {
    if (!_isVideoInitialized) return;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    Get.to(() =>
            FullScreenVideo(videoName: widget.title, controller: _controller))
        ?.then((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: widget.title,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.theme.secondaryHeaderColor,
            size: 24,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          Poppins(
            text: widget.description,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
            fontSize: 14,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          _hasError
              ? Center(
                  child: Poppins(
                    text: "Failed to load video",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                )
              : _isVideoInitialized
                  ? Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 300,
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: _togglePlayPause,
                                    child: VideoPlayer(_controller),
                                  ),
                                  if (!_isPlaying)
                                    Container(
                                      color: Colors.black.withOpacity(0.5),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.play_arrow,
                                          size: 64,
                                          color: Colors.white,
                                        ),
                                        onPressed: _togglePlayPause,
                                      ),
                                    ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.fullscreen,
                                        size: 28,
                                        color: Get.theme.cardColor,
                                      ),
                                      onPressed: _goFullScreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _controller,
                          builder: (context, VideoPlayerValue value, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: value.position.inMilliseconds
                                        .toDouble(),
                                    min: 0,
                                    max: value.duration.inMilliseconds
                                        .toDouble(),
                                    onChanged: (newValue) {
                                      _seekTo(newValue /
                                          value.duration.inMilliseconds);
                                    },
                                    activeColor: Get.theme.primaryColor,
                                    inactiveColor: Get.theme.hintColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Poppins(
                                      text: _formatDuration(value.position),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Get.theme.secondaryHeaderColor,
                                    ),
                                    Poppins(
                                      text: '/',
                                      color: Get.theme.secondaryHeaderColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                    Poppins(
                                      text: _formatDuration(value.duration),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Get.theme.secondaryHeaderColor,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(
                      color: Get.theme.primaryColor,
                    )),
          const SizedBox(height: 20),
          Poppins(
            text: 'View PDF',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Get.theme.secondaryHeaderColor,
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              Get.to(PdfDetailScreen(
                  title: widget.title,
                  description: widget.description,
                  pdfPath: widget.pdfUrl));
            },
            child: PdfCard(
                title: widget.title,
                description: widget.description,
                color: Colors.red,
                imgUrl: widget.imgUrl),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}

class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController controller;
  final String videoName;

  const FullScreenVideo(
      {super.key, required this.controller, required this.videoName});

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _startHideControlsTimer();
    widget.controller.addListener(_resetControlsOnInteraction);
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideControlsTimer();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _resetControlsOnInteraction() {
    if (_showControls) _startHideControlsTimer();
  }

  void _seekTo(double value) {
    final duration = widget.controller.value.duration;
    final newPosition =
        Duration(milliseconds: (value * duration.inMilliseconds).toInt());
    widget.controller.seekTo(newPosition);
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    widget.controller.removeListener(_resetControlsOnInteraction);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.controller.value.isInitialized
        ? widget.controller.value.aspectRatio
        : 16 / 9;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Center the video player to avoid shifting
            Center(
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
            if (_showControls) ...[
              // Top AppBar
              Positioned(
                top: 30,
                left: 10,
                right: 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Get.theme.scaffoldBackgroundColor,
                          size: 24,
                        )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.videoName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Center Play/Pause Button
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    widget.controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 60,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.controller.value.isPlaying
                          ? widget.controller.pause()
                          : widget.controller.play();
                    });
                    _startHideControlsTimer();
                  },
                ),
              ),

              // Bottom Slider
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: ValueListenableBuilder(
                  valueListenable: widget.controller,
                  builder: (context, VideoPlayerValue value, child) {
                    return SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        minThumbSeparation: 1,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 5),
                        trackShape: const RectangularSliderTrackShape(),
                      ),
                      child: Slider(
                        value: value.position.inMilliseconds
                            .clamp(0, value.duration.inMilliseconds)
                            .toDouble(),
                        min: 0,
                        max: value.duration.inMilliseconds.toDouble(),
                        onChanged: (newValue) =>
                            _seekTo(newValue / value.duration.inMilliseconds),
                        activeColor: Get.theme.primaryColor,
                        inactiveColor: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
