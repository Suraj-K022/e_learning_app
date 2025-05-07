import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../customWidgets/customtext.dart';
import '../../../../../../utils/images.dart';
import '../../../../../Student/Student_Dashboard/StudentHome/PdfDetailScreen/pdf_detail_screen.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String pdfPath;
  final String imagePath;
  final String pdfName;
  final String discription;
  final String videoUrl;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.pdfPath,
    required this.pdfName,
    required this.discription, required this.imagePath,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
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
        if (!_hasStarted) {
          _hasStarted = true;
        }
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return "00:00";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: Get.theme.secondaryHeaderColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        children: [
          // Video Player
          Stack(
            alignment: Alignment.center,
            children: [
              _controller.value.isInitialized
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: _hasStarted
                        ? VideoPlayer(_controller)
                        : Container(child: Image.asset(Images.videoThumbnail,fit: BoxFit.cover,),),
                  ),
                ),
              )
                  : Center(
                child: CircularProgressIndicator(
                    color: Get.theme.primaryColor),
              ),

              // Play/Pause Button
              if (_controller.value.isInitialized)
                Positioned(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: AnimatedOpacity(
                      opacity: _isPlaying ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
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

              if (_hasStarted) ...[
                // Mute Toggle
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      _isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _toggleMute,
                  ),
                ),

                // Duration Labels
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
            ],
          ),

          const SizedBox(height: 16),

          // Poppins(
          //   text: "Video Source: ${Uri.parse(widget.videoUrl).host}",
          //   fontSize: 14,
          //   color: Get.theme.hintColor,
          //   maxLines: 3,
          // ),

          const SizedBox(height: 24),

          // PDF Tile
          ListTile(
            onTap: () {
              Get.to(() => PdfDetailScreen(
                title: widget.pdfName,
                description: widget.discription,
                pdfPath: widget.pdfPath,
              ));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
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

          const SizedBox(height: 8),

          // Poppins(
          //   text: "File Path: ${widget.pdfPath}",
          //   fontSize: 13,
          //   color: Get.theme.hintColor,
          //   maxLines: 2,
          // ),
        ],
      ),
    );
  }
}
