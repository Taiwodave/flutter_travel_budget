import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_baby_name/models/Place.dart';
import 'package:flutter_app_baby_name/models/Trip.dart';
import 'package:flutter_app_baby_name/new_trips/date_view.dart';
import 'package:flutter_app_baby_name/widgets/divider_widget_text.dart';

class NewTripLocationView extends StatelessWidget {
  final Trip trip;

  NewTripLocationView({Key key, @required this.trip}) : super(key: key);

  final List<Place> _placesList = [
    Place("New York", 320.00),
    Place("Austrial", 320.00),
    Place("Bosten", 320.00),
    Place("Akure", 320.00),
    Place("Ikeja", 320.00),
  ];

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    _titleController.text = trip.title;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Trip - Location"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: DividerWithText(
                dividerText: "Suggestion",
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _placesList.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildPlaceCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceCard(BuildContext context, int index) {
    return Hero(
      tag: "SelectedTrip-${_placesList[index].name}",
      transitionOnUserGestures: true,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Card(
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: AutoSizeText(_placesList[index].name,
                                    maxLines: 3,
                                    style: TextStyle(fontSize: 25.0)),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  "Average Budget \$${_placesList[index].averageBudget.toStringAsFixed(2)}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Placeholder(
                        fallbackHeight: 80,
                        fallbackWidth: 80,
                      ),
                    ],
                  )
                ],
              ),
              onTap: () {
                trip.title = _placesList[index].name;
                // TODO maybe pass the trip average budget through here too...
                // that would need to be added to the Trip object
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewTripDateView(trip: trip)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

//RaisedButton(
//child: Text("Continue"),
//onPressed: () {
//trip.title = _titleController.text;
//Navigator.push(
//context,
//MaterialPageRoute(builder: (context) => NewTripDateView(trip: trip)),
//);
//},
//),
