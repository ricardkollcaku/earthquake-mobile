import 'package:earthquake/data/model/country.dart';
import 'package:earthquake/data/model/filter.dart';
import 'package:earthquake/domain/services/filter_service.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/filter_activity.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:rxdart/rxdart.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../my_colors.dart';
import '../ui_helper.dart';

class FilterState extends State<FilterActivity> {
  BuildContext _buildContext;

  final _formKey = GlobalKey<FormState>();
  Filter _filter;
  BuildContext myContext;
  List<Country> _countries;
  List<DropdownMenuItem> _dropDownCountries;
  FilterService _filterService;
  Country _selectedCountry;
  TextEditingController _filterName = new TextEditingController();
  TextEditingController _magType = new TextEditingController();
  bool _isEdit = false;

  FilterState({Filter filter}) {
    _filter = filter;
    initFields();
  }

  @override
  Widget build(BuildContext context) {
    myContext = context;
    return Scaffold(

        body: Builder(builder: (BuildContext context) {
          _buildContext = context;
          UiHelper.setCurrentScaffoldContext(_buildContext);
          return CustomScrollView(
            slivers: <Widget>[ SliverAppBar(
              pinned: true,
              expandedHeight: 200.0,
              backgroundColor: MyColors.accent,
              flexibleSpace: FlexibleSpaceBar(
                background: UiHelper.getCountryFlagMax(_filter.countryCode),
                title: Text(
                  _filter.name == null ? "Add Filter" : (_filter.name +
                      " Edit Filter"),),

              ),
            ), SliverList(
                delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return getFilterForm();
                    },
                    childCount: 1
                )),
            ]
            ,
          );;
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
      items: _dropDownCountries,
      onChanged: (value) {
        onDropDownSelect(value);
      },
      hint: Text("Select Country"),
      searchHint: Text("Select Country"),
      isExpanded: true,
      value: _selectedCountry,
      isCaseSensitiveSearch: false,
    );
  }

  String getFilterValidator(String s) {
    if (!Util.getStringLengthValidator(s, 3))
      return "Filter should be greater than 4 char";
    return null;
  }

  Widget getHintedTextFormField(String hint, bool obscure, Function onSaved,
      IconData icon, Function(String) validator, TextInputType textInput,
      TextEditingController textEditingController, bool enabled) {
    return new TextFormField(
      validator: validator,
      onSaved: onSaved,
      enabled: enabled,
      autofocus: false,
      keyboardType: textInput,
      controller: textEditingController,
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
        onPressed: saveFilter,
        padding: EdgeInsets.all(12),
        color: MyColors.accent,
        child: Text('Save Filter', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void saveFilter() {
    UiHelper.setCurrentScaffoldContext(_buildContext);

    Stream.value(_formKey.currentState.validate())
        .where((b) => b)
        .map((b) => saveState(b))
        .flatMap(
            (t) => _filterService.saveFilter(_filter))
        .toList()
        .asStream()
        .listen(onFilterSaved);

  }

  void initFields() {
    _dropDownCountries = new List();
    if (_filter != null) {
      _filterName.text = _filter.name;
      _magType.text = _filter.minMagnitude.toString();
      _isEdit = true;
    }
    if (_filter == null) {
      _filter = new Filter();
      _filter.isNotificationEnabled = false;
    }
    _filterService = new FilterService();
    _countries = new List();
    getCountries();
  }

  Filter saveState(bool b) {
    _formKey.currentState.save();
    return _filter;
  }


  setFilter(String filter) {
    _filter.name = filter;
  }

  void getCountries() {
    _filterService.getCountries().toList().asStream().flatMap((t) =>
        Stream.fromFuture(setTest(t))).listen(addCountries);
  }

  Future<List<Country>> setTest(List<Country> country) async {
    _dropDownCountries =
    await Future.value(
        country.map<DropdownMenuItem<Country>>(createDropDown).toList());
    return country;
  }

  void addCountries(List<Country> event) {
    setState(() {
      _countries = event;
      if (_filter.country != null)
        _selectedCountry =
        event.where((t) => t.country == _filter.country).toList()[0];
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
      _filter.countryCode = country.countryCode;
      _filter.country = country.country;
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

  void onFilterSaved(dynamic event) {
    Navigator.of(myContext).pop(true);
  }

  String getMinMagnitudeValidator(String mag) {
    if (!Util.getStringLengthValidator(mag, 1))
      return "Filter should be greater than 0 char";
    return null;
  }


  void setMagnitude(String string) {
    _filter.minMagnitude = double.parse(string);
  }

  Widget getNotification() {
    return SwitchListTile(
      value: _filter.isNotificationEnabled,
      title: Text("Earthquake Notifications"),
      onChanged: setNotification,
    );
  }

  void setNotification(bool value) {
    setState(() {
      _filter.isNotificationEnabled = value;
    });
  }

  Widget getFilterForm() {
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
              getHintedTextFormField(
                  "Filter Name",
                  false,
                  setFilter,
                  Icons.title,
                  getFilterValidator,
                  TextInputType.text,
                  _filterName,
                  !_isEdit),
              SizedBox(height: 24.0),
              getHintedTextFormField(
                  "minimum magnitude",
                  false,
                  setMagnitude,
                  Icons.mobile_screen_share,
                  getMinMagnitudeValidator,
                  TextInputType.number,
                  _magType,
                  true),
              SizedBox(height: 24.0),
              getCountriesDropdown(),

              SizedBox(height: 24.0),
              getNotification(),

              SizedBox(height: 24.0),
              getSaveFilterButton(),
            ],
          ),
        ),
        onTap: removeFocus,
      ),
    );
  }
}
