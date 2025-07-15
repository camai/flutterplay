class LottoNumber {
  final int value;
  final DateTime createdAt;

  LottoNumber({
    required this.value,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // 번호 범위별 색상 결정
  LottoNumberColor get colorType {
    if (value <= 10) return LottoNumberColor.yellow;
    if (value <= 20) return LottoNumberColor.blue;
    if (value <= 30) return LottoNumberColor.red;
    if (value <= 40) return LottoNumberColor.grey;
    return LottoNumberColor.green;
  }
}

enum LottoNumberColor {
  yellow,
  blue,
  red,
  grey,
  green,
}

class LottoDrawResult {
  final List<LottoNumber> numbers;
  final DateTime drawDate;
  final int drawNumber;

  LottoDrawResult({
    required this.numbers,
    required this.drawNumber,
    DateTime? drawDate,
  }) : drawDate = drawDate ?? DateTime.now();

  // 번호들을 정렬된 정수 리스트로 반환
  List<int> get sortedNumbers {
    return numbers.map((n) => n.value).toList()..sort();
  }
} 