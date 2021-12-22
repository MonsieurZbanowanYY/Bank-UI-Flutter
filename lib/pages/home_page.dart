import 'package:bank_ui/data/activities.dart';
import 'package:bank_ui/data/user.dart';
import 'package:bank_ui/model/account_model.dart';

import 'package:bank_ui/model/activity_model.dart';

import 'package:bank_ui/widgets/account_widget.dart';
import 'package:bank_ui/widgets/activity_widget.dart';
import 'package:bank_ui/widgets/bottom_bar.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  DateTime today = DateTime(
    2021,
    11,
    25,
    12,
  );

  //! fake today - only for debug, use DateTime.now() instead.
  //TODO change fake today to DateTime.now()
  int _sortValue = 0;

  int _cardIndex = 0;
  String _currentAccNumber = "";

  bool _isGoUpVisible = false;
  final ScrollController _lvController = ScrollController();
  final int _lvDefaultMax = 10;
  int _lvCurrentMax = 10;
  List<Activity> _filtredActivities = [];
  List<Activity> _lvActivities = [];

  @override
  void initState() {
    super.initState();

    _lvController.addListener(listenScrolling);
  }

  _getMoreActivities() {
    for (int i = _lvCurrentMax;
        i < _lvCurrentMax + _lvDefaultMax && i < _filtredActivities.length;
        i++) {
      _lvActivities.add(_filtredActivities[i]);
    }
    _lvCurrentMax = _lvCurrentMax + _lvDefaultMax;
    setState(() {});
  }

  void listenScrolling() {
    if (_lvController.position.pixels ==
        _lvController.position.maxScrollExtent) {
      _getMoreActivities();
    }
    if (_lvController.position.pixels > 500 && _isGoUpVisible == false) {
      setState(() {
        _isGoUpVisible = true;
      });
    } else if (_lvController.position.pixels < 500 && _isGoUpVisible == true) {
      setState(() {
        _isGoUpVisible = false;
      });
    }
  }

  List<AccountModel> accounts = [
    AccountModel(
      "eAccount Deluxe",
      "01/22",
      false,
      '$userFirstName $userSurname',
      "PL17114020040000310281356268",
      '33,200.00',
      Colors.white,
      Colors.black,
    ),
    AccountModel(
      "eAccount Company",
      "12/23",
      false,
      'Cool company name',
      "PL00000000000000000000000000",
      '200.00',
      Colors.pink,
      Colors.white,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    if (_currentAccNumber == "") {
      _currentAccNumber = accounts[0].accNumber;
    }

    sortAndFiltr();

    var size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomBarWidget(
          currentIndex: currentIndex,
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                controller: _lvController,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.03,
                      bottom: size.height * 0.015,
                      left: size.width * 0.05,
                      right: size.width * 0.05,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.75,
                          child: Text(
                            'Hi, $userFirstName',
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              fontSize: size.height * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const CircleAvatar(
                          radius: 20,
                          foregroundImage: AssetImage(
                            'assets/avatar.png',
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.05,
                      right: size.width * 0.05,
                    ),
                    child: const Divider(
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                    ),
                    child: Stack(
                      children: [
                        // build accounts slider
                        CarouselSlider.builder(
                          itemCount: accounts.length,
                          itemBuilder: (context, i, ri) {
                            return AccountBuild(
                              accName: accounts[i].accName,
                              validThru: accounts[i].validThru,
                              transfer: accounts[i].transfer,
                              accOwner: accounts[i].accOwner,
                              accNumber: accounts[i].accNumber,
                              balance: accounts[i].balance,
                              bgColor: accounts[i].bgColor,
                              fontColor: accounts[i].fontColor,
                            );
                          },
                          options: CarouselOptions(
                            initialPage: _cardIndex,
                            onPageChanged: (index, reason) {
                              _lvCurrentMax = _lvDefaultMax;
                              setState(() {
                                _cardIndex = index;
                                _currentAccNumber = accounts[index].accNumber;
                              });
                            },
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ACCOUNT HISTORY',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: size.height * 0.02,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: size.width * 0.03,
                              right: size.width * 0.03),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.white10,
                              border: Border.all()),
                          child: DropdownButtonHideUnderline(
                            // build filter options
                            child: DropdownButton(
                              dropdownColor: Colors.black,
                              value: _sortValue,
                              items: const [
                                DropdownMenuItem(
                                  child: Text(
                                    "Today",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: 0,
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    "Yesterday",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                    child: Text(
                                      "Last 7 days",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    value: 2),
                                DropdownMenuItem(
                                  child: Text(
                                    "Last 30 days",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: 3,
                                ),
                              ],
                              onChanged: (int? value) {
                                setState(
                                  () {
                                    _sortValue = value!;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _lvActivities.isNotEmpty
                          ? _lvActivities.length < _filtredActivities.length
                              ? _lvActivities.length + 1
                              : _lvActivities.length
                          : 1,
                      itemBuilder: (BuildContext ctxt, int index) {
                        if (index == _lvActivities.length &&
                            index < _filtredActivities.length) {
                          return Center(
                            child: Container(
                              height: size.height * 0.1,
                              width: size.width * 0.2,
                              margin: const EdgeInsets.all(5),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                          );
                        } else {
                          // build activities
                          return _lvActivities.isNotEmpty
                              ? buildActivity(
                                  _lvActivities[index].companyName,
                                  _lvActivities[index].ammountChange,
                                  _lvActivities[index].income,
                                  _lvActivities[index].date,
                                  size,
                                )
                              : Align(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: size.height * 0.01,
                                      left: size.width * 0.05,
                                      right: size.width * 0.05,
                                    ),
                                    child: Column(children: [
                                      Text(
                                        "Woops! \n We couldn't find anything with this filter",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height * 0.02,
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.white,
                                      ),
                                    ]),
                                  ),
                                );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Container(
                child: _isGoUpVisible
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02,
                            horizontal: size.width * 0.08,
                          ),
                          child: InkWell(
                            onTap: () {
                              _lvController.jumpTo(0);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.black,
                                  border: Border.all()),
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                                size: size.height * 0.035,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sortAndFiltr() {
    _lvActivities = [];

    //TODO add max value for sort and connect activities to database

    activities.sort((b, a) => a.date.compareTo(b.date));
    if (_sortValue == 0) {
      _filtredActivities = activities
          .where((e) => e.accNumber == _currentAccNumber)
          .toList()
          .where((e) =>
              (today.day ==
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(e.date),
                      ).day &&
                  today.month ==
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(e.date),
                      ).month) &&
              today.year ==
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(e.date),
                  ).year)
          .toList();
    }
    if (_sortValue == 1) {
      _filtredActivities = activities
          .where((e) => e.accNumber == _currentAccNumber)
          .toList()
          .where((e) =>
              (today.day - 1 ==
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(e.date),
                      ).day &&
                  today.month ==
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(e.date),
                      ).month) &&
              today.year ==
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(e.date),
                  ).year)
          .toList();
    }
    if (_sortValue == 2) {
      _filtredActivities = activities
          .where((e) => e.accNumber == _currentAccNumber)
          .toList()
          .where((e) =>
              (today.day - 7 <=
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(e.date),
                      ).day &&
                  today.month ==
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(e.date),
                      ).month) &&
              today.year ==
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(e.date),
                  ).year)
          .toList();
    }
    if (_sortValue == 3) {
      _filtredActivities = activities
          .where((e) => e.accNumber == _currentAccNumber)
          .toList()
          .where((e) =>
              (today.day - 30 <=
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(e.date),
                      ).day &&
                  today.month ==
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(e.date),
                      ).month) &&
              today.year ==
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(e.date),
                  ).year)
          .toList();
    }

    for (int i = 0; i < _lvCurrentMax && i < _filtredActivities.length; i++) {
      _lvActivities.add(_filtredActivities[i]);
    }
  }
}
