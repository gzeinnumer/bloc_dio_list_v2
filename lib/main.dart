import 'package:bloc_dio_list_v2/repo/f1_covid_repository.dart';
import 'package:bloc_dio_list_v2/ui/f6_covid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => CovidRepository())
        ],
        child: CovidView(),
      ),
    );
  }
}