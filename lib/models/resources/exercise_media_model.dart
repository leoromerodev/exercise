class ExerciseMediaModel {
  String? gifImage;
  String? video;
  String? thumbnail;

  ExerciseMediaModel({this.gifImage, this.video, this.thumbnail});

  // fromMap
  factory ExerciseMediaModel.fromMap(Map<String, dynamic> map) {
    return ExerciseMediaModel(gifImage: map['gifImage'], video: map['video'], thumbnail: map['thumbnail']);
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {'gifImage': gifImage, 'video': video, 'thumbnail': thumbnail};
  }

  // copyWith
  ExerciseMediaModel copyWith({String? gifImage, String? video, String? thumbnail}) {
    return ExerciseMediaModel(
      gifImage: gifImage ?? this.gifImage,
      video: video ?? this.video,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
