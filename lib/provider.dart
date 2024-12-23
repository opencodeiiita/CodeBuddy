import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_provider.dart';  // Make sure to import the SearchProvider file

class AppProvider extends StatelessWidget {
  final Widget child;

  AppProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: child,
    );
  }
}
