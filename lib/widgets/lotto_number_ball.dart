import 'package:flutter/material.dart';
import '../models/lotto_number.dart';

class LottoNumberBall extends StatelessWidget {
  final LottoNumber number;
  final double size;
  final bool isAnimated;
  final Animation<double>? animation;

  const LottoNumberBall({
    super.key,
    required this.number,
    this.size = 50,
    this.isAnimated = false,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    Widget ball = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getColor(number.colorType),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          number.value.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.36, // 비율로 폰트 사이즈 조정
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (isAnimated && animation != null) {
      return AnimatedBuilder(
        animation: animation!,
        builder: (context, child) {
          return Transform.scale(
            scale: animation!.value,
            child: ball,
          );
        },
      );
    }

    return ball;
  }

  Color _getColor(LottoNumberColor colorType) {
    switch (colorType) {
      case LottoNumberColor.yellow:
        return Colors.yellow.shade700;
      case LottoNumberColor.blue:
        return Colors.blue.shade700;
      case LottoNumberColor.red:
        return Colors.red.shade700;
      case LottoNumberColor.grey:
        return Colors.grey.shade700;
      case LottoNumberColor.green:
        return Colors.green.shade700;
    }
  }
}

class LottoNumberBallRow extends StatelessWidget {
  final List<LottoNumber> numbers;
  final double ballSize;
  final double spacing;
  final Animation<double>? animation;

  const LottoNumberBallRow({
    super.key,
    required this.numbers,
    this.ballSize = 50,
    this.spacing = 10,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      children: numbers.map((number) {
        return LottoNumberBall(
          number: number,
          size: ballSize,
          isAnimated: animation != null,
          animation: animation,
        );
      }).toList(),
    );
  }
} 