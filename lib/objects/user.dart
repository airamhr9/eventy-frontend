class User {
  String id;
  String profilePicture;
  String email;
  String password;
  List<String> preferences;
  String userName;
  String bio;
  String birthdate;
  String? profilePictureName;

  User(
      this.id,
      this.profilePicture,
      this.email,
      this.preferences,
      this.userName,
      this.password,
      this.bio,
      this.birthdate,
      this.profilePictureName);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['id'],
        json['image'],
        json['email'],
        (json['preferences'] != null)
            ? (json['preferences'] as List).cast<String>()
            : [],
        json['username'],
        json['password'],
        json['bio'],
        json['birthdate'],
        json['imageName']);
  }

  Map toJson() {
    Map result = {
      'id': this.id,
      'image': this.profilePicture,
      'email': this.email,
      'preferences': this.preferences,
      'username': this.userName,
      'password': this.password,
      'bio': this.bio,
      'birthdate': this.birthdate,
      'imageName': this.profilePictureName
    };
    return result;
  }
}
