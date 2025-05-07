import 'package:e_learning_app/customWidgets/customtext.dart';
import 'package:e_learning_app/customWidgets/pdf_card_widget.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/PdfDetailScreen/pdf_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CourseDetailScreen extends StatefulWidget {
  final String title;
  final String imgUrl;
  final String videoUrl;
  final String pdfUrl;
  final String description;

  const CourseDetailScreen({
    Key? key,
    required this.title,
    required this.imgUrl,
    required this.videoUrl,
    required this.pdfUrl,
    required this.description,
  }) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoPlaying = false;

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,                      // Automatically start playing the video
      looping: true,                       // Loop the video once it finishes
      fullScreenByDefault: false,          // Start the video in normal mode, not full-screen
      allowPlaybackSpeedChanging: true,    // Allow the user to change playback speed
      showControls: true,                  // Show controls (play, pause, etc.)
      showControlsOnInitialize: false,     // Don't show controls immediately after initializing
      customControls: CustomChewieControls(),               // Use default controls, not custom ones
      allowFullScreen: true,               // Allow full-screen mode
      allowMuting: true,
      materialProgressColors: ChewieProgressColors(playedColor: Get.theme.primaryColor,backgroundColor: Get.theme.scaffoldBackgroundColor,),
        showOptions: false,

        // Allow video quality change
    );


    setState(() {});
  }

  void _onPlayPressed() async {
    setState(() {
      _isVideoPlaying = true;
    });
    await _initializePlayer();
  }

  @override
  void dispose() {
    if (_isVideoPlaying) {
      _videoPlayerController.dispose();
      _chewieController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 24,
            color: Get.theme.secondaryHeaderColor,
          ),
        ),
        title: Poppins(
          text: widget.title,
          color: Get.theme.secondaryHeaderColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Poppins(
              text: "Watch Video Lecture",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Get.theme.secondaryHeaderColor,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _isVideoPlaying
                    ? (_chewieController != null &&
                    _chewieController!
                        .videoPlayerController.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _chewieController!.videoPlayerController.value.aspectRatio,
                  child: Chewie(controller: _chewieController!),
                )
                    : const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ))
                    : Stack(
                  fit: StackFit.expand,
                  children: [

                    Image.network(
                      widget.imgUrl,
                      fit: BoxFit.cover,
                    ),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
                        onPressed: _onPlayPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Poppins(
              text: "View Pdf",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Get.theme.secondaryHeaderColor,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                Get.to(() => PdfDetailScreen(
                  title: widget.title,
                  description: widget.description,
                  pdfPath: widget.pdfUrl,
                ));
              },
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: PdfCard(
                  title: widget.title,
                  description: widget.description,
                  imgUrl: widget.imgUrl,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
class CustomChewieControls extends MaterialControls {
  const CustomChewieControls({super.key});

  @override
  Widget buildProgressBar(BuildContext context, ChewieController chewieController, VideoPlayerController controller) {
    return VideoProgressIndicator(
      controller,
      allowScrubbing: true,
      colors: VideoProgressColors(
        playedColor:Get.theme.primaryColor, // <-- Change this to your desired timer bar color
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white70,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }
}