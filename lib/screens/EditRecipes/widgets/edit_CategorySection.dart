import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../NewRecipes/logic/add_recipe_provider.dart';
import '../logic/edit_recipe_provider.dart';


class EditCategorySection extends ConsumerStatefulWidget {
  const EditCategorySection({Key? key}) : super(key: key);

  @override
  ConsumerState<EditCategorySection> createState() => _EditCategorySectionState();
}

class _EditCategorySectionState extends ConsumerState<EditCategorySection> {
  bool isExpanded = true;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editRecipeProvider);
    final notifier = ref.read(editRecipeProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Lọc danh sách tag theo từ khóa tìm kiếm
    final filteredCategories = notifier.allCategories
        .where((c) => c.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Danh mục', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              children: [
                // Header: Các Tag đã chọn + Nút mũi tên
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: state.selectedCategories.map((tag) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB901),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(tag, style: TextStyle(color: Colors.white, fontSize: 13.sp)),
                              SizedBox(width: 4.w),
                              GestureDetector(
                                onTap: () => notifier.toggleCategory(tag),
                                child: Icon(Icons.close, size: 14.sp, color: Colors.white),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                      onPressed: () => setState(() => isExpanded = !isExpanded),
                    )
                  ],
                ),

                if (isExpanded) ...[
                  SizedBox(height: 12.h),
                  // Ô nhập từ khóa
                  TextField(
                    onChanged: (val) => setState(() => searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Nhập từ khóa...',
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Grid danh sách tag
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 40.h,
                      mainAxisSpacing: 8.h,
                    ),
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      final isSelected = state.selectedCategories.contains(category);
                      return GestureDetector(
                        onTap: () => notifier.toggleCategory(category),
                        child: Row(
                          children: [
                            Container(
                              width: 18.w,
                              height: 18.w,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFFFB901) : Colors.transparent,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(child: Text(category, style: TextStyle(fontSize: 13.sp), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}