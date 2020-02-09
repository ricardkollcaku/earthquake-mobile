import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/earthquake_activity.dart';
import 'package:earthquake/presantation/activity/filter_activity.dart';
import 'package:earthquake/presantation/provider/map_provider.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:earthquake/presantation/my_icons.dart';
import 'package:earthquake/presantation/ui_helper.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loadany/loadany.dart';


class EarthquakeListView {
  double _loadingFooterHeight;
  Function _loadMore;
  BuildContext _context;

  EarthquakeListView(this._loadingFooterHeight, this._loadMore,this._context);

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
    _context=context;
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
    return GestureDetector(onTap: () => openEarthquake(earthquake), child: Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              earthquake.properties.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: UiHelper.getCountryFlag(earthquake.countryCode),
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
                              Text(truncateWithEllipsis(
                                  35, MapProvider.getDistanceInKm(earthquake.geometry)),
                                overflow: TextOverflow.ellipsis,)
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
                              Text(Util.getLocalTimeAgoAndTime(earthquake.properties.time))
                            ],
                          ),
                        ],
                      ),
                      earthquake.properties.tsunami == 0
                          ? Row(
                        children: <Widget>[
                          _getMagnitude(earthquake)


                          /* Image.asset(
                                  MyIcons.TSUNAMI,
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 3,
                                )*/
                        ],
                      )
                          : Container(),
                    ],
                  ),
                )
              ],
            )
          ],
        )
        ,
      )
      ,
    ),);
  }





  Widget _getMagnitude(Earthquake earthquake) {
    if (earthquake.properties.mag == null)
      return new Container();
    if (earthquake.properties.tsunami == 0)
      return Text(
        earthquake.properties.mag.toStringAsPrecision(2),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 25,
            color: MyColors.getColor(earthquake.properties.mag)),
      );
    return Column(children: <Widget>[
      Image.asset(MyIcons.TSUNAMI, width: 25, height: 25,), Text(
        earthquake.properties.mag.toString(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 20,
            color:  MyColors.getColor(earthquake.properties.mag)),
      )
    ],);
  }


  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  openEarthquake(Earthquake earthquake) {
    print(_context);
    Navigator.push(_context, MaterialPageRoute(builder: (BuildContext context) => EarthquakeActivity(earthquake)));


  }
}
