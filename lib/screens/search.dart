import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gmap/models/usermodel.dart';
import 'package:gmap/provider/user_provider.dart';
import 'package:gmap/screens/about.dart';
import 'package:gmap/screens/add_creditcard.dart';
import 'package:gmap/screens/contactus.dart';
import 'package:gmap/screens/profilescreen.dart';
import 'package:gmap/services/geolocator_service.dart';
import 'package:gmap/services/marker_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher.dart';
import '../models/place.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

ProductProvider productProvider;

class _SearchState extends State<Search> {
  Widget _buildUserAccountsDrawerHeader() {
    List<UserModel> userModel = productProvider.userModelList;
    return Column(
        children: userModel.map((e) {
      return UserAccountsDrawerHeader(
        accountName: Text(
          e.userName,
          style: TextStyle(color: Colors.black),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: e.userImage == null
              ? AssetImage("images/userImage.png")
              : NetworkImage(e.userImage),
        ),
        decoration: BoxDecoration(color: Color(0xfff2f2f2)),
        accountEmail: Text(e.userEmail, style: TextStyle(color: Colors.black)),
      );
    }).toList());
  }

  double height, width;
  bool homeColor = true;

  bool checkoutColor = false;

  bool aboutColor = false;

  bool contactUsColor = false;
  bool profileColor = false;
  bool slots = false;
  MediaQueryData mediaQuery;
  Widget _buildMyDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _buildUserAccountsDrawerHeader(),
          ListTile(
            selected: homeColor,
            onTap: () {
              setState(() {
                homeColor = true;
                contactUsColor = false;
                checkoutColor = false;
                aboutColor = false;
                profileColor = false;
              });
            },
            leading: Icon(Icons.home),
            title: Text("Home"),
          ),
          ListTile(
            selected: aboutColor,
            onTap: () {
              setState(() {
                aboutColor = true;
                contactUsColor = false;
                homeColor = false;
                profileColor = false;
                checkoutColor = false;
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => About()));
            },
            leading: Icon(Icons.info),
            title: Text("About"),
          ),
          ListTile(
            selected: profileColor,
            onTap: () {
              setState(() {
                aboutColor = false;
                contactUsColor = false;
                homeColor = false;
                profileColor = true;
                checkoutColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => ProfileScreen(),
                ),
              );
            },
            leading: Icon(Icons.info),
            title: Text("Profile"),
          ),
          ListTile(
            selected: contactUsColor,
            onTap: () {
              setState(() {
                contactUsColor = true;
                checkoutColor = false;
                profileColor = false;
                homeColor = false;
                aboutColor = false;
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => ContactUs()));
            },
            leading: Icon(Icons.phone),
            title: Text("Contant Us"),
          ),
          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
          ),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<Place>>>(context);
    final geoService = GeoLocatorService();
    final markerService = MarkerService();
    productProvider = Provider.of<ProductProvider>(context);

    return FutureProvider(
      create: (context) => placesProvider,
      child: Scaffold(
        key: _key,
        drawer: _buildMyDrawer(),
        appBar: AppBar(
          title: Text(
            "HomePage",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.grey[100],
          leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () {
                _key.currentState.openDrawer();
              }),
        ),
        body: (currentPosition != null)
            ? Consumer<List<Place>>(
                builder: (_, places, __) {
                  var markers = (places != null)
                      ? markerService.getMarkers(places)
                      : List<Marker>();
                  return (places != null)
                      ? Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(currentPosition.latitude,
                                        currentPosition.longitude),
                                    zoom: 16.0),
                                zoomGesturesEnabled: true,
                                markers: Set<Marker>.of(markers),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: places.length,
                                  itemBuilder: (context, index) {
                                    return FutureProvider(
                                      create: (context) =>
                                          geoService.getDistance(
                                              currentPosition.latitude,
                                              currentPosition.longitude,
                                              places[index]
                                                  .geometry
                                                  .location
                                                  .lat,
                                              places[index]
                                                  .geometry
                                                  .location
                                                  .lng),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(places[index].name),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 3.0,
                                              ),
                                              (places[index].rating != null)
                                                  ? Row(
                                                      children: <Widget>[
                                                        RatingBarIndicator(
                                                          rating: places[index]
                                                              .rating,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              Icon(Icons.star,
                                                                  color: Colors
                                                                      .amber),
                                                          itemCount: 5,
                                                          itemSize: 10.0,
                                                          direction:
                                                              Axis.horizontal,
                                                        )
                                                      ],
                                                    )
                                                  : Row(),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Consumer<double>(
                                                builder:
                                                    (context, meters, wiget) {
                                                  return (meters != null)
                                                      ? Text(
                                                          '${places[index].vicinity} \u00b7 ${(meters / 1000).round()} Km')
                                                      : Container();
                                                },
                                              )
                                            ],
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(Icons.directions),
                                            color:
                                                Theme.of(context).primaryColor,
                                            onPressed: () {
                                              _launchMapsUrl(
                                                  places[index]
                                                      .geometry
                                                      .location
                                                      .lat,
                                                  places[index]
                                                      .geometry
                                                      .location
                                                      .lng);
                                            },
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCard()));
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        )
                      : Center(child: CircularProgressIndicator());
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
