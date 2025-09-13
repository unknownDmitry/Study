import 'camera.dart';
import 'rover.dart';

class Photos {
  int? id;
  int? sol;
  Camera? camera;
  String? imgSrc;
  String? earthDate;
  Rover? rover;

  Photos({
    this.id,
    this.sol,
    this.camera,
    this.imgSrc,
    this.earthDate,
    this.rover,
  });

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sol = json['sol'];
    camera = json['camera'] != null ? Camera.fromJson(json['camera']) : null;
    imgSrc = json['img_src'];
    earthDate = json['earth_date'];
    rover = json['rover'] != null ? Rover.fromJson(json['rover']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sol'] = sol;
    if (camera != null) {
      data['camera'] = camera!.toJson();
    }
    data['img_src'] = imgSrc;
    data['earth_date'] = earthDate;
    if (rover != null) {
      data['rover'] = rover!.toJson();
    }
    return data;
  }
}
