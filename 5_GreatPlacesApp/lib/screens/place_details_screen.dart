import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places_provider.dart';
import 'package:great_places_app/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName ='/place-details';

  const PlaceDetailsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final selectedPlace =
        Provider.of<GreatPlacesProvider>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              (selectedPlace.image),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            selectedPlace.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (ctx) => MapScreen(
                      initialLocation: selectedPlace.location,
                      isSelecting: false,
                    ),
                  ),
                );
              },
              child: Text("View on Map"),
              color: Theme.of(context).primaryColor)
        ],
      ),
    );
  }
}
