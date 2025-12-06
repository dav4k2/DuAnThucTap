// lib/features/user_guide/model/guide_model.dart

enum MediaType { image, video }

class GuideStep {
  final String title;
  final String content;
  final String mediaPath;
  final MediaType mediaType;

  GuideStep({
    required this.title,
    required this.content,
    required this.mediaPath,
    this.mediaType = MediaType.image,
  });
}