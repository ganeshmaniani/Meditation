import 'package:flutter/material.dart';

class EditPlaylistSelectionProvider extends ChangeNotifier {
  int selectedIndex = 0;
  String selectedProfile = '';

  void updateSelection(int index, String profile) {
    selectedIndex = index;
    selectedProfile = profile;
    notifyListeners(); // Notify listeners when state changes
  }
}
