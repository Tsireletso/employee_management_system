class UserModel {
  String id;
  String name;
  String email;
  String password; // must exist
  String role; // "admin", "manager", "employee"
  bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.isActive = true,
  });
}