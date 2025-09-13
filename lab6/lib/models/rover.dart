class Rover {
  int? id;
  String? name;
  String? landingDate;
  String? launchDate;
  String? status;

  Rover({this.id, this.name, this.landingDate, this.launchDate, this.status});

  Rover.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    landingDate = json['landing_date'];
    launchDate = json['launch_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['landing_date'] = landingDate;
    data['launch_date'] = launchDate;
    data['status'] = status;
    return data;
  }
}
