class AppAuthState {
  final AppSession? session;
  AppAuthState({this.session});
}

class AppSession {
  final AppUser user;
  AppSession({required this.user});
}

class AppUser {
  final String id;
  final String email;

  AppUser({required this.id, required this.email});

  Map<String, dynamic> toJson() => {'id': id, 'email': email};
  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(id: json['id'], email: json['email']);
}

