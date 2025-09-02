
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../design_system/app_design_system.dart';
import '../viewmodels/calculator_viewmodel.dart';

typedef ButtonCallback = void Function(String key);

class Calculator extends StatelessWidget {
  const Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalculatorViewModel(),
      child: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalculatorViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('계산기'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // 디스플레이 영역
            Flexible(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: AppColors.onSurfaceVariant.withOpacity(0.12),
                    width: 1,
                  ),
                  boxShadow: AppShadows.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (viewModel.operator.isNotEmpty && !viewModel.waitingForOperand)
                      Text(
                        '${viewModel.operand1.toString()} ${viewModel.operator}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    const Spacer(),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomRight,
                      child: Text(
                        viewModel.display,
                        style: AppTypography.displaySmall.copyWith(
                          color: viewModel.hasError ? AppColors.error : AppColors.onSurface,
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // 버튼 그리드
            Flexible(
              flex: 2,
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                children: [
                  // 첫 번째 행
                  _CalculatorButton('AC', viewModel.onButtonPressed, type: CalculatorButtonType.function),
                  _CalculatorButton('C', viewModel.onButtonPressed, type: CalculatorButtonType.function),
                  _CalculatorButton('.', viewModel.onButtonPressed, type: CalculatorButtonType.number),
                  _CalculatorButton('/', viewModel.onButtonPressed, type: CalculatorButtonType.operator),
                  
                  // 숫자 행들
                  _CalculatorButton('7', viewModel.onButtonPressed, type: CalculatorButtonType.number),
                  _CalculatorButton('8', viewModel.onButtonPressed, type: CalculatorButtonType.number),
                  _CalculatorButton('9', viewModel.onButtonPressed, type: CalculatorButtonType.number),
                  _CalculatorButton('*', viewModel.onButtonPressed, type: CalculatorButtonType.operator),
                  
                  _CalculatorButton('4', viewModel.onButtonPressed, type: CalculatorButtonType.number),
                  _CalculatorButton('5', viewModel.onButtonPressed, type: CalculatorButtonType.number),
                  _CalculatorButton('6', viewModel.onButtonPressed, type: CalculatorButtonType.number),
                  _CalculatorButton('-', viewModel.onButtonPressed, type: CalculatorButtonType.operator),
                  
                  _CalculatorButton('1', viewModel.onButtonPressed, type: CalculatorButtonType.number),
                  _CalculatorButton('2', viewModel.onButtonPressed, type: CalculatorButtonType.number),
                  _CalculatorButton('3', viewModel.onButtonPressed, type: CalculatorButtonType.number),
                  _CalculatorButton('+', viewModel.onButtonPressed, type: CalculatorButtonType.operator),
                  
                  // 마지막 행
                  _CalculatorButton('0', viewModel.onButtonPressed, type: CalculatorButtonType.number),
                  Container(), // 빈 공간
                  Container(), // 빈 공간 
                  _CalculatorButton('=', viewModel.onButtonPressed, type: CalculatorButtonType.equals),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum CalculatorButtonType { number, operator, function, equals }

class _CalculatorButton extends StatelessWidget {
  final String label;
  final ButtonCallback onPressed;
  final CalculatorButtonType type;

  const _CalculatorButton(
    this.label,
    this.onPressed, {
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    
    switch (type) {
      case CalculatorButtonType.number:
        backgroundColor = AppColors.surface;
        foregroundColor = AppColors.onSurface;
        break;
      case CalculatorButtonType.operator:
        backgroundColor = AppColors.secondary;
        foregroundColor = AppColors.onSecondary;
        break;
      case CalculatorButtonType.function:
        backgroundColor = AppColors.secondaryContainer;
        foregroundColor = AppColors.onSecondaryContainer;
        break;
      case CalculatorButtonType.equals:
        backgroundColor = AppColors.primary;
        foregroundColor = AppColors.onPrimary;
        break;
    }

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => onPressed(label),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.onSurfaceVariant.withOpacity(0.12),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.titleLarge.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}