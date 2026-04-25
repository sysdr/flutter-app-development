import '../models/user_profile.dart';

final class ProfileState {
  const ProfileState({this.profile,this.loading=false});
  final UserProfile? profile;
  final bool         loading;
  bool get isLoggedIn => profile != null;
}
