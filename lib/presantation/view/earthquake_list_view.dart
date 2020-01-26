import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:earthquake/presantation/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loadany/loadany.dart';

class EarthquakeListView {
  double _loadingFooterHeight;
  Function _loadMore;

  EarthquakeListView(this._loadingFooterHeight, this._loadMore);

  Widget _buildLoading(double height) {
    return Container(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
            width: 20,
            height: 20,
          ),
          SizedBox(width: 10),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 12,
              color: MyColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget loadMoreBuilder(BuildContext context, LoadStatus status) {
    if (status == LoadStatus.loading) {
      return _buildLoading(_loadingFooterHeight);
    } else if (status == LoadStatus.error) {
      return _buildLoadError(_loadingFooterHeight);
    } else if (status == LoadStatus.completed) {
      return _buildLoadFinish(_loadingFooterHeight);
    }
    return Container();
  }

  Widget _buildLoadError(double loadingFooterHeight) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_loadMore != null) {
          _loadMore();
        }
      },
      child: Container(
        height: _loadingFooterHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              color: MyColors.error,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'Error loading data',
              style: TextStyle(
                fontSize: 12,
                color: MyColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadFinish(double loadingFooterHeight) {
    return Container(
      height: _loadingFooterHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 10,
            child: Divider(
              color: MyColors.primaryDark,
            ),
          ),
          SizedBox(width: 6),
          Text(
            'Finished...',
            style: TextStyle(
              fontSize: 12,
              color: MyColors.primaryDark,
            ),
          ),
          SizedBox(width: 6),
          SizedBox(
            width: 10,
            child: Divider(
              color: MyColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(Earthquake earthquake) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              earthquake.properties.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Text(
                    earthquake.properties.mag.toString(),
                    style: TextStyle(
                        fontSize: 30,
                        color: earthquake.properties.mag > 4
                            ? MyColors.error
                            : MyColors.positive),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.my_location,
                                size: 20,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(earthquake.properties.place)
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                size: 20,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(getTime(earthquake.properties.time))
                            ],
                          ),
                        ],
                      ),
                      earthquake.properties.tsunami == 1
                          ? Row(
                              children: <Widget>[
                                Image.asset(
                                  MyIcons.TSUNAMI,
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 3,
                                )
                              ],
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  getTime(int time) {
    return DateFormat.yMEd()
        .add_jms()
        .format(new DateTime.fromMillisecondsSinceEpoch(time));
  }
}
