import 'package:flutter/material.dart';
import 'package:gmap/models/place.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyRecipt extends StatefulWidget {
  @override
  State createState() => _MyReciptState();
}

class _MyReciptState extends State<MyRecipt> {
  @override
  Widget build(BuildContext context) {
    final placesProvider = Provider.of<Future<List<Place>>>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 24,
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Center(
                    child: Text(
                      'Parking Code',
                      style: TextStyle(
                          fontSize: 24.4,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Center(
                child: Image.asset(
                  'image/qr_code.jpg',
                  width: 220,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Parking Pass',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '#12-51-65',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 32),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Parking Slot',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'F1-B4',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 32),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'From',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '10:10 AM',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'To',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '12:20 PM',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 48,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Full Address',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                      fontSize: 13,
                      letterSpacing: 0.2),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Perdo Garage - 235 Bahringer Stravenue Suite 164 Colony Apt. 102',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900],
                      fontSize: 16.4,
                      letterSpacing: 0.2),
                ),
              ),
              SizedBox(
                height: 144,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        title: "CONFIRM PAYMENT",
                        desc: "Payment Confirmed",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "OK",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            color: Color.fromRGBO(0, 179, 134, 1.0),
                          ),
                          DialogButton(
                            child: Text(
                              "OK",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(116, 116, 191, 1.0),
                              Color.fromRGBO(52, 138, 199, 1.0)
                            ]),
                          )
                        ],
                      ).show();
                    },
                    child: Text(
                      'DONE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          wordSpacing: 2,
                          letterSpacing: 0.4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
