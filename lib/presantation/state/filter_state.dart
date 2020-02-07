import 'package:earthquake/data/model/country.dart';
import 'package:earthquake/data/model/filter.dart';
import 'package:earthquake/domain/services/filter_service.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/filter_activity.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../my_colors.dart';
import '../ui_helper.dart';

class FilterState extends State<FilterActivity> {
  BuildContext _buildContext;

  final _formKey = GlobalKey<FormState>();
  Filter _filter;
  List<Country> _countries;
  FilterService _filterService;
  Country _selectedCountry;

  FilterState({Filter filter}) {
    _filter = filter;
    initFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Filter'),
        ),
        body: Builder(builder: (BuildContext context) {
          _buildContext = context;
          UiHelper.setCurrentScaffoldContext(_buildContext);
          return Form(
            key: _formKey,
            child: GestureDetector(
              child: Card(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    getLogo(),
                    SizedBox(height: 8.0),
                    getHintedTextFormField("Filter Name", false, setFilter,
                        Icons.lock, getFilterValidator),
                    SizedBox(height: 24.0),
                    getCountriesDropdown(),

                    /*   SizedBox(height: 24.0),
                    getMap(context),*/
                    SizedBox(height: 24.0),
                    getSaveFilterButton(),
                  ],
                ),
              ),
              onTap: removeFocus,
            ),
          );
        }));
  }

  Widget getLogo() {
    return Container();
  }

  void removeFocus() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Widget getCountriesDropdown() {
    return SearchableDropdown(
      items: _countries.map<DropdownMenuItem<Country>>(createDropDown).toList(),
      onChanged: (value) {
        onDropDownSelect(value);
      },
      hint: Text("Select Country"),
      searchHint: Text("Select 1 country"),
      isExpanded: true,
      value: _selectedCountry,
      isCaseSensitiveSearch: false,
    );
  }

  String getFilterValidator(String s) {
    if (!Util.getStringLengthValidator(s, 6))
      return "Filter should be greater than 5 char";
    return null;
  }

  Widget getHintedTextFormField(String hint, bool obscure, Function onSaved,
      IconData icon, Function(String) validator) {
    return new TextFormField(
      validator: validator,
      onSaved: onSaved,
      autofocus: false,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget getSaveFilterButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: changeFilter,
        padding: EdgeInsets.all(12),
        color: MyColors.accent,
        child: Text('Save Filter', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void changeFilter() {
    UiHelper.setCurrentScaffoldContext(_buildContext);
  }

  void initFields() {
    if (_filter == null) _filter = new Filter();
    _filterService = new FilterService();
    _countries = new List();
    getCountries();
  }

  Filter saveState(bool b) {
    _formKey.currentState.save();
    return _filter;
  }

  onSuccess(bool user) {
    Navigator.pop(_buildContext);
  }

  setFilter(String filter) {}

  void getCountries() {
    _filterService.getCountries().toList().asStream().listen(addCountries);
  }

  void addCountries(List<Country> event) {
    setState(() {
      _countries = event;
    });
  }

  Widget _getCountryFlag(String countryCode) {
    if (countryCode == null)
      return Container(
        width: 15,
        height: 15,
      );
    try {
      return Flags.getMiniFlag(countryCode, null, 30);
    } catch (e) {
      return Container(
        width: 15,
        height: 15,
      );
    }
  }

  DropdownMenuItem<Country> createDropDown(Country e) {
    return new DropdownMenuItem(
        child: ListTile(
          leading: _getCountryFlag(e.countryCode),
          title: Text(e.country),
          trailing: e.countryCode == null
              ? Container(
            width: 15,
            height: 15,
          )
              : Text(e.countryCode),
        ),
        value: e);
  }

  void onDropDownSelect(Country country) {
    setState(() {
      _selectedCountry = country;
    });
  }


  Widget getMap(BuildContext context) {
    return Container(height: 300, child: FlutterMap(
      options: new MapOptions(
        center: new LatLng(51.5, -0.09),
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",

        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 80.0,
              height: 80.0,
              point: new LatLng(51.5, -0.09),
              builder: (ctx) =>
              new Container(
                //,
              ),
            ),
          ],
        ),
      ],
    ),);
  }
}
