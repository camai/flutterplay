import 'package:flutter/material.dart';
import 'package:flutterplay/widgets/layouts/responsive_layout.dart';
import 'package:flutterplay/widgets/common/custom_button.dart';
import '../theme/app_theme.dart';
import 'lotto_home_screen.dart';
import 'calculator_home_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메인 화면'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ResponsivePadding(
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // 앱 제목
            const Text(
              'Flutter Play',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '다양한 기능을 체험해보세요',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 60),
            
            // 버튼 리스트
            Expanded(
              child: Column(
                children: [
                  // 로또 번호 화면 버튼
                  CustomButton(
                    text: '로또 번호 추첨기',
                    icon: Icons.casino,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LottoHomeScreen(),
                        ),
                      );
                    },
                    width: double.infinity,
                    height: 60,
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 20),
                  
                  // 계산기 화면 버튼
                  CustomButton(
                    text: '계산기',
                    icon: Icons.calculate,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Calculator(),
                        ),
                      );
                    },
                    width: double.infinity,
                    height: 60,
                    backgroundColor: Colors.green.shade600,
                  ),
                  const SizedBox(height: 20),
                  
                  // 추가 기능 버튼들
                  CustomButton(
                    text: '더 많은 기능',
                    icon: Icons.add,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('추가 기능은 준비 중입니다.'),
                        ),
                      );
                    },
                    width: double.infinity,
                    height: 60,
                    backgroundColor: Colors.orange.shade600,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
