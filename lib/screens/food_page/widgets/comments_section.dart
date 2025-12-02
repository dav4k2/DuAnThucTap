import 'package:flutter/material.dart';

class CommentsSection extends StatelessWidget {
  final double width;
  const CommentsSection({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ====== Tiêu đề ======
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Bình luận 4",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 6),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Xem tất cả bình luận",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),

        const SizedBox(height: 20),

        const CommentItem(
          name: "Jducky",
          text: "Rất ngon và dễ làm",
          avatar: "image/Ảnh1.png",
        ),

        const SizedBox(height: 20),

        const CommentItem(
          name: "Sơn Tùng - MVP",
          text: "Hơn 10 năm rồi... mà món này vẫn rất ngon!",
          avatar: "image/Ảnh2.png",
        ),

        const SizedBox(height: 20),

        const CommentItem(
          name: "J99",
          text: "Làm hơi khác trong tui nhưng rất ngon nhaa <3",
          avatar: "image/Ảnh3.png",
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}

// ======================= COMMENT ITEM FULL FIX =======================

class CommentItem extends StatefulWidget {
  final String name;
  final String text;
  final String avatar;

  const CommentItem({
    super.key,
    required this.name,
    required this.text,
    required this.avatar,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem>
    with SingleTickerProviderStateMixin {

  bool isLiked = false;
  bool showReply = false;

  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );

    // FIX CHÍNH: dùng Tween thay vì lowerBound/upperBound
    _scale = Tween<double>(begin: 0.7, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleLike() {
    setState(() => isLiked = !isLiked);
    _controller.forward(from: 0); // chạy animation từ đầu
  }

  void toggleReply() {
    setState(() => showReply = !showReply);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== AVATAR + KHUNG COMMENT ======
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.asset(
                  widget.avatar,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        widget.text,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                                  (index) => const Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "5.0",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ====== TIM + THỜI GIAN + TRẢ LỜI ======
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              children: [
                // ====== ICON TIM FIX FULL ======
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: toggleLike,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: AnimatedBuilder(
                      animation: _scale,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scale.value,
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: isLiked ? Colors.red : Colors.black.withOpacity(0.5),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                Text(
                  "3 giờ",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),

                const SizedBox(width: 18),

                GestureDetector(
                  onTap: toggleReply,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Trả lời",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ====== INPUT TRẢ LỜI ======
          if (showReply) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Nhập phản hồi...",
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}