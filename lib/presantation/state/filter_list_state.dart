import 'package:earthquake/data/model/filter.dart';
import 'package:earthquake/domain/services/filter_service.dart';
import 'package:earthquake/presantation/fragment/filter_list_fragment.dart';
import 'package:earthquake/presantation/provider/app_bar_provider.dart';
import 'package:earthquake/presantation/view/filter_list_view.dart';
import 'package:flutter/material.dart';

import '../my_colors.dart';

class FilterListState extends State<FilterListFragment> {
  List<Filter> _filterList;
  FilterListView _filterListView;
  FilterService _filterService;
  AppBarProvider _appBarProvider;
  GlobalKey<ScaffoldState> _scaffoldKey;

  FilterListState(GlobalKey<ScaffoldState> scaffoldKey) {
    _scaffoldKey = scaffoldKey;
    initField();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _appBarProvider.context = context;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          iconTheme: IconThemeData(color: Colors.white, size: 10.0),
          actions: _appBarProvider.getActions(_scaffoldKey),
          pinned: true,
          expandedHeight: 200.0,
          backgroundColor: MyColors.accent,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              "https://img.freepik.com/free-vector/earthqauke-background-scene_1308-25987.jpg?size=626&ext=jpg",
              fit: BoxFit.cover,
            ),
            title: Text(
              "My Filters",
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return _filterListView.buildItem(
                _filterList[index], getConfirmDelete, context, refreshState);
          },
          childCount: _filterList.length,
        )),
      ],
    );

    return ListView.builder(
        itemCount: _filterList.length,
        itemBuilder: (BuildContext context, int index) {
          return _filterListView.buildItem(
              _filterList[index], getConfirmDelete, context, refreshState);
        });
  }

  Future<bool> getConfirmDelete(Filter filter) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm"),
            content: const Text("Are you sure you wish to delete this item?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => deleteFilter(filter),
                  child: const Text("DELETE")),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("CANCEL"),
              )
            ],
          );
        });
  }

  void initField() {
    _filterList = new List();
    _filterService = new FilterService();
    _filterListView = new FilterListView();
    _appBarProvider = new AppBarProvider(context);
    getData(addRefreshing);
  }

  Future<void> getData(Function function) {
    return _filterService
        .getAllFilters()
        .toList()
        .asStream()
        .map(function)
        .listen(onData)
        .asFuture();
  }

  List<Filter> addRefreshing(List<Filter> event) {
    setState(() {
      _filterList.addAll(event);
    });
    return event;
  }

  void onData(void event) {}

  deleteFilter(Filter filter) {
    _filterService
        .remove(filter)
        .listen((s) => Navigator.of(context).pop(true));
  }

  void refreshState(dynamic a) {
    _filterList = new List();
    getData(addRefreshing).asStream().listen(onData);
  }
}
