import 'package:earthquake/data/model/filter.dart';
import 'package:earthquake/presantation/activity/filter_activity.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

import '../my_colors.dart';

class FilterListView {
  Widget buildItem(Filter filter, getConfirmDelete, BuildContext context,
      void Function(dynamic) refreshState) {
    return Dismissible(
      child: GestureDetector(
        child: Card(
          child: ListTile(
            leading: _getCountryFlag(filter),
            subtitle:
                filter.country != null ? Text(filter.country) : Container(),
            title: Text(
              truncateWithEllipsis(35, filter.name),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: _getMagnitude(filter),
          ),
        ),
        onTap: () => editFilter(filter, context, refreshState),
      ),
      key: Key(filter.toString()),
      confirmDismiss: (DismissDirection direction) => getConfirmDelete(filter),
      background: Container(
        color: MyColors.error,
        child: Icon(Icons.delete),
      ),
    );
  }

  Widget _getCountryFlag(Filter filter) {
    if (filter.country == null)
      return Container(
        width: 50,
      );
    try {
      return Flags.getMiniFlag(filter.countryCode, null, 50);
    } catch (e) {
      return Container(
        width: 50,
      );
    }
  }

  Widget _getMagnitude(Filter filter) {
    if (filter.minMagnitude == null) return new Container();
    return Text(
      filter.minMagnitude.toString(),
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 25, color: MyColors.getColor(filter.minMagnitude)),
    );
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    if (myString == null) return "";
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  editFilter(Filter filter, BuildContext context,
      void Function(dynamic) refreshState) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => FilterActivity(
                  filter: filter,
                ))).asStream().listen(refreshState);
  }
}
