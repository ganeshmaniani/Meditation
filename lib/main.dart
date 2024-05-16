import 'package:flutter/material.dart';

import 'core/app/app.dart';
import 'package:provider/provider.dart';

import 'features/features.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AddPlaylistSelectionProvider()),
    ChangeNotifierProvider(create: (context) => EditPlaylistSelectionProvider())
  ], child: const MeditationApplication()));
}
