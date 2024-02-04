import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iller_ve_ilceler/city.dart';
import 'package:iller_ve_ilceler/district.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<City> citys = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jsonDecode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İller ve İlçeler')),
      body: ListView.builder(
        itemCount: citys.length,
        itemBuilder: _itemCreate,
      ),
    );
  }

  Widget _itemCreate(BuildContext cotnext, int index) {
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.location_city),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(citys[index].name),
            Text(citys[index].plateCode),
          ],
        ),
        children: citys[index].districts.map((value) {
          return ListTile(
            title: Text(value.name),
          );
        }).toList(),
      ),
    );
  }

  void _jsonDecode() async {
    String jsonString = await rootBundle.loadString('assets/citys_and_districts.json');
    Map<String, dynamic> citysMap = json.decode(jsonString);

    for (String plateCode in citysMap.keys) {
      Map<String, dynamic> cityMap = citysMap[plateCode];
      String cityName = cityMap['name'];
      Map<String, dynamic> cityDistrictsMap = cityMap['districts'];

      List<District> cityDistricts = [];

      for (String districtCode in cityDistrictsMap.keys) {
        Map<String, dynamic> districtMap = cityDistrictsMap[districtCode];
        String districtName = districtMap['name'];
        District district = District(districtName);
        cityDistricts.add(district);
      }

      City city = City(plateCode, cityName, cityDistricts);
      citys.add(city);
    }
    setState(() {});
  }
}
