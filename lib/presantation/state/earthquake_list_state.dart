import 'dart:async';

import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/domain/services/earthquake_service.dart';
import 'package:earthquake/presantation/fragment/earthquake_list_fragment.dart';
import 'package:earthquake/presantation/view/earthquake_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:loadany/loadany.dart';
import 'package:rxdart/rxdart.dart';

import '../my_colors.dart';

class EarthquakeListState extends State<EarthquakeListFragment> {

  Set<Earthquake> _earthquakeList;
  LoadStatus _status = LoadStatus.normal;
  EarthquakeListView _earthquakeListView;
  int _pageNumber, _elementPerPage;
  ScrollController _controller;
  EarthquakeService _earthquakeService;
  bool silverCollapsed = false;

  EarthquakeListState() {
    initField();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return LoadAny(
        onLoadMore: getLoadMore,
        status: _status,
        footerHeight: 40,
        endLoadMore: true,
        bottomTriggerDistance: 200,
        loadMoreBuilder: _earthquakeListView.loadMoreBuilder,
        child: CustomScrollView(
          controller: _controller, slivers: <Widget>[ SliverAppBar(
          pinned: true,
          expandedHeight: 300.0,
          backgroundColor: MyColors.accent,
          flexibleSpace: FlexibleSpaceBar(
            background: getMap(context),
            title: Text("Earthquake",),

          ),
        ), SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return _earthquakeListView.buildItem(
                    _earthquakeList.elementAt(index));
              },
              childCount: (_earthquakeList?.length ?? 0),
            )),
        ]
          ,
        )
    );
  }

  Widget getMap(BuildContext context) {
    return Container(
      height: 300,
      child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(0, 0),
          zoom: 1,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          new MarkerLayerOptions(
            markers: getMarkers(),

          ),
        ],
      ),
    );
  }

LatLng center = new LatLng(0,0);
  List<Marker> getMarkers() {

    return _earthquakeList.map((t) =>
    new Marker(
      width: 15.0,
      height: 15.0,
      point: new LatLng(t.geometry.coordinates[1],
          t.geometry.coordinates[0]),
      builder: (ctx) =>
          Icon(
            Icons.location_on,
            color: MyColors.error,
          ),
    )).toList();
  }
  void initField() {
    _earthquakeList = new Set();
    _earthquakeService = new EarthquakeService();
    _earthquakeListView = new EarthquakeListView(40, getLoadMore,context);
    _pageNumber = 0;
    _elementPerPage = 50;
    getData(addRefreshing);


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

  Future<void> getLoadMore() {
    setStatus(LoadStatus.loading);
    return getData(addItems);
  }

  Future<void> getRefresh() {
    _earthquakeList = new Set();
    _pageNumber = 0;
    return getData(addRefreshing);
  }

  Future<void> getData(Function function) {
    return _earthquakeService.getAllEarthquakes(_pageNumber, _elementPerPage)
        .doOnError(doOnError)
        .toList()
        .asStream()
        .map(function)
        .listen(onData)
        .asFuture();
  }


  setStatus(LoadStatus loadStatus) {
    setState(() {
      _status = loadStatus;
    });
  }


  List<Earthquake> addItems(List<Earthquake> event) {
    if (event.length < _elementPerPage) {
      _earthquakeList.addAll(event);
      setStatus(LoadStatus.completed);
    }
    else {
      _earthquakeList.addAll(event);
      setStatus(LoadStatus.normal);
    }
    _pageNumber++;
    return event;
  }

  List<Earthquake> addRefreshing(List<Earthquake> event) {
    if (event.length < _elementPerPage) {
      _earthquakeList.addAll(event);
      setStatus(LoadStatus.completed);
    }
    else {
      _earthquakeList.addAll(event);
    }
    setState(() {

    });
    _pageNumber++;
    return event;
  }


  void onData(void event) {
  }

  void doOnError(dynamic notification) {
    setStatus(LoadStatus.error);
  }


}


