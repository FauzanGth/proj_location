import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: const MyHomePage(title: 'Ojan Maps'),
        );
    }
}

class MyHomePage extends StatefulWidget {
    const MyHomePage({super.key, required this.title});
    final String title;

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    Location location = Location();
    LocationData? _currentLocation;
    bool _serviceEnabled = false;
    PermissionStatus? _permissionGranted;

    @override
    void initState() {
        super.initState();
        getLocation();
    }

    Future<void> getLocation() async {
        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
            _serviceEnabled = await location.requestService();
            if (!_serviceEnabled) return;
        }

        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
            _permissionGranted = await location.requestPermission();
            if (_permissionGranted != PermissionStatus.granted) return;
        }

        final loc = await location.getLocation();
        setState(() {
            _currentLocation = loc;
        });
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    backgroundColor: Color(0xff383836),
                    title: Text(
                        'Hm... Aku dimana ya???',
                        style: TextStyle(
                            fontFamily: 'MyFont',
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                    centerTitle: true,
                    elevation: 4,
                    iconTheme: IconThemeData(color: Colors.white),
                ),
                body: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/bg.jpg'), // Gambar kamu
                            fit: BoxFit.cover, // Menyesuaikan gambar dengan layar
                        ),
                    ),
                    child: Center(
                        child: _currentLocation == null
                            ? Text('Melacak Lokasimu . . .',
                                style: TextStyle(
                                    fontFamily: 'MyFont',
                                    fontSize: 12,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                ),
                            )
                            : Text(
                                'LOKASI KAMU :\nLat: ${_currentLocation!.latitude}, Long: ${_currentLocation!.longitude}',
                                style: TextStyle(
                                    fontFamily: 'MyFont',
                                    fontSize: 12,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                ),
                            ),
                    ),
                ),
            ),
        );
    }
}