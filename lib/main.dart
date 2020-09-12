import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool toggleformap=false;
  var currentlocation;
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  GoogleMapController mapController;




  TextEditingController namecontroller=TextEditingController();

  String _mapStyle;

  bool isnamefieldEmptyorToolong=true;





@override
  void initState() {
    // TODO: implement initState
    super.initState();
setState(() {

  rootBundle.loadString('assets/map1.txt').then((string) {
    _mapStyle = string;
    getCurrentPosition();
    setCustomMapPin();
  });
});


  }




void setCustomMapPin() async {
  pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/map.jpg');

}




void getCurrentPosition() async {
  Position position = await GeolocatorPlatform.instance
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
currentlocation=LatLng(position.latitude,position.longitude);
  setState(() {
    toggleformap=true;
  });
}





  handleSubmit()
  {
    setState(() {
      namecontroller.text.trim().isEmpty || namecontroller.text.trim().length>20 ? isnamefieldEmptyorToolong=false : isnamefieldEmptyorToolong=true;

    });

    if(isnamefieldEmptyorToolong)
    {
      SnackBar snackBar = SnackBar(
          content: Text("Location: ${currentlocation
              .latitude},${currentlocation
              .longitude} \n Name: ${namecontroller.text}"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      print("Location: ${currentlocation.latitude}, ${currentlocation.longitude} \n Name: ${namecontroller.text}");
      Navigator.pop(context);
      namecontroller.clear();
    }

  }





infoForm(BuildContext context)
{
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      content: Container(
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text("Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text("Location:${currentlocation.latitude},${currentlocation.longitude}",
              style: TextStyle(
                fontSize: 13,

              ),
              ),
            ),

            TextField(
              controller: namecontroller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Your Name",
                hintText: "Enter Your Name",
                  errorText: isnamefieldEmptyorToolong ?  null:  "Field empty or too long text"  ,
              ),
              style: TextStyle(
                fontSize: 13
              ),

            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: Colors.cyan,
              child: RaisedButton(
                color: Colors.cyan,
                child: Text("Submit",style: TextStyle(color: Colors.white),),
                onPressed: ()
                {
                  setState(() {
                    handleSubmit();

                  });
                },
              )
            )
          ],
        ),


      ),



    );
  });
}






  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: toggleformap ? GoogleMap(
          zoomGesturesEnabled: true,
          compassEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: onMapCreated,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          zoomControlsEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: currentlocation,
             zoom: 14,
              bearing: 45.0,
              tilt: 45.0
          ),
          markers: _markers,

        ):Center(child: CircularProgressIndicator()),
      ),
    );
  }





  void onMapCreated(controller)
  {
    setState(() {
      mapController=controller;
      _markers.add(
          Marker(
              markerId: MarkerId('<MARKER_ID>'),
              position: currentlocation,
              icon: pinLocationIcon,
              onTap: ()
              {
                setState(() {
                  infoForm(context);
                });
              }
          )
      );
      mapController.setMapStyle(_mapStyle);
    });
  }

}
