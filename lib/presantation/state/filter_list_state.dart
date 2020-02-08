import 'package:earthquake/data/model/filter.dart';
import 'package:earthquake/domain/services/filter_service.dart';
import 'package:earthquake/presantation/fragment/filter_list_fragment.dart';
import 'package:earthquake/presantation/view/filter_list_view.dart';
import 'package:flutter/material.dart';

class FilterListState extends State<FilterListFragment> {

  List<Filter> _filterList;
  FilterListView _filterListView;
  FilterService _filterService;

  FilterListState() {
    initField();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: _filterList.length,
        itemBuilder: (BuildContext context, int index) {
          return _filterListView.buildItem(
              _filterList[index], getConfirmDelete,context,refreshState);
        }
    );
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
    getData(addRefreshing);
  }


  Future<void> getData(Function function) {
    return _filterService.getAllFilters()
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


  void onData(void event) {
  }


  deleteFilter(Filter filter) {
    _filterService.remove(filter).listen((s) =>
        Navigator.of(context).pop(true));
  }

 void refreshState(dynamic a) {
    _filterList = new List();
     getData(addRefreshing).asStream().listen(onData);
  }




}
