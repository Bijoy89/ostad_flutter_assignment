import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import 'api_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _searchController = TextEditingController(text: 'Dhaka');
  bool _loading = false;
  String? _error;

  String? _resolvedCity;

  // Current weather
  double? _tempC;
  double? _windKmh;
  int? _wCode;
  String? _wText;

  double? _high, _low;

  List<_Hourly> _hourlies = [];
  List<_Daily> _dailies = [];

  //network

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final getGeoData = await ApiService.geoLocation(city);
      final url = Uri.parse(
        "https://api.open-meteo.com/v1/forecast"
            "?latitude=${getGeoData.lat}&longitude=${getGeoData.lon}&"
            "daily=temperature_2m_max,temperature_2m_min,sunset,sunrise&"
            "hourly=temperature_2m,weather_code,wind_speed_10m&"
            "current=temperature_2m,weather_code,wind_speed_10m"
            "&timezone=Asia%2FDhaka"
            "&forecast_days=10",
      );
      final res = await http.get(url);
      if (res.statusCode != 200) {
        throw Exception("Weather fetch failed ${res.statusCode}");
      }
      final deData = jsonDecode(res.body) as Map<String, dynamic>;
      final current = deData['current'] as Map<String, dynamic>;

      final tempC = (current['temperature_2m'] as num).toDouble();
      final windKmh = (current['wind_speed_10m'] as num).toDouble();
      final wCode = (current['weather_code'] as num).toInt();

      // Hourly
      final hourly = deData['hourly'] as Map<String, dynamic>;
      final hTimes = List<String>.from(hourly['time'] as List);
      final hTemps = List<num>.from(hourly['temperature_2m'] as List);
      final hCodes = List<num>.from(hourly['weather_code'] as List);

      final outHourly = <_Hourly>[];
      for (var i = 0; i < hTimes.length; i++) {
        outHourly.add(_Hourly(
          DateTime.parse(hTimes[i]),
          hTemps[i].toDouble(),
          hCodes[i].toInt(),
        ));
      }

      //Daily(10-day forecast)
      final daily = deData['daily'] as Map<String, dynamic>;
      final dTimes = List<String>.from(daily['time'] as List);
      final dMax = List<num>.from(daily['temperature_2m_max'] as List);
      final dMin = List<num>.from(daily['temperature_2m_min'] as List);

      final outDaily = <_Daily>[];

      _high = dMax.map((e) => e.toDouble()).reduce((a, b) => a > b ? a : b);
      _low = dMin.map((e) => e.toDouble()).reduce((a, b) => a < b ? a : b);

      for (var i = 0; i < dTimes.length; i++) {
        outDaily.add(_Daily(
          DateTime.parse(dTimes[i]),
          dMin[i].toDouble(),
          dMax[i].toDouble(),
        ));
      }

      setState(() {
        _resolvedCity = getGeoData.city;
        _tempC = tempC;
        _windKmh = windKmh;
        _wCode = wCode;
        _wText = _codeToText(wCode);
        _hourlies = outHourly;
        _dailies = outDaily;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // Current
  String _codeToText(int? c) {
    if (c == null) return "Unknown";
    if (c == 0) return "Clear sky";
    if ([1, 2, 3].contains(c)) return "Mainly cloudy";
    if ([45, 48].contains(c)) return "Fog";
    if ([51, 53, 55, 56, 57].contains(c)) return "Drizzle";
    if ([61, 63, 65, 66, 67].contains(c)) return "Rain";
    if ([71, 73, 75, 77, 80, 81, 82].contains(c)) return "Snow";
    if ([85, 86].contains(c)) return "Heavy snow";
    if ([95, 96, 99].contains(c)) return "Thunderstorm";
    return "Cloudy";
  }

  IconData _codeToIcon(int? c) {
    if (c == null) return Icons.cloud;
    if (c == 0) return Icons.sunny;
    if ([1, 2, 3].contains(c)) return Icons.cloud_outlined;
    if ([45, 48].contains(c)) return Icons.foggy;
    if ([51, 53, 55, 56, 57].contains(c)) return Icons.grain_sharp;
    if ([61, 63, 65, 66, 67].contains(c)) return Icons.water_drop;
    if ([71, 73, 75, 77, 80, 81, 82].contains(c)) return Icons.ac_unit;
    if ([85, 86].contains(c)) return Icons.snowing;
    if ([95, 96, 99].contains(c)) return Icons.thunderstorm;
    return Icons.cloud;
  }

  Future<void> _fetchWeatherByLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final locData = await getCurrentLocation();
      final LAT = locData.latitude;
      final LON = locData.longitude;

      final url = Uri.parse(
        "https://api.open-meteo.com/v1/forecast"
            "?latitude=${LAT}&longitude=${LON}"
            "&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset"
            "&hourly=temperature_2m,weather_code,wind_speed_10m"
            "&current=temperature_2m,weather_code,wind_speed_10m"
            "&timezone=Asia%2FDhaka"
            "&forecast_days=10",

      );

      final res = await http.get(url);
      if (res.statusCode != 200) {
        throw Exception("Weather fetch failed ${res.statusCode}");
      }

      final deData = jsonDecode(res.body) as Map<String, dynamic>;
      final current = deData['current'] as Map<String, dynamic>;

      final daily = deData['daily'] as Map<String, dynamic>;
      final dTimes = List<String>.from(daily['time'] as List);
      final dMax = List<num>.from(daily['temperature_2m_max'] as List);
      final dMin = List<num>.from(daily['temperature_2m_min'] as List);

      final outDaily = <_Daily>[];

      _high = dMax.map((e) => e.toDouble()).reduce((a, b) => a > b ? a : b);
      _low = dMin.map((e) => e.toDouble()).reduce((a, b) => a < b ? a : b);

      for (var i = 0; i < dTimes.length; i++) {
        outDaily.add(_Daily(
          DateTime.parse(dTimes[i]),
          dMin[i].toDouble(),
          dMax[i].toDouble(),
        ));
      }

      setState(() {
        _resolvedCity = "Current Location";
        _tempC = (current['temperature_2m'] as num).toDouble();
        _windKmh = (current['wind_speed_10m'] as num).toDouble();
        _wCode = (current['weather_code'] as num).toInt();
        _wText = _codeToText(_wCode);
        _dailies = outDaily;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) throw Exception("Location service not enabled");
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception("Location permission denied");
      }
    }

    return await location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather("Dhaka");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading ? null : _fetchWeatherByLocation,
        icon: const Icon(Icons.my_location),
        label: const Text("My Location"),
        backgroundColor: Colors.blueAccent,
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchWeather(_searchController.text),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.blueAccent, Colors.white70],
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: _searchController,
                        onSubmitted: (v) => _fetchWeather(v),
                        decoration: InputDecoration(
                          labelText: "Enter city (e.g. Dhaka)",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.5)),
                          ),
                          focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _loading
                          ? null
                          : () => _fetchWeather(_searchController.text),
                      child: Text("Go"),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                if (_loading) const LinearProgressIndicator(),
                if (_error != null)
                  Text(_error!, style: TextStyle(color: Colors.red)),
                const SizedBox(height: 8),

                Column(
                  children: [
                    Text(
                      "My Location",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _resolvedCity ?? "Bangladesh",
                      style: TextStyle(color: Colors.white70, fontSize: 28),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                if (_tempC != null)
                  Center(
                    child: Text(
                      "${_tempC!.toStringAsFixed(0)} °C",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 96,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                if (_windKmh != null)
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          "Sunny conditions likely through today. Wind up to ${_windKmh} km/h"),
                    ),
                  ),

                const SizedBox(height: 12),

                // Hourly
                if (_hourlies.isNotEmpty)
                  Card(
                    color: Colors.white,
                    child: SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, __) => const SizedBox(width: 12),
                        separatorBuilder: (_, i) {
                          final h = _hourlies[i];
                          final label = i == 0 ? 'Now' : h.t.hour.toString();
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(label),
                              Icon(_codeToIcon(h.code)),
                              Text("${h.temp.toStringAsFixed(0)}°C"),
                            ],
                          );
                        },
                        itemCount: _hourlies.length,
                      ),
                    ),
                  ),

                // 10-day forecast
                if (_dailies.isNotEmpty)
                  Card(
                    color: Colors.white.withOpacity(0.95),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "10-Day Forecast",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._dailies.map((d) {
                            final dayName = [
                              "Sun",
                              "Mon",
                              "Tue",
                              "Wed",
                              "Thu",
                              "Fri",
                              "Sat"
                            ][d.time.weekday % 7];

                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  // Day name
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      dayName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    _codeToIcon(_wCode),
                                    color: Colors.orangeAccent,
                                    size: 28,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                              BorderRadius.circular(3),
                                            ),
                                          ),
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              final minTemp = _low ?? 0;
                                              final maxTemp = _high ?? 0;
                                              final start =
                                                  ((d.tMin - minTemp) /
                                                      (maxTemp - minTemp)) *
                                                      constraints.maxWidth;
                                              final width =
                                                  ((d.tMax - d.tMin) /
                                                      (maxTemp - minTemp)) *
                                                      constraints.maxWidth;

                                              return Positioned(
                                                left: start,
                                                width: width,
                                                child: Container(
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    color: Colors.orangeAccent,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        3),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${d.tMin.toStringAsFixed(0)}°",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${d.tMax.toStringAsFixed(0)}°",
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hourly {
  final DateTime t;
  final double temp;
  final int code;
  _Hourly(this.t, this.temp, this.code);
}

class _Daily {
  final DateTime time;
  final double tMin;
  final double tMax;
  _Daily(this.time, this.tMin, this.tMax);
}
