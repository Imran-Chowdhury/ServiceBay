// class UserModel {
//   String? uid;         // Unique ID from Firebase
//   String name;         // User's name
//   String email;        // User's email
//   String role;         // User's role (admin or mechanic)
//
//   UserModel({
//     this.uid,
//     required this.name,
//     required this.email,
//     required this.role,
//   });
//
//   // Convert a UserModel object to a map (for saving in Firestore)
//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'name': name,
//       'email': email,
//       'role': role,
//     };
//   }
//
//   // Create a UserModel object from a map (for fetching from Firestore)
//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       uid: map['uid'],
//       name: map['name'],
//       email: map['email'],
//       role: map['role'],
//     );
//   }
// }
