import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/earthquake_activity.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../ui_helper.dart';

class EarthquakeState extends State<EarthquakeActivity> {
  BuildContext _buildContext;

  Earthquake _earthquake;
  ScrollController _controller;
  bool silverCollapsed = false;
  EarthquakeState(Earthquake earthquake) {
    _earthquake = earthquake;
    initFields();
  }

  @override
  Widget build(BuildContext context) {
    final title = Text(_earthquake.properties.title);
    return Scaffold(
        backgroundColor: MyColors.white,
        body: Builder(builder: (BuildContext context) {
          _buildContext = context;
          UiHelper.setCurrentScaffoldContext(_buildContext);
          return CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: 250.0,
                backgroundColor: MyColors.getColor(_earthquake.properties.mag),
                flexibleSpace: FlexibleSpaceBar(
                  background: getMap(context, _earthquake),
                  title: getTitle(),

                ),
              ),

              SliverAnimatedList(
                initialItemCount: getPropertiesWidget().length,
                itemBuilder: _buildItem,
              ),
            ],

          );
        }));
  }

  Widget _buildItem(BuildContext context, int index,
      Animation<double> animation) {
    return getPropertiesWidget()[index];
  }

  Widget getText(IconData icon, String title, String trailing) {
    return ListTile(leading: Icon(icon),
      title: Text(title), trailing: Text(trailing),);
  }

  String getEarthquakeValidator(String s) {
    if (!Util.getStringLengthValidator(s, 6))
      return "Earthquake should be greater than 5 char";
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

  Widget getMap(BuildContext context, Earthquake earthquake) {
    return Container(
      height: 250,
      child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(earthquake.geometry.coordinates[1],
              earthquake.geometry.coordinates[0]),
          zoom: 10.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 15.0,
                height: 15.0,
                point: new LatLng(earthquake.geometry.coordinates[1],
                    earthquake.geometry.coordinates[0]),
                builder: (ctx) => Icon(
                  Icons.location_on,
                  color: MyColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _widgets;

  List<Widget> getPropertiesWidget() {
    if (_widgets != null)
      return _widgets;
    _widgets = new List();
    _widgets.add(getText(Icons.title, truncateWithEllipsis(25, "Country"),
        truncateWithEllipsis(35, _earthquake.country.toString())));

    _widgets.add(getText(Icons.title, truncateWithEllipsis(25, "Depth"),
        truncateWithEllipsis(35, _earthquake.depth.toString() + " KM")));

    _widgets.add(getText(Icons.title, truncateWithEllipsis(25, "Status"),
        truncateWithEllipsis(35, _earthquake.properties.status.toString())));

    _widgets.add(getText(Icons.title, truncateWithEllipsis(25, "Magnitude"),
        truncateWithEllipsis(35, _earthquake.properties.mag.toString())));

    _widgets.add(
        getText(Icons.title, truncateWithEllipsis(25, "Magnitude Type"),
            truncateWithEllipsis(
                35, _earthquake.properties.magType.toString())));

    _widgets.add(getText(Icons.title, truncateWithEllipsis(25, "Type"),
        truncateWithEllipsis(35, _earthquake.properties.type.toString())));

    _widgets.add(getText(Icons.title, truncateWithEllipsis(25, "Place"),
        truncateWithEllipsis(35, _earthquake.properties.place.toString())));

    _widgets.add(getText(Icons.title, truncateWithEllipsis(25, "Time"),
        truncateWithEllipsis(35, getTime())));

    _widgets.add(getText(Icons.title, truncateWithEllipsis(25, "Tsunami"),
        truncateWithEllipsis(
            35, _earthquake.properties.tsunami == 0 ? "No" : "Yes")));


    _widgets.add(getText(Icons.title, truncateWithEllipsis(25, "Significant"),
        truncateWithEllipsis(35, _earthquake.properties.sig.toString())));

    _widgets.add(
        getText(Icons.title, truncateWithEllipsis(25, "Seismic stations"),
            truncateWithEllipsis(35, _earthquake.properties.nst.toString())));

    _widgets.add(
        getText(Icons.title, truncateWithEllipsis(25, "Distance from station"),
            truncateWithEllipsis(35, _earthquake.properties.dmin.toString())));


    return _widgets;
  }


  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  void initFields() {
    _controller = ScrollController();

    _controller.addListener(() {
      if (_controller.offset > 175 && !_controller.position.outOfRange) {
        if (!silverCollapsed) {
          print('collapsed');
          silverCollapsed = true;
          setState(() {});
        }
      }
      if (_controller.offset <= 175 && !_controller.position.outOfRange) {
        if (silverCollapsed) {
          print('not collapsed');
          silverCollapsed = false;
          setState(() {});
        }
      }
    });
  }

  Widget getTitle() {
    return Row(children: <Widget>[
      silverCollapsed
          ? Text(_earthquake.properties.mag.toString(),
        style: TextStyle(color: MyColors.white),)
          : CircleAvatar(child: Text(_earthquake.properties.mag
          .toString(), style: TextStyle(color: MyColors.white)),
        backgroundColor: MyColors.getColor(_earthquake.properties.mag),),
      RichText(text: TextSpan(
          style: new TextStyle(
            fontSize: 14.0,
          ),
          children: <TextSpan>[
            TextSpan(text: "\t \t" + _earthquake.country,
                style: TextStyle(fontSize: 18.0,
                    color: silverCollapsed ? MyColors.white : MyColors.getColor(
                        _earthquake.properties.mag))),
            TextSpan(
                text: "\n\t \t" + getTimeAgo(), style: TextStyle(fontSize: 10.0,
                color: silverCollapsed ? MyColors.white : MyColors.getColor(
                    _earthquake.properties.mag)))
          ]),)
    ],);
  }

  /* Text("\t-\t" + _earthquake.country,
        style: TextStyle(
            color: silverCollapsed ? MyColors.white : MyColors.getColor(
                _earthquake.properties.mag)),)*/

  getTimeAgo() {
    return timeago.format(
        DateTime.fromMillisecondsSinceEpoch(_earthquake.properties.time))
    ;
  }

  getTime() {
    return DateFormat.yMEd()
        .add_jms()
        .format(
        new DateTime.fromMillisecondsSinceEpoch(_earthquake.properties.time));
  }
}
