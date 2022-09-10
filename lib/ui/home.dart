import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isLoading = false;
  GeoPoint pinnedLocation = GeoPoint(latitude: 0, longitude: 0);
  // lintang 0, bujur 0 ada di barat benua afrika
  ValueNotifier<GeoPoint?> notifier = ValueNotifier(null);
  GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Attendance Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                ValueListenableBuilder<GeoPoint?>(
                  valueListenable: notifier,
                  builder: (ctx, p, child) {
                    String text = "";
                    if (p != null) {
                      text =
                          "Lokasi Kantor\nLintang : ${p.latitude}\nBujur : ${p.longitude}";
                    }
                    return Text(text, textAlign: TextAlign.center);
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    var p = await Navigator.pushNamed(context, "/pick-office");
                    if (p != null) {
                      notifier.value = p as GeoPoint;
                      setState(() {
                        pinnedLocation = p;
                      });
                    }
                  },
                  child: const Text("Pilih Lokasi Kantor"),
                ),
                ElevatedButton(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Submit Absensi"),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    Position currentPosition =
                        await _geolocatorPlatform.getCurrentPosition();
                    if (notifier.value != null) {
                      double distanceInMeters = Geolocator.distanceBetween(
                          pinnedLocation.latitude,
                          pinnedLocation.longitude,
                          currentPosition.latitude,
                          currentPosition.longitude);
                      if (distanceInMeters > 50) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Rejected"),
                                  content: Text(
                                      "Maaf Anda berada $distanceInMeters meter dari kantor, Absensi Ditolak"),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"))
                                  ],
                                ));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Accepted"),
                                  content: const Text(
                                      "Absensi anda sudah tercatat di sistem"),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"))
                                  ],
                                ));
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Error"),
                                content: const Text(
                                    "Koordinat kantor belum dipilih, silahkan dipilih terlebih dahulu!"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"))
                                ],
                              ));
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
