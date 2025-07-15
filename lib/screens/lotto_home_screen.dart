import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/lotto_viewmodel.dart';
import '../widgets/lotto_number_ball.dart';

class LottoHomeScreen extends StatefulWidget {
  const LottoHomeScreen({super.key});

  @override
  State<LottoHomeScreen> createState() => _LottoHomeScreenState();
}

class _LottoHomeScreenState extends State<LottoHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로또 번호 추첨기'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<LottoViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                _buildCurrentNumberDisplay(viewModel),
                const SizedBox(height: 30),
                _buildDrawButton(viewModel),
                const SizedBox(height: 30),
                _buildHistorySection(viewModel),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentNumberDisplay(LottoViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          const Text(
            '이번 주 행운의 번호',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          if (viewModel.isGenerating)
            const CircularProgressIndicator()
          else if (viewModel.currentNumbers.isEmpty)
            const Text(
              '추첨 버튼을 눌러주세요!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            )
          else
            LottoNumberBallRow(
              numbers: viewModel.currentNumbers,
              animation: _animation,
            ),
        ],
      ),
    );
  }

  Widget _buildDrawButton(LottoViewModel viewModel) {
    return ElevatedButton(
      onPressed: viewModel.isGenerating ? null : () async {
        await viewModel.generateNumbers();
        _animationController.reset();
        _animationController.forward();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        viewModel.isGenerating ? '추첨 중...' : '번호 추첨하기',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildHistorySection(LottoViewModel viewModel) {
    if (viewModel.history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '최근 추첨 번호',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => viewModel.clearHistory(),
                child: const Text('초기화'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.history.length,
              itemBuilder: (context, index) {
                final reversedIndex = viewModel.history.length - 1 - index;
                final result = viewModel.history[reversedIndex];
                
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Text(
                          '${result.drawNumber}회차',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: LottoNumberBallRow(
                            numbers: result.numbers,
                            ballSize: 30,
                            spacing: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 