import 'package:flutter_riverpod/flutter_riverpod.dart';

class Follower {
  final String id;
  final String name;
  final String avatarUrl;
  final int recipeCount;
  bool isFollowedByMe;
  bool isFollowingMe;

  Follower({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.recipeCount,
    this.isFollowedByMe = false,
    this.isFollowingMe = false,
  });

  // Tạo hàm copyWith để update state đúng chuẩn Riverpod
  Follower copyWith({bool? isFollowedByMe}) {
    return Follower(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      recipeCount: recipeCount,
      isFollowedByMe: isFollowedByMe ?? this.isFollowedByMe,
      isFollowingMe: isFollowingMe,
    );
  }
}

// Tạo Notifier để quản lý logic
class FollowerNotifier extends Notifier<List<Follower>> {
  @override
  List<Follower> build() {
    return [
      Follower(id: '1', name: 'Gordon Ramsay', avatarUrl: 'https://bit.ly/3L8ZfXY', recipeCount: 132, isFollowedByMe: true, isFollowingMe: true),
      Follower(id: '2', name: 'Gordon Kentucky', avatarUrl: '', recipeCount: 12, isFollowedByMe: true, isFollowingMe: false),
      Follower(id: '3', name: 'Sơn Tùng MTP', avatarUrl: '', recipeCount: 5, isFollowedByMe: false, isFollowingMe: true),
      Follower(id: '4', name: 'Người Lạ ơi', avatarUrl: '', recipeCount: 0, isFollowedByMe: false, isFollowingMe: true),
    ];
  }

  void toggleFollow(String id) {
    state = [
      for (final user in state)
        if (user.id == id)
          user.copyWith(isFollowedByMe: !user.isFollowedByMe)
        else
          user,
    ];
  }
}

// Khai báo Provider toàn cục
final followerProvider = NotifierProvider<FollowerNotifier, List<Follower>>(() {
  return FollowerNotifier();
});

// Tạo thêm 2 Provider phụ để lọc danh sách cho tiện
final followingListProvider = Provider((ref) {
  final all = ref.watch(followerProvider);
  return all.where((u) => u.isFollowedByMe).toList();
});

final followersListProvider = Provider((ref) {
  final all = ref.watch(followerProvider);
  return all.where((u) => u.isFollowingMe).toList();
});