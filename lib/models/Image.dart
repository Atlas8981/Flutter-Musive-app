
class Image {
  Image({
    required this.imageName,
    required this.imageUrl,
  });

  final String imageName;
  final String imageUrl;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    imageName: json["imageName"],
    imageUrl: json["imageURL"],
  );

  Map<String, dynamic> toJson() => {
    "imageName": imageName,
    "imageURL": imageUrl,
  };

  @override
  String toString() {
    return 'Image{imageName: $imageName, imageUrl: $imageUrl}';
  }
}