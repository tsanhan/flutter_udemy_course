import '../models/filters.dart';

import '../widgets/main_drawer.dart';

import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
static const routeName = '/filters';

final Function _saveFilters;
final Filters _Filters;



FiltersScreen(this._saveFilters, this._Filters);
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  
  

Widget _buildSwitchListTile({String title, String subtitle, bool value, Function setProp} ){
  return SwitchListTile(
                  title: Text(title),
                  value: value,
                  subtitle: Text(subtitle),
                  onChanged: (newValue) {
                    setState(() {
                      setProp(newValue);
                    });
                  },
                );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text("Your Filters!"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => widget._saveFilters(widget._Filters),
            )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              "Adjust your meal selections",
              style: Theme.of(context).textTheme.title,
              ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildSwitchListTile(
                  title: 'Gluten-free',
                  subtitle: 'Only include gluten-free meals',
                  value: widget._Filters.isGlutenFree,
                  setProp: (val) => widget._Filters.isGlutenFree = val
                ),
                _buildSwitchListTile(
                  title: 'Lactose-free',
                  subtitle: 'Only include lactose-free meals',
                  value: widget._Filters.isLactoseFree,
                  setProp: (val) => widget._Filters.isLactoseFree = val
                ),
                _buildSwitchListTile(
                  title: 'vegan',
                  subtitle: 'Only include vegan meals',
                  value: widget._Filters.isVegan,
                  setProp: (val) => widget._Filters.isVegan = val
                ),
                _buildSwitchListTile(
                  title: 'vegetarian',
                  subtitle: 'Only include vegetarian meals',
                  value: widget._Filters.isVegetarian,
                  setProp: (val) => widget._Filters.isVegetarian = val
                ),
                
              ],
            ) ,)

        ],)
    );
  }
}