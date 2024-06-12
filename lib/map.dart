import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late GoogleMapController mapController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<String> friends = [];

  final LatLng _center = const LatLng(36.103945, 129.387546);
  final Map<String, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    getFriendMarker();
  }

  getFriendMarker() async {
    _markers.clear();
    DocumentSnapshot doc = await _firestore
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (doc.data() != null && doc.get('friendsList') != null) {
      friends = List<String>.from(doc.get('friendsList'));
    }
    var _request = await http.get(Uri.parse(doc['imageURL']));
    
    var _bytes = _request.bodyBytes;

    _markers[FirebaseAuth.instance.currentUser!.uid]=Marker(
      markerId:MarkerId(doc.get('uid')),
      position:LatLng(doc.get('location')[0],doc.get('location')[1]),
      icon: BitmapDescriptor.bytes(_bytes.buffer.asUint8List(),imagePixelRatio: 10),
      infoWindow: InfoWindow(title:doc.get('name'))
    );
    List<Future<void>> friendFetchFutures = friends.map((element) async {
      var _friend = await _firestore.collection('user').doc(element).get();

      var lat=_friend['location'][0];
      var lng=_friend['location'][1];
      var name = _friend['name'];

      var request = await http.get(Uri.parse(_friend['imageURL']));
      var bytes = request.bodyBytes;

      var marker = Marker(
        markerId: MarkerId(element),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.bytes(bytes.buffer.asUint8List(),imagePixelRatio: 10),
        infoWindow: InfoWindow(title:name)
      );
      _markers[element] = marker;
    }).toList();

    await Future.wait(friendFetchFutures);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 18.0,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}