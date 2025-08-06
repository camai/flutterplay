import 'package:flutter/material.dart';
import 'package:flutterplay/screens/main_home_screen.dart';
import 'package:provider/provider.dart';
import 'viewmodels/lotto_viewmodel.dart';
import 'screens/lotto_home_screen.dart';

void main() {
  runApp(const LottoApp());
}

class LottoApp extends StatelessWidget {
  const LottoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LottoViewModel(),
      child: MaterialApp(
        title: 'Flutter Play',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MainHomeScreen(),
      ),
    );
  }
}
