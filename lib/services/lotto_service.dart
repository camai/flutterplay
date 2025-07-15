import 'dart:math';
import '../models/lotto_number.dart';

class LottoService {
  final Random _random = Random();
  
  // 로또 번호 6개 생성
  Future<LottoDrawResult> generateLottoNumbers({
    Duration? delay,
    int? drawNumber,
  }) async {
    // 지연 시간 추가 (UX를 위해)
    if (delay != null) {
      await Future.delayed(delay);
    }
    
    final numbers = <int>[];
    
    // 1부터 45까지 중복 없이 6개 선택
    while (numbers.length < 6) {
      final number = _random.nextInt(45) + 1;
      if (!numbers.contains(number)) {
        numbers.add(number);
      }
    }
    
    // 번호를 오름차순으로 정렬
    numbers.sort();
    
    // LottoNumber 객체들로 변환
    final lottoNumbers = numbers
        .map((value) => LottoNumber(value: value))
        .toList();
    
    return LottoDrawResult(
      numbers: lottoNumbers,
      drawNumber: drawNumber ?? 1,
    );
  }
  
  // 여러 번 추첨 (시뮬레이션)
  Future<List<LottoDrawResult>> generateMultipleDraws(int count) async {
    final results = <LottoDrawResult>[];
    
    for (int i = 0; i < count; i++) {
      final result = await generateLottoNumbers(drawNumber: i + 1);
      results.add(result);
    }
    
    return results;
  }
  
  // 번호 통계 분석
  Map<int, int> analyzeNumberFrequency(List<LottoDrawResult> history) {
    final frequency = <int, int>{};
    
    for (final result in history) {
      for (final number in result.numbers) {
        frequency[number.value] = (frequency[number.value] ?? 0) + 1;
      }
    }
    
    return frequency;
  }
} 