import 'package:flutter/foundation.dart';
import '../models/lotto_number.dart';
import '../services/lotto_service.dart';

class LottoViewModel extends ChangeNotifier {
  final LottoService _lottoService = LottoService();
  
  // 상태 관리
  LottoDrawResult? _currentResult;
  final List<LottoDrawResult> _history = [];
  bool _isGenerating = false;
  int _currentDrawNumber = 1;
  
  // Getters
  LottoDrawResult? get currentResult => _currentResult;
  List<LottoDrawResult> get history => List.unmodifiable(_history);
  bool get isGenerating => _isGenerating;
  int get currentDrawNumber => _currentDrawNumber;
  
  // 현재 번호들 (UI 편의용)
  List<LottoNumber> get currentNumbers => _currentResult?.numbers ?? [];
  
  // 번호 생성
  Future<void> generateNumbers() async {
    if (_isGenerating) return;
    
    _isGenerating = true;
    _currentResult = null;
    notifyListeners();
    
    try {
      final result = await _lottoService.generateLottoNumbers(
        delay: const Duration(milliseconds: 500),
        drawNumber: _currentDrawNumber,
      );
      
      _currentResult = result;
      _addToHistory(result);
      _currentDrawNumber++;
      
    } catch (e) {
      debugPrint('번호 생성 실패: $e');
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }
  
  // 히스토리 관리
  void _addToHistory(LottoDrawResult result) {
    _history.add(result);
    
    // 최대 10개까지만 저장
    if (_history.length > 10) {
      _history.removeAt(0);
    }
  }
  
  // 히스토리 초기화
  void clearHistory() {
    _history.clear();
    _currentDrawNumber = 1;
    notifyListeners();
  }
  
  // 번호 통계 분석
  Map<int, int> getNumberFrequency() {
    return _lottoService.analyzeNumberFrequency(_history);
  }
  
  // 가장 많이 나온 번호들 (상위 6개)
  List<int> getMostFrequentNumbers() {
    final frequency = getNumberFrequency();
    final sorted = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(6).map((e) => e.key).toList();
  }
  
  // 가장 적게 나온 번호들 (하위 6개)
  List<int> getLeastFrequentNumbers() {
    final frequency = getNumberFrequency();
    final sorted = frequency.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    
    return sorted.take(6).map((e) => e.key).toList();
  }
} 