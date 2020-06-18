import 'dart:async';

import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/data/model/filter.dart';
import 'package:earthquake/domain/services/earthquake_service.dart';
import 'package:earthquake/presantation/activity/filter_activity.dart';
import 'package:earthquake/presantation/fragment/earthquake_list_fragment.dart';
import 'package:earthquake/presantation/provider/app_bar_provider.dart';
import 'package:earthquake/presantation/view/earthquake_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:loadany/loadany.dart';
import 'package:rxdart/rxdart.dart';

import '../my_colors.dart';
import '../ui_helper.dart';

class EarthquakeListState extends State<EarthquakeListFragment> {
  Set<Earthquake> _earthquakeList;
  LoadStatus _status = LoadStatus.normal;
  EarthquakeListView _earthquakeListView;
  int _pageNumber, _elementPerPage;
  ScrollController _controller;
  EarthquakeService _earthquakeService;
  bool silverCollapsed = false;
  AppBarProvider _appBarProvider;
  bool _isLogin = true;
  Filter _localNotLoginUserFilter;
  GlobalKey<ScaffoldState> _scaffoldKey;

  EarthquakeListState(GlobalKey<ScaffoldState> scaffoldKey) {
    _scaffoldKey = scaffoldKey;
    initField();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _appBarProvider.context = context;

    return RefreshIndicator(
      child: LoadAny(
          onLoadMore: getLoadMore,
          status: _status,
          footerHeight: 40,
          endLoadMore: true,
          bottomTriggerDistance: 200,
          loadMoreBuilder: _earthquakeListView.loadMoreBuilder,
          child: CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              SliverAppBar(
                actions: _isLogin
                    ? _appBarProvider.getActions(_scaffoldKey)
                    : _appBarProvider.getNonLoginActions(
                        onLocalSearchClicked, _scaffoldKey),
                pinned: true,
                iconTheme: IconThemeData(color: Colors.white, size: 10.0),
                expandedHeight: 300.0,
                backgroundColor: MyColors.accent,
                flexibleSpace: FlexibleSpaceBar(
                  background: getMap(context),
                  title: Text(
                    "Earthquake",
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _earthquakeListView
                      .buildItem(_earthquakeList.elementAt(index));
                },
                childCount: (_earthquakeList?.length ?? 0),
              )),
            ],
          )),
      onRefresh: getRefresh,
    );
  }

  onLocalSearchClicked() async {
    _localNotLoginUserFilter = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
          builder: (context) => FilterActivity(
                actAsDialog: true,
                filter: _localNotLoginUserFilter,
              )),
    );
    await getRefresh();
  }

  Widget getMap(BuildContext context) {
    return Container(
      height: 300,
      child: FlutterMap(
        options: new MapOptions(plugins: [
          MarkerClusterPlugin(),
        ], center: new LatLng(0, 0), zoom: 1, minZoom: 1),
        layers: [
          UiHelper.getMapTile(),
          new MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            size: Size(40, 40),
            fitBoundsOptions: FitBoundsOptions(
              padding: EdgeInsets.all(50),
            ),
            markers: getMarkers(),
            polygonOptions: PolygonOptions(
                borderColor: Colors.blueAccent,
                color: Colors.black12,
                borderStrokeWidth: 3),
            builder: (context, markers) {
              return FloatingActionButton(
                heroTag: markers,
                child: Text(
                  markers.length.toString(),
                  style: TextStyle(color: MyColors.white),
                ),
                onPressed: null,
              );
            },
          ),
        ],
      ),
    );
  }

  LatLng center = new LatLng(0, 0);

  List<Marker> getMarkers() {
    return _earthquakeList
        .map((t) => new Marker(
              width: 35.0,
              height: 35.0,
              point: new LatLng(
                  t.geometry.coordinates[1], t.geometry.coordinates[0]),
              builder: (ctx) => IconButton(
                icon: Icon(
                  Icons.location_on,
                  size: 35,
                ),
                onPressed: () => _earthquakeListView.openEarthquake(t),
                color: MyColors.getColor(t.properties.mag),
              ),
            ))
        .toList();
  }

  void initField() {
    _earthquakeList = new Set();
    _earthquakeService = new EarthquakeService();
    _earthquakeService.isLogin().listen((b) => _isLogin = b);
    _earthquakeListView = new EarthquakeListView(40, getLoadMore, context);
    _pageNumber = 0;
    _elementPerPage = 24;
    _appBarProvider = new AppBarProvider(context);
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
    return _earthquakeService
        .getAllEarthquakes(_pageNumber, _elementPerPage,
            filter: _localNotLoginUserFilter)
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
    } else {
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
    } else {
      _earthquakeList.addAll(event);
    }
    setState(() {});
    _pageNumber++;
    return event;
  }

  void onData(void event) {}

  void doOnError(dynamic notification) {
    setStatus(LoadStatus.error);
  }
}
