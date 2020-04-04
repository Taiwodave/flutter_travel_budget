import 'package:flutter/material.dart';
import 'package:flutter_app_baby_name/models/Trip.dart';
import 'package:flutter_app_baby_name/new_trips/location_view.dart';
import 'package:flutter_app_baby_name/pages.dart';
import 'package:flutter_app_baby_name/services/auth_service.dart';
import 'package:flutter_app_baby_name/views/home_view.dart';
import 'package:flutter_app_baby_name/widgets/provider_widget.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeView(),
    ExplorePage(),
    PastTripPage()
  ];
  @override
  Widget build(BuildContext context) {
    final newTrip = new Trip(null, null, null, null, null);
    return Scaffold(
      appBar: AppBar(
        title: Text("Travel Budget App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewTripLocationView(trip: newTrip,)),
              );
            },
          ),
          IconButton(
              icon: Icon(Icons.undo),
              onPressed: () async {
                try{
                  AuthService auth = Provider.of(context).auth;
                  await auth.signOut();
                  print("Signed Out");
                } catch (e){
                  print(e);
                }
              }),
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: (){
                Navigator.of(context).pushNamed('/convertUser');
              },
              ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text("Explore"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text("Past Trips"),
          )
        ]
      )
    );
  }

  onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
}
