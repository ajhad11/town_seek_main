enum AppRole {
  superAdmin,
  businessAdmin,
  user,
}

extension AppRoleExtension on AppRole {
  String get name {
    switch (this) {
      case AppRole.superAdmin: return 'super_admin';
      case AppRole.businessAdmin: return 'business_admin';
      case AppRole.user: return 'user';
    }
  }
  
  static AppRole fromString(String value) {
    switch (value) {
      case 'super_admin': return AppRole.superAdmin;
      case 'business_admin': return AppRole.businessAdmin;
      case 'user': return AppRole.user;
      default: return AppRole.user;
    }
  }
}

