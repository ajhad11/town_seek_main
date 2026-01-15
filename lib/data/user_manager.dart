import 'dart:io';
import 'package:flutter/material.dart';

class UserManager extends ChangeNotifier {
  static final UserManager instance = UserManager._internal();

  factory UserManager() {
    return instance;
  }

  UserManager._internal();

  String _name = 'Sibhathulla';
  String _profileImage = 'https://i.pravatar.cc/150?img=11';
  String _phone = '+91 9876543210';
  File? _localImageFile;

  String get name => _name;
  String get profileImage => _profileImage;
  String get phone => _phone;
  File? get localImageFile => _localImageFile;

  void updateProfile({String? name, String? image, File? localImage, String? phone}) {
    if (name != null) _name = name;
    if (image != null) _profileImage = image;
    if (localImage != null) {
      _localImageFile = localImage;
    } else if (image != null) {
      // If we are setting a new network image (and localImage is null passed explicitly or implicitly), 
      // we might want to clear local image if the intent was to switch back to network.
      // But based on EditProfilePage logic, we usually set one or the other.
      // For now, if localImage is explicitly passed as null, we don't clear it unless logic dictates. 
      // Let's assume the caller handles logic. 
      // Actually, let's keep it simple: if localImage is provided updates it.
    }
    
    // Logic from ProfilePage state:
    // if (result['isLocalImage'] == true) { _localImageFile = File(result['image']); } 
    // else { _profileImage = result['image']; _localImageFile = null; }
    
    if (phone != null) _phone = phone;
    
    notifyListeners();
  }

  void setLocalImage(File file) {
    _localImageFile = file;
    notifyListeners();
  }
}

