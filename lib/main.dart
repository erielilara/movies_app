import 'package:flutter/material.dart';
import 'package:movies_app/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/providers/movies_provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: ( _ ) => MoviesProvider(), lazy: false,)
        ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      initialRoute: 'Home',
      routes: {
        'Home':( _ ) => const HomeScreen(),
        'Details': ( _ ) => const DetailsScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF006064)
        )
      ),
    );
  }

}