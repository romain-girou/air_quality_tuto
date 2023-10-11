import 'package:flutter/material.dart';
import 'package:tuto_http/data/fetch_data.dart';

import 'home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
			debugShowCheckedModeBanner: false,
      home: FutureBuilder(
				future: fetchData(),
				builder: (context, snap) {
					if(snap.hasData) {
						return HomeScreen(snap.data!);
					} else {
						return const Scaffold(
							body: Center(
								child: CircularProgressIndicator(),
							),
						);
					}
				}
			),
    );
  }
}
