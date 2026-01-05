// lib/features/user_guide/data/manual_guide_data.dart
import 'package:easy_localization/easy_localization.dart';

import '../model/guide_model.dart';

final List<GuideStep> manualGuideSteps = [
  GuideStep(
    title: "Bước 1: Thêm ảnh".tr(),
    content: "Thêm ảnh về món ăn của bạn bằng cách nhấn vào ô trống và chọn ảnh từ thư viện".tr(),
    mediaPath: "video/add_picture.mp4",
    mediaType: MediaType.video,
  ),
  GuideStep(
    title: "Bước 2: Thêm video".tr(),
    content: "Thêm video ngắn giới thiệu về món ăn của bạn".tr(),
    mediaPath: "video/add_video.mp4",
    mediaType: MediaType.video,
  ),
  GuideStep(
    title: "Bước 3: Thêm tên và mô tả ".tr(),
    content: "Thêm tên và mô tả về món ăn của bạn, mô tả chi tiết sẽ giúp mọi người hiểu thêm về món ăn của bạn".tr(),
    mediaPath: "video/add_name.mp4",
    mediaType: MediaType.video,
  ),
  GuideStep(
    title: "Bước 4: Phân loại món ăn".tr(),
    content: "Phân loại món ăn của bạn, việc phân loại chính xác sẽ giúp mọi người tìm kiếm công thức phù hợp với họ".tr(),
    mediaPath: "video/filter.mp4",
    mediaType: MediaType.video,
  ),
  GuideStep(
    title: "Bước 5: Tehm nguyên liệu".tr(),
    content: "Thêm những nguyên liệu cần chuẩn bị để làm món ăn của bạn".tr(),
    mediaPath: "video/add_ingredient.mp4",
    mediaType: MediaType.video,
  ),
  GuideStep(
    title: "Bước 6: Thêm các bước nấu".tr(),
    content: "Thêm từng bước nấu món ăn của bạn, tại mỗi bước bạn có thể chèn ảnh hoặc video hướng dẫn thực hiện".tr(),
    mediaPath: "video/add_cooking_step.mp4",
    mediaType: MediaType.video,
  ),
  GuideStep(
    title: "Bước 7: Lưu bản nháp".tr(),
    content: "Nếu bạn không thể hoàn thiện công thức nấu ngay lúc này, hãy lưu lại tiến trình và tiếp tục sau".tr(),
    mediaPath: "video/add_draft.mp4",
    mediaType: MediaType.video,
  ),
  GuideStep(
    title: "Bước 8: Đăng công thức".tr(),
    content: "Nếu bạn đã hoàn thiện công thức ấn nút đăng và chờ công thức được tải lên với mọi người nhé".tr(),
    mediaPath: "video/done.mp4",
    mediaType: MediaType.video,
  ),
];