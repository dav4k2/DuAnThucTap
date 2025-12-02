import 'package:flutter/material.dart';

class StepsSection extends StatelessWidget {
  final double width;
  const StepsSection({super.key, required this.width});

  final steps = const [
    {
      "number": 1,
      "text":
      "Hành mùi rửa sạch thái nhỏ, xương bò rửa sạch rồi cho vào nồi, thịt bò thái mỏng, giá đỗ rửa sạch để ráo nước",
      "image": "image/p1.png"
    },
    {
      "number": 2,
      "text":
      "Thêm nước vào nồi, đun đến khi sôi thì vớt hết bọt, thêm gói vị phở rồi ninh 30p",
      "image": "image/p2.png"
    },
    {
      "number": 3,
      "text":
      "Cho bánh phở vào bát, thêm hành mùi vào, nhúng thịt bò vào nước sôi cho chín tái, bày ra bát, sau đó chan nước dùng nóng lên rồi thưởng thức",
      "image": "image/p3.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Cách làm :",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),

        ...steps.map((s) => _StepItem(
          number: s["number"] as int,
          text: s["text"] as String,
          image: s["image"] as String,
        )),

        const SizedBox(height: 20),

        // ---------------------
        // BUTTON "Thực hiện món ăn"
        // ---------------------
        Center(
          child: GestureDetector(
            onTap: () {
              // TODO: xử lý khi nhấn nút
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F), // vàng giống ảnh
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Text(
                "Thực hiện món ăn",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  final int number;
  final String text;
  final String image;

  const _StepItem({
    required this.number,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Số + line xanh nằm ngang ---
          Row(
            children: [
              Text(
                '$number',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 3,
                height: 50,
                color: Colors.green,
              ),
            ],
          ),

          const SizedBox(width: 16),

          // --- Nội dung + ảnh ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.75),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),

                ////// ẢNH VUÔNG
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
