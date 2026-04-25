/// User profile domain model — Lesson 10 placeholder.
///
/// L19: Freezed-generated with copyWith + toJson.
/// L25: Firebase Auth integration.
final class UserProfile {
  const UserProfile({required this.uid,required this.displayName,
    required this.email,this.avatarUrl});
  final String  uid,displayName,email;
  final String? avatarUrl;
}

final class SavedTrip {
  const SavedTrip({required this.id,required this.flightId,
    required this.savedAt});
  final String   id,flightId;
  final DateTime savedAt;
}
