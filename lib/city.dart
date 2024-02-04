import 'package:iller_ve_ilceler/district.dart';

class City {
  City(this.plateCode, this.name, this.districts);

  String plateCode;
  String name;
  List<District> districts;
}
