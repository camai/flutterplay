import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/lotto_viewmodel.dart';
import '../../widgets/lotto_number_ball.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_card.dart';
import '../../theme/app_theme.dart';

// 로또 번호 표시 모듈
class LottoNumberDisplayModule extends StatelessWidget {
  final bool showAnimation;
  final Animation<double>? animation;

  const LottoNumberDisplayModule({
    super.key,
    this.showAnimation = false,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LottoViewModel>(
      builder: (context, viewModel, child) {
        return CustomCard(
          backgroundColor: AppTheme.lightColorScheme.primaryContainer,
          child: Column(
            children: [
              Text(
                '이번 주 행운의 번호',
                style: AppTheme.titleLarge.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (viewModel.isGenerating)
                const LoadingCard(message: '번호 생성 중...')
              else if (viewModel.currentNumbers.isEmpty)
                Text(
                  '추첨 버튼을 눌러주세요!',
                  style: AppTheme.bodyLarge.copyWith(
                    color: Colors.grey.shade600,
                  ),
                )
              else
                LottoNumberBallRow(
                  numbers: viewModel.currentNumbers,
                  animation: animation,
                ),
            ],
          ),
        );
      },
    );
  }
}

// 로또 추첨 버튼 모듈
class LottoDrawButtonModule extends StatelessWidget {
  final VoidCallback? onAnimationStart;

  const LottoDrawButtonModule({
    super.key,
    this.onAnimationStart,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LottoViewModel>(
      builder: (context, viewModel, child) {
        return PrimaryButton(
          text: viewModel.isGenerating ? '추첨 중...' : '번호 추첨하기',
          onPressed: viewModel.isGenerating ? null : () async {
            await viewModel.generateNumbers();
            onAnimationStart?.call();
          },
          isLoading: viewModel.isGenerating,
        );
      },
    );
  }
}

// 로또 히스토리 모듈
class LottoHistoryModule extends StatelessWidget {
  const LottoHistoryModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LottoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.history.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 추첨 번호',
                  style: AppTheme.titleLarge,
                ),
                SecondaryButton(
                  text: '초기화',
                  onPressed: () => viewModel.clearHistory(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.history.length,
                itemBuilder: (context, index) {
                  final reversedIndex = viewModel.history.length - 1 - index;
                  final result = viewModel.history[reversedIndex];
                  
                  return InfoCard(
                    title: '${result.drawNumber}회차',
                    leading: LottoNumberBallRow(
                      numbers: result.numbers,
                      ballSize: 30,
                      spacing: 5,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// 통계 모듈
class LottoStatsModule extends StatelessWidget {
  const LottoStatsModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LottoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.history.isEmpty) {
          return const SizedBox.shrink();
        }

        final frequency = viewModel.getNumberFrequency();
        final mostFrequent = viewModel.getMostFrequentNumbers();
        final leastFrequent = viewModel.getLeastFrequentNumbers();

        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '번호 통계',
                style: AppTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildStatSection('가장 많이 나온 번호', mostFrequent),
              const SizedBox(height: AppSpacing.sm),
              _buildStatSection('가장 적게 나온 번호', leastFrequent),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatSection(String title, List<int> numbers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: numbers.map((number) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                number.toString(),
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
} 