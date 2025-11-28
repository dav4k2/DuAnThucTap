import 'package:flutter/material.dart';

class StepsSection extends StatelessWidget {
  final double width;
  const StepsSection({super.key, required this.width});

  final steps = const [
    {
      "number": 1,
      "text": "Hành mùi rửa sạch thái nhỏ, xương bò rửa sạch rồi cho vào nồi...",
      "image": "image/p1.png"
    },
    {
      "number": 2,
      "text": "Thêm nước vào nồi, đun đến khi sôi thì vớt bọt...",
      "image": "image/p2.png"
    },
    {
      "number": 3,
      "text":
      "Cho bánh phở vào bát, thêm hành mùi vào, nhúng thịt bò vào nước sôi...",
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
          child: Text("Cách làm:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20),
        ...steps.map((s) => _StepItem(
          number: s["number"] as int,
          text: s["text"] as String,
          image: s["image"] as String,
        )),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  final int number;
  final String text;
  final String image;

  const _StepItem(
      {required this.number, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$number',
              style:
              const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Text(text,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.7),
                        height: 1.4)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,                     // ✔ asset
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
