
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/PdfDetailScreen/pdf_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import '../../../../../../customWidgets/customtext.dart';
import '../../../../../../utils/images.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String pdfPath;
  final String pdfName;
  final String discription;

  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl, required this.pdfPath, required this.pdfName, required this.discription});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {}); // Update UI after initialization
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
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

  // void _openPdf() {
  //   if (File(widget.pdfPath).existsSync()) {
  //     OpenFilex.open(widget.pdfPath);
  //   } else {
  //     Get.snackbar("Error", "PDF file not found", backgroundColor: Colors.red, colorText: Colors.white);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new, size: 24, color: Get.theme.secondaryHeaderColor),
        ),
        backgroundColor: Get.theme.scaffoldBackgroundColor,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        children: [
          // Video Container
          Container(
            height: Get.height / 2,
            decoration: BoxDecoration(
              border: Border.all(color: Get.theme.hintColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    :  Center(child: CircularProgressIndicator(color: Get.theme.primaryColor)),

                // Play/Pause Overlay
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      color: Colors.black26,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 30,
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),

                // Video Duration Labels
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Text(
                    _formatDuration(_controller.value.position),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 20,
                  child: Text(
                    _formatDuration(_controller.value.duration),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                // Progress Bar
                Positioned(
                  bottom: 20,
                  left: 50,
                  right: 50,
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.red,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8,),
          Poppins(text: widget.videoUrl,maxLines: 3,),


          SizedBox(height: 20),

          // PDF Button
          ListTile(
            onTap: (){Get.to(PdfDetailScreen(title: widget.pdfName, description:widget.discription, pdfPath: widget.pdfPath));},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            tileColor: Get.theme.cardColor,
            leading: Image.asset(
              Images.i5,
              color: Get.theme.secondaryHeaderColor,
              width: 24,
              height: 24,
            ),
            title: Poppins(
              text: 'View PDF',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Get.theme.secondaryHeaderColor,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Get.theme.secondaryHeaderColor,
            ),
          ),
          SizedBox(height: 8,),
          Poppins(text: widget.pdfPath,maxLines: 3,)
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return "00:00";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
