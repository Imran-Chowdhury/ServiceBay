class AuthState {
  // remove user and manually write name, role and email
  final String? name;
  final String? role;
  final String? email;
  // final String? uid;
  final bool isLoading;

  // AuthState({this.user, this.isLoading = false});
  AuthState({this.name, this.email, this.role,  this.isLoading = false});

  // AuthState copyWith({User? user, bool? isLoading}) {
  AuthState copyWith({String? name, String? role, String? email, bool? isLoading}) {
    return AuthState(
      // user: user ?? this.user,
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      // uid: uid?? this.uid,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}