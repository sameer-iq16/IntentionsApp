import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ContentDetailScreen extends StatefulWidget {
  final SupportingContentModel content;

  const ContentDetailScreen({super.key, required this.content});

  @override
  State<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
  bool _isPlaying = false;
  double _playbackProgress = 0.35;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isSaved = appState.isContentSaved(widget.content.id);

    return Scaffold(
      backgroundColor: AppColors.canvasBody,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.content.type == ContentType.text
              ? "Article Reflection"
              : widget.content.type == ContentType.video
                  ? "Video Masterclass"
                  : "Audio Meditation",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? AppColors.primaryContainer : AppColors.secondary,
            ),
            onPressed: () {
              appState.toggleSaveContent(widget.content.id);
              CustomPillToast.show(
                context,
                isSaved ? "Removed from Saved" : "Content saved",
                icon: isSaved ? Icons.bookmark_remove : Icons.bookmark_added,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.secondary),
            onPressed: () {
              CustomPillToast.show(context, "Content link copied to share");
            },
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Media Header Preview (Video Player / Audio Waveform / Image)
              _buildMediaHeader(context),
              const SizedBox(height: 16),

              // Title and Metadata
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.content.type == ContentType.text
                          ? AppColors.secondaryContainer
                          : widget.content.type == ContentType.video
                              ? AppColors.roseBg
                              : AppColors.lavenderBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.content.type.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: widget.content.type == ContentType.text
                            ? AppColors.onSecondaryContainer
                            : widget.content.type == ContentType.video
                                ? AppColors.roseIcon
                                : AppColors.lavenderIcon,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.content.durationDisplay,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    "By ${widget.content.author}",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Text(
                widget.content.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                      height: 1.25,
                    ),
              ),
              const SizedBox(height: 8),

              // Summary Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceContainerHigh),
                ),
                child: Text(
                  widget.content.summary,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.onSurface,
                      ),
                ),
              ),
              const SizedBox(height: 18),

              // Full Content Body
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Text(
                  widget.content.fullContent,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.7,
                        color: AppColors.onSurface,
                      ),
                ),
              ),
              const SizedBox(height: 20),

              // Bottom Completion Dock
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Finished reflecting?", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        Text("Keep this intention in your daily awareness", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      onPressed: () {
                        CustomPillToast.show(context, "Completed reflection saved!", icon: Icons.check_circle);
                        Navigator.pop(context);
                      },
                      child: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaHeader(BuildContext context) {
    if (widget.content.type == ContentType.video) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.cardShadow,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.content.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black45,
              ),
            ),
            IconButton(
              iconSize: 56,
              icon: Icon(
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() => _isPlaying = !_isPlaying);
                CustomPillToast.show(
                  context,
                  _isPlaying ? "Playing video..." : "Paused video",
                  icon: _isPlaying ? Icons.play_arrow : Icons.pause,
                );
              },
            ),
            Positioned(
              bottom: 12,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  const Text("02:45", style: TextStyle(color: Colors.white, fontSize: 11)),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        trackHeight: 3,
                        activeTrackColor: AppColors.secondaryContainer,
                        inactiveTrackColor: Colors.white30,
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        value: _playbackProgress,
                        onChanged: (val) => setState(() => _playbackProgress = val),
                      ),
                    ),
                  ),
                  const Text("08:00", style: TextStyle(color: Colors.white, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (widget.content.type == ContentType.audio) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.lavenderBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.headphones, color: AppColors.lavenderIcon, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Spiritual Audio Guide", style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      Text(widget.content.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                ),
                IconButton(
                  iconSize: 42,
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    color: AppColors.primaryContainer,
                  ),
                  onPressed: () {
                    setState(() => _isPlaying = !_isPlaying);
                    CustomPillToast.show(
                      context,
                      _isPlaying ? "Audio playing..." : "Audio paused",
                      icon: _isPlaying ? Icons.play_arrow : Icons.pause,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 4,
                activeTrackColor: AppColors.primaryContainer,
                inactiveTrackColor: AppColors.surfaceContainer,
                thumbColor: AppColors.primaryContainer,
              ),
              child: Slider(
                value: _playbackProgress,
                onChanged: (val) => setState(() => _playbackProgress = val),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("02:10", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                Text("06:00", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ],
        ),
      );
    } else {
      // Text Cover image
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 160,
          width: double.infinity,
          color: AppColors.secondaryContainer,
          child: Image.network(
            widget.content.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const Center(
              child: Icon(Icons.menu_book, size: 48, color: AppColors.secondary),
            ),
          ),
        ),
      );
    }
  }
}
