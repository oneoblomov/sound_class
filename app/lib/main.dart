import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/menu_viewmodel.dart';
import 'views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
      ],
      child: MaterialApp(
        home: HomeView(),
      ),
    );
  }
}
