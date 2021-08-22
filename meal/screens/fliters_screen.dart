// import 'dart:convert';

import 'package:flutter/material.dart';
import '../widget/main_drawer.dart';
// import '../dummy_data.dart.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  final Function saveFliters;
  final Map<String, bool> currentFilters;
  FiltersScreen(this.currentFilters, this.saveFliters);
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _glutenFree = false;
  bool _vegan = false;
  bool _vegetarian = false;
  bool _lactoseFree = false;

  @override
  initState() {
    _glutenFree = widget.currentFilters['gluten'];
    _lactoseFree = widget.currentFilters['lactose'];
    _vegan = widget.currentFilters['vegan'];
    _vegetarian = widget.currentFilters['vegetarian'];
    super.initState();
  }

  Widget buldSwitchListTile(BuildContext ctx, String title, String subtitle,
      bool value, Function update) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: update,
    );
  }

  // FiltersScreen({})
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your'),
        actions: [
          IconButton(
              onPressed: () {
                final selectedFilters = {
                  'gluten': _glutenFree,
                  'lactose': _lactoseFree,
                  'vegan': _vegan,
                  'vegetarian': _vegetarian,
                };
                widget.saveFliters(selectedFilters);
              },
              icon: Icon(Icons.save)),
        ],
      ),
      drawer: MainDrawer(),
      body: Center(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              buldSwitchListTile(context, 'Gluten-free',
                  'Only include gluten free meal', _glutenFree, (newValue) {
                setState(() {
                  _glutenFree = newValue;
                });
              }),
              buldSwitchListTile(context, 'Lactose-free',
                  'Only include Lactose-free meals', _lactoseFree, (newValue) {
                setState(() {
                  _lactoseFree = newValue;
                });
              }),
              buldSwitchListTile(context, 'Vegetarian',
                  'Only include vegetarian meals', _vegetarian, (newValue) {
                setState(() {
                  _vegetarian = newValue;
                });
              }),
              buldSwitchListTile(
                  context, 'Vegan', 'Only include Vegan meals', _vegan,
                  (newValue) {
                setState(() {
                  _vegan = newValue;
                });
              })
            ],
          )),
        ],
      )),
    );
  }
}
