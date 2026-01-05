import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Giả sử các file này tồn tại và cần thiết cho Recipe và MealTab
import '../../User_profile/logic/chef_provider.dart';


enum RecipeStatus { pending, rejected }

class RecipeWithStatus {
  final Recipe recipe;
  final RecipeStatus status;
  RecipeWithStatus({required this.recipe, required this.status});
}

class MyPendingRecipesList extends ConsumerWidget {
  const MyPendingRecipesList({super.key});

  static final List<RecipeWithStatus> sampleData = [
    RecipeWithStatus(
      recipe:  Recipe(
        title: "Gà rán KFC",
        time: "30 phút",
        difficulty: "Dễ",
        author: "Kong Fuong",
        rating: 0,
        reviews: 0,
        meal: MealTab.tatCa,
        imageAsset: "image/garan.png",
      ),
      status: RecipeStatus.pending,
    ),
    RecipeWithStatus(
      recipe:  Recipe(
        title: "Bánh cuốn thanh trì nhân tôm khô",
        time: "45 phút",
        difficulty: "Khó",
        author: "Kong Fuong",
        rating: 0,
        reviews: 0,
        meal: MealTab.buaSang,
        imageAsset: "image/profile_bg.png",
      ),
      status: RecipeStatus.rejected,
    ),
    RecipeWithStatus(
      recipe:  Recipe(
        title: "Sinh tố bơ dừa hạt chia",
        time: "10 phút",
        difficulty: "Dễ",
        author: "Kong Fuong",
        rating: 0,
        reviews: 0,
        meal: MealTab.anVat,
        imageAsset: "image/profile_bg.png",
      ),
      status: RecipeStatus.pending,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<RecipeWithStatus> pendingList = sampleData;

    if (pendingList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 100.h),
          child: Column(
            children: [
              Icon(Icons.hourglass_empty, size: 64.sp, color: Colors.grey),
              SizedBox(height: 16.h),
              Text(
                "Chưa có công thức nào chờ duyệt",
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 8.h),
              Text(
                "Khi bạn gửi công thức, nó sẽ hiện ở đây",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: pendingList.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return MyPendingRecipeItem(item: pendingList[index]);
      },
    );
  }
}

// ---------------- ITEM (Đã sửa đổi) ----------------
class MyPendingRecipeItem extends StatelessWidget {
  final RecipeWithStatus item;
  const MyPendingRecipeItem({super.key, required this.item});

  // Chiều cao của ảnh
  static const double _imageHeight = 180; // Tăng chiều cao ảnh lên 150
  // Chiều cao của thanh LiquidGlass chứa Tên món
  static const double _titleBarHeight = 20;
  // Chiều cao của thanh LiquidGlass chứa thông tin
  static const double _infoBarHeight = 30;
  // Độ mờ
  static const double _blurSigma = 10.0;

  // Tổng chiều cao của LiquidGlass bar
  double get _totalLiquidHeight => _titleBarHeight + _infoBarHeight;

  @override
  Widget build(BuildContext context) {
    final recipe = item.recipe;
    final isPending = item.status == RecipeStatus.pending;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.r),
      ),
      // Bỏ Column bọc ngoài vì không còn phần trắng dưới ảnh
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12.r),
        // Toàn bộ nội dung là Stack chứa Ảnh và 2 thanh LiquidGlass
        child: SizedBox(
          height: _imageHeight.h,
          width: double.infinity,
          child: Stack(
            children: [
              // 1. Ảnh FULL WIDTH (Nền)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.r), // Bo góc Card
                  child: Image.asset(
                    recipe.imageAsset,
                    width: double.infinity,
                    height: _imageHeight.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: _imageHeight.h,
                      color: Colors.grey[300],
                      child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
              ),

              // 2. LỚP PHỦ MỜ (Blur Layer)
              // 2. LỚP PHỦ MỜ (Blur Layer)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: _totalLiquidHeight.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _blurSigma,
                      sigmaY: _blurSigma,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.35),
                    ),
                  ),
                ),
              ),


              // 3. NỘI DUNG THANH LIQUIDGLASS (Content)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: _totalLiquidHeight.h, // Tổng chiều cao 2 thanh
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // THANH TÊN MÓN (Title Bar)
                      SizedBox(
                        height: _titleBarHeight.h,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            recipe.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              shadows: _textShadow(),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      // Dải phân cách mỏng
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.5),
                      ),

                      // THANH THÔNG TIN (Info Bar)
                      SizedBox(
                        height: _infoBarHeight.h - 1, // trừ đi độ dày Divider
                        child: Row(
                          children: [
                            // phút
                            const Icon(Icons.access_time, size: 16, color: Colors.white),
                            SizedBox(width: 4.w),
                            Text(recipe.time, style: _liquidInfoStyle()),
                            SizedBox(width: 12.w),
                            // độ khó
                            const Icon(Icons.flag_outlined, size: 16, color: Colors.white),
                            SizedBox(width: 4.w),
                            Text(recipe.difficulty, style: _liquidInfoStyle()),
                            const Spacer(),
                            // trạng thái
                            _RecipeStatusChip(isPending: isPending, isLiquid: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bóng mờ cho chữ trên nền LiquidGlass
  List<Shadow> _textShadow() {
    return [
      Shadow(
        blurRadius: 2.0,
        color: Colors.black.withOpacity(0.8),
      ),
    ];
  }

  TextStyle _liquidInfoStyle() {
    // Style cho thông tin trên thanh LiquidGlass
    return TextStyle(
      color: Colors.white,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
      shadows: _textShadow(),
    );
  }
}

class _RecipeStatusChip extends StatelessWidget {
  final bool isPending;
  final bool isLiquid;
  const _RecipeStatusChip({required this.isPending, this.isLiquid = false});

  @override
  Widget build(BuildContext context) {
    final text = isPending ? "Chờ duyệt" : "Từ chối";
    final icon = isPending ? Icons.access_time : Icons.cancel;

    // Màu theo yêu cầu: Vàng cho Chờ duyệt, Đỏ cho Từ chối
    final color = isPending ? Colors.yellow.shade400 : Colors.red.shade400;

    // Style cho LiquidGlass: nền transparent, border và chữ theo màu trạng thái
    final bgLiquid = color.withOpacity(0.1);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgLiquid,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.8), width: 0.6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 13.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              // Thêm bóng cho chữ LiquidGlass
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}