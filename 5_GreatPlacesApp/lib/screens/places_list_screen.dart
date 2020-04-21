import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places_provider.dart';
import 'package:great_places_app/screens/add_place_screen.dart';
import 'package:great_places_app/screens/place_details_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Places"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
                })
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlacesProvider>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlacesProvider>(
                  builder: (ctx, greatPlaces, ch) {
                    return greatPlaces.items.length <= 0
                        ? ch
                        : ListView.builder(
                            itemBuilder: (ctx, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(greatPlaces.items[i].image),
                              ),
                              title: Text(greatPlaces.items[i].title),
                              onTap: () => Navigator.of(context).pushNamed(
                                  PlaceDetailsScreen.routeName,
                                  arguments: greatPlaces.items[i].id),
                              subtitle:
                                  Text(greatPlaces.items[i].location.address),
                            ),
                            itemCount: greatPlaces.items.length,
                          );
                  },
                  child: Center(
                    child: const Text('GotNo places yet, start adding some!'),
                  ),
                ),
        ));
  }
}
