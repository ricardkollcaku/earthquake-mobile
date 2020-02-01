import 'dart:async';

import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/domain/services/earthquake_service.dart';
import 'package:earthquake/presantation/fragment/earthquake_list_fragment.dart';
import 'package:earthquake/presantation/view/earthquake_list_view.dart';
import 'package:flutter/material.dart';
import 'package:loadany/loadany.dart';
import 'package:rxdart/rxdart.dart';

class EarthquakeListState extends State<EarthquakeListFragment> {

  Set<Earthquake> _earthquakeList;
  LoadStatus _status = LoadStatus.normal;
  EarthquakeListView _earthquakeListView;
  int _pageNumber, _elementPerPage;
  EarthquakeService _earthquakeService;

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
        child: CustomScrollView(slivers: <Widget>[ SliverList(
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


  void initField() {
    _earthquakeList = new Set();
    _earthquakeService = new EarthquakeService();
    _earthquakeListView = new EarthquakeListView(40, getLoadMore);
    _pageNumber = 0;
    _elementPerPage = 50;
    getData(addRefreshing);
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


