import 'package:earthquake/data/model/choice.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/presantation/activity/main_non_login_activity.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarProvider {
  BuildContext _context;
  UserService _userService;

  AppBarProvider(BuildContext context) {
    _context = context;
    _userService = new UserService();
  }

  GlobalKey<ScaffoldState> _scaffoldKey;
  set context(BuildContext value) {
    _context = value;
  }


  List<Widget> getActions(GlobalKey<ScaffoldState> scaffoldKey) {
    _scaffoldKey = scaffoldKey;
    return <Widget>[
      PopupMenuButton<Choice>(
        onSelected: _onMenuSelected,
        itemBuilder: (BuildContext context) {
          return (UserService.user == null ? _choicesNotLogedin : _choices)
              .map((Choice choice) {
            return PopupMenuItem<Choice>(
                value: choice, child: Text(choice.prop1));
          }).toList();
        },
      ),
    ];
  }

  List<Widget> getNonLoginActions(Function onCall,
      GlobalKey<ScaffoldState> scaffoldKey) {
    _scaffoldKey = scaffoldKey;
    return <Widget>[
      IconButton(icon: Icon(Icons.search,color: MyColors.white,),onPressed: onCall,),
      PopupMenuButton<Choice>(
        onSelected: _onMenuSelected,
        itemBuilder: (BuildContext context) {
          return (UserService.user == null ? _choicesNotLogedin : _choices)
              .map((Choice choice) {
            return PopupMenuItem<Choice>(
                value: choice, child: Text(choice.prop1));
          }).toList();
        },
      ),
    ];
  }

  void _onMenuSelected(Choice value) {
    if (value == _choices[0] || value == _choicesNotLogedin[0]) _about(
        _scaffoldKey);
    if (value == _choices[1]) logout();

  }

  List<Choice> _choices = <Choice>[
    Choice(prop1: 'About', prop2: Icons.phone),
    Choice(prop1: 'Logout', prop2: Icons.exit_to_app),
  ];

  List<Choice> _choicesNotLogedin = <Choice>[
    Choice(prop1: 'About', prop2: Icons.phone),
  ];


  void logout() {
    _userService.logout().listen(onData);
    Navigator.of(_context).pushReplacementNamed(MainNonLoginActivity.tag);
  }

  void _about(GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return DecoratedBox(
        decoration: BoxDecoration(color: Colors.transparent),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
          child: Container(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 10,
                        top: 10,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 30.0,
                            color: MyColors.accent,
                          ),
                        ),
                      )
                    ],
                  ),
                  height: 50,
                  width: 50,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 140,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: Align(
                                child: Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: MyColors.accent),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                            Positioned(
                              child: Container(
                                child: Text(
                                  "ABOUT",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 20, top: 60, left: 20, right: 20),
                        child: Text(getAboutText(),),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            height: MediaQuery
                .of(context)
                .size
                .height / 1.3,
            width: MediaQuery
                .of(context)
                .size
                .width,
            color: Colors.white,
          ),

        ),
      );
    });
  }
  void onData(bool event) {}

  String getAboutText() {
    return "This App is created by Ricard Kollcaku.\n" +
        "This is not a profitable App is totally free and we dont run adds to generate money.\n" +
        "For any suggestion please contact me.\n" +
        "If you want to be part in mentaining and developing new features plese conntact me.\n" +
        "If you eant to help with design (logo colors) please conntact.\n" +
        "This app (mobile and server) will be soon published opensource in GitHub.\n" +
        "Contact info: richard.kollcaku@gmail.com";
  }
}
