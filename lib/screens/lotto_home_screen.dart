import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/lotto_viewmodel.dart';
import '../widgets/modules/lotto_module.dart';
import '../widgets/layouts/responsive_layout.dart';
import '../theme/app_theme.dart';

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
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ResponsivePadding(
        child: Column(
          children: [
            // 번호 표시 모듈
            LottoNumberDisplayModule(
              animation: _animation,
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // 추첨 버튼 모듈
            LottoDrawButtonModule(
              onAnimationStart: () {
                _animationController.reset();
                _animationController.forward();
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // 히스토리 모듈
            const Expanded(
              child: LottoHistoryModule(),
            ),
          ],
        ),
      ),
    );
  }
} 