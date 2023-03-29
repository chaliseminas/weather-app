import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather/utils/theme_utils.dart';
import 'package:weather/view/home.dart';
import 'package:weather/view_model/weather_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherViewModel>(create: (_) => WeatherViewModel())
      ],
      child: MaterialApp(
        title: 'Weather',
        theme: ThemeUtils.setTheme(context),
        home: HomePage(),
      ),
    );
  }
}
