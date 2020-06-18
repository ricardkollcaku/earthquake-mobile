import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/chat_activity.dart';
import 'package:earthquake/presantation/activity/earthquake_activity.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:earthquake/presantation/provider/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

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
    return Scaffold(
     floatingActionButton:   FloatingActionButton(child: Icon(Icons.chat),onPressed: openChat,),
        backgroundColor: MyColors.white,
        body: Builder(builder: (BuildContext context) {
          _buildContext = context;
          UiHelper.setCurrentScaffoldContext(_buildContext);
          return CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(color: Colors.white, size: 10.0),
                pinned: true,
                expandedHeight: 300.0,
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


  Widget getMap(BuildContext context, Earthquake earthquake) {
    return Container(
      height: 300,
      child: FlutterMap(
        options: new MapOptions(
            center: new LatLng(earthquake.geometry.coordinates[1],
                earthquake.geometry.coordinates[0]),
            zoom: 8.0,
            minZoom: 1

        ),
        layers: [
          UiHelper.getMapTile(),

          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 35.0,
                height: 35.0,
                point: new LatLng(earthquake.geometry.coordinates[1],
                    earthquake.geometry.coordinates[0]),
                builder: (ctx) => Icon(
                  Icons.location_on,
                  size: 35,
                  color: MyColors.getColor(earthquake.properties.mag),
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
    if (_earthquake.properties.title != null)
      _widgets.add(getText(Icons.title, truncateWithEllipsis(25, "Title"),
          truncateWithEllipsis(35, _earthquake.properties.title.toString())));
    if (_earthquake.country != null)
      _widgets.add(getText(Icons.place, truncateWithEllipsis(25, "Country"),
          truncateWithEllipsis(35, _earthquake.country.toString())));

    _widgets.add(
        getText(Icons.mobile_screen_share, truncateWithEllipsis(25, "Distance"),
        truncateWithEllipsis(35, MapProvider.getDistanceInKm(_earthquake.geometry))));
    if (_earthquake.properties.place != null)
      _widgets.add(getText(Icons.gps_fixed, truncateWithEllipsis(25, "Place"),
          truncateWithEllipsis(35, _earthquake.properties.place.toString())));
    if (_earthquake.properties.mag != null)
      _widgets.add(
          getText(Icons.directions_run, truncateWithEllipsis(25, "Magnitude"),
              truncateWithEllipsis(35, _earthquake.properties.mag.toString())));
    if (_earthquake.properties.magType != null)
    _widgets.add(
        getText(Icons.settings, truncateWithEllipsis(25, "Magnitude Type"),
            truncateWithEllipsis(
                35, _earthquake.properties.magType.toString())));
    if (_earthquake.depth != null)
      _widgets.add(getText(Icons.broken_image, truncateWithEllipsis(25, "Depth"),
          truncateWithEllipsis(35, _earthquake.depth.toString() + " KM")));
    if (_earthquake.properties.status != null)
      _widgets.add(getText(Icons.beenhere, truncateWithEllipsis(25, "Status"),
          truncateWithEllipsis(35, _earthquake.properties.status.toString())));

    if (_earthquake.properties.type != null)
      _widgets.add(getText(Icons.merge_type, truncateWithEllipsis(25, "Type"),
          truncateWithEllipsis(35, _earthquake.properties.type.toString())));

    if (_earthquake.properties.time != null)
      _widgets.add(getText(Icons.timer, truncateWithEllipsis(25, "Local Time"),
          truncateWithEllipsis(35, Util.getLocalTime(_earthquake.properties.time))));

    if (_earthquake.properties.tsunami != null)
      _widgets.add(getText(Icons.warning, truncateWithEllipsis(25, "Tsunami"),
          truncateWithEllipsis(
              35, _earthquake.properties.tsunami == 0 ? "No" : "Yes")));

    if (_earthquake.properties.sig != null)
      _widgets.add(
          getText(Icons.timeline, truncateWithEllipsis(25, "Significant"),
              truncateWithEllipsis(35, _earthquake.properties.sig.toString())));
    if (_earthquake.properties.nst != null)
      _widgets.add(
          getText(
              Icons.gps_not_fixed, truncateWithEllipsis(25, "Recorded in"),
              truncateWithEllipsis(35,
                  _earthquake.properties.nst == null ? "0" : _earthquake
                      .properties.nst.toString() + " Seismic stations")));
    if (_earthquake.properties.dmin != null)
    _widgets.add(
        getText(Icons.play_for_work,
            truncateWithEllipsis(25, "Distance from station"),
            truncateWithEllipsis(35,
                (_earthquake.properties.dmin * 111.2).toStringAsPrecision(3) +
                    " KM")));

    _widgets.add(SizedBox(height: 150,));


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
      SizedBox(width: 5.0),
      RichText(text: TextSpan(
          style: new TextStyle(
            fontSize: 14.0,
          ),
          children: <TextSpan>[
            TextSpan(text: _earthquake.country+"\n",
                style: TextStyle(fontSize: 18.0,
                    color: silverCollapsed ? MyColors.white : MyColors.getColor(
                        _earthquake.properties.mag))),
            TextSpan(
                text: Util.getLocalTimeAgo(_earthquake.properties.time), style: TextStyle(fontSize: 12.0,
                color: silverCollapsed ? MyColors.white : MyColors.getColor(
                    _earthquake.properties.mag)))
          ]),)
    ],);
  }

  openChat() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatActivity()));  }

  /* Text("\t-\t" + _earthquake.country,
        style: TextStyle(
            color: silverCollapsed ? MyColors.white : MyColors.getColor(
                _earthquake.properties.mag)),)*/




}
