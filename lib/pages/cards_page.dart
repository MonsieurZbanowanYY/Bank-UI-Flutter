import 'package:bank_ui/data/activities.dart';
import 'package:bank_ui/data/cards.dart';
import 'package:bank_ui/data/user.dart';

import 'package:bank_ui/model/activity_model.dart';
import 'package:bank_ui/model/card_model.dart';

import 'package:bank_ui/model/iban_formatter.dart';
import 'package:bank_ui/widgets/activity_widget.dart';
import 'package:bank_ui/widgets/bottom_bar.dart';
import 'package:bank_ui/widgets/card_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:checkdigit/checkdigit.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({Key? key}) : super(key: key);

  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  String _currentCardNumber = "";

  int currentIndex = 1;
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

  bool _bottomNavBarVisible = true;
  int _transferIndex = 0;
  String _cardProviderTransfer = "Mastercard";
  int _cardNumberTransfer = 7065447803090891;
  String _balanceTransfer = "0.00";
  Color _bgColorTransfer = Colors.white;
  Color _fontColorTransfer = Colors.black;

  bool _isGoUpVisible = false;
  final ScrollController _lvController = ScrollController();
  final int _lvDefaultMax = 10;
  int _lvCurrentMax = 10;
  List<Activity> _filtredActivities = [];
  List<Activity> _lvActivities = [];
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _ammountController = TextEditingController();
  final _ibanGlobalKey = GlobalKey<FormState>();
  final _ammountGlobalKey = GlobalKey<FormState>();

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

  void _bottomBarVisibility(
    bool enabled,
    String cardProvider,
    int cardNumber,
    String balance,
    Color bgColor,
    Color fontColor,
  ) {
    setState(() {
      _bottomNavBarVisible = enabled;
      _cardProviderTransfer = cardProvider;
      _cardNumberTransfer = cardNumber;
      _balanceTransfer = balance;
      _bgColorTransfer = bgColor;
      _fontColorTransfer = fontColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CardModel> cards = [
      CardModel(
        cardsData[0].accNumber,
        cardsData[0].validThru,
        false,
        cardsData[0].cardProvider,
        cardsData[0].cardNumber,
        cardsData[0].balance,
        Colors.purple,
        Colors.white,
        _bottomBarVisibility,
      ),
      CardModel(
        cardsData[1].accNumber,
        cardsData[1].validThru,
        false,
        cardsData[1].cardProvider,
        cardsData[1].cardNumber,
        cardsData[1].balance,
        Colors.pink,
        Colors.white,
        _bottomBarVisibility,
      ),
      CardModel(
        cardsData[2].accNumber,
        cardsData[2].validThru,
        false,
        cardsData[2].cardProvider,
        cardsData[2].cardNumber,
        cardsData[2].balance,
        Colors.white,
        Colors.black,
        _bottomBarVisibility,
      ),
    ];

    if (_currentCardNumber == "") {
      _currentCardNumber = cards[0].cardNumber.toString();
    }
    if (_bottomNavBarVisible == true) {
      sortAndFiltr();
    }
    var size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        bottomNavigationBar: _bottomNavBarVisible
            ? BottomBarWidget(
                currentIndex: currentIndex,
              )
            : null,
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
                              overflow: TextOverflow.clip,
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
                        // build cards slider
                        CarouselSlider.builder(
                          itemCount: cards.length,
                          itemBuilder: (context, i, ri) {
                            return CardBuild(
                              transfer: cards[i].transfer,
                              cardProvider: cards[i].cardProvider,
                              cardNumber: cards[i].cardNumber,
                              balance: cards[i].balance,
                              bgColor: cards[i].bgColor,
                              fontColor: cards[i].fontColor,
                              bottomBarVisibilityFunction:
                                  cards[i].bottomBarVisibilityFunction,
                              validThru: cards[i].validThru,
                            );
                          },
                          options: CarouselOptions(
                            initialPage: _cardIndex,
                            onPageChanged: (index, reason) {
                              _lvCurrentMax = _lvDefaultMax;
                              setState(() {
                                _cardIndex = index;
                                _currentCardNumber =
                                    cards[index].cardNumber.toString();
                              });
                            },
                            viewportFraction: 0.85,
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
                          'CARD HISTORY',
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
                            border: Border.all(),
                          ),
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
                              horizontal: size.width * 0.08),
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
              Container(
                child: !_bottomNavBarVisible && _transferIndex == 0 ||
                        _transferIndex == 1 ||
                        _transferIndex == 2
                    ? SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: size.height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.black45,
                                border: Border.all()),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: AnimatedSize(
                                duration: const Duration(
                                  milliseconds: 300,
                                ),
                                curve: Curves.fastOutSlowIn,
                                child: Container(
                                  height: _transferIndex == 0
                                      ? size.height * 0.7
                                      : size.height * 0.8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: const Color(0xff14171A),
                                      border: Border.all()),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.02,
                                          horizontal: size.width * 0.05,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.info_outlined,
                                              color: Colors.white,
                                              size: size.height * 0.03,
                                            ),
                                            InkWell(
                                              onTap: _transferIndex == 0
                                                  ? () {
                                                      _ibanController.text = "";
                                                      _ammountController.text =
                                                          "";
                                                      _bottomBarVisibility(
                                                        true,
                                                        "Mastercard",
                                                        7065447803090891,
                                                        "0.00",
                                                        Colors.white,
                                                        Colors.black,
                                                      );
                                                    }
                                                  : _transferIndex == 1
                                                      ? () {
                                                          setState(() {
                                                            _transferIndex = 0;
                                                          });
                                                        }
                                                      : _transferIndex == 2
                                                          ? () {
                                                              setState(() {
                                                                _transferIndex =
                                                                    1;
                                                              });
                                                            }
                                                          : () {
                                                              setState(() {
                                                                _transferIndex =
                                                                    0;
                                                              });
                                                            },
                                              child: Icon(
                                                Icons.close_outlined,
                                                color: Colors.white,
                                                size: size.height * 0.03,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.white30,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: size.height * 0.02,
                                            horizontal: size.width * 0.05,
                                          ),
                                          child: Text(
                                            'Transfer',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.height * 0.04,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.05,
                                          ),
                                          child: Text(
                                            'From card',
                                            style: TextStyle(
                                              color: Colors.white38,
                                              fontSize: size.height * 0.02,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.02,
                                        ),
                                        child: CardBuild(
                                          validThru: "11/21",
                                          transfer: true,
                                          cardProvider: _cardProviderTransfer,
                                          cardNumber: _cardNumberTransfer,
                                          balance: _balanceTransfer,
                                          bgColor: _bgColorTransfer,
                                          fontColor: _fontColorTransfer,
                                          bottomBarVisibilityFunction:
                                              _bottomBarVisibility,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.05,
                                          ),
                                          child: Text(
                                            'To',
                                            style: TextStyle(
                                              color: Colors.white38,
                                              fontSize: size.height * 0.02,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          child: _transferIndex == 0
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.width * 0.05,
                                                  ),
                                                  child: Form(
                                                    key: _ibanGlobalKey,
                                                    child: TextFormField(
                                                      controller:
                                                          _ibanController,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      validator: (value) {
                                                        if (value!.length < 5) {
                                                          return 'The IBAN must have a minimum of 5 characters.';
                                                        } else {
                                                          bool isValid = iban
                                                              .validate(value
                                                                  .toUpperCase()
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          r'-'),
                                                                      ''));
                                                          if (isValid) {
                                                            return null;
                                                          } else {
                                                            return 'IBAN is not valid';
                                                          }
                                                        }
                                                      },
                                                      inputFormatters: [
                                                        IbanFormatter(
                                                            sample:
                                                                'xxxx-xxxx-xxxx-xxxx-xxxx-xxxx-xxxx-xxxx-xx',
                                                            separator: '-'),
                                                      ],
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        hintText: 'IBAN number',
                                                        hintStyle: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : _transferIndex == 1
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            size.width * 0.05,
                                                      ),
                                                      child: Form(
                                                        key: _ammountGlobalKey,
                                                        child: TextFormField(
                                                          inputFormatters: <
                                                              TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    r'[0-9.]')),
                                                          ],
                                                          controller:
                                                              _ammountController,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          validator: (value) {
                                                            if (value!
                                                                .isNotEmpty) {
                                                              if (double.parse(
                                                                      value) <
                                                                  1) {
                                                                return 'The minimum transfer value is 1.00 \$';
                                                              }
                                                            } else if (value
                                                                .isEmpty) {
                                                              return 'The ammount to transfer is empty';
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              const InputDecoration(
                                                            border:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            hintText:
                                                                'Ammount in \$',
                                                            hintStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                size.width *
                                                                    0.05,
                                                            vertical:
                                                                size.height *
                                                                    0.01,
                                                          ),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              _ibanController
                                                                  .text,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    size.height *
                                                                        0.02,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                size.width *
                                                                    0.05,
                                                            vertical:
                                                                size.height *
                                                                    0.01,
                                                          ),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              '#Bank name from API', //TODO: add api to get bank name
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    size.height *
                                                                        0.02,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                size.width *
                                                                    0.05,
                                                            vertical:
                                                                size.height *
                                                                    0.01,
                                                          ),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              'Ammount to transfer: \n${double.parse(_ammountController.text).toStringAsFixed(2)} \$',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    size.height *
                                                                        0.03,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.height * 0.03),
                                        child: SizedBox(
                                          height: size.height * 0.06,
                                          width: size.width * 0.95,
                                          child: TextButton(
                                            style: ButtonStyle(
                                              alignment: Alignment.center,
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.white,
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.white,
                                              ),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  side: const BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: _transferIndex == 0
                                                ? () {
                                                    _ibanController.text =
                                                        _ibanController.text
                                                            .toUpperCase();
                                                    if (_ibanGlobalKey
                                                            .currentState!
                                                            .validate() ==
                                                        true) {
                                                      setState(() {
                                                        _transferIndex = 1;
                                                      });
                                                    }
                                                  }
                                                : _transferIndex == 1
                                                    ? () {
                                                        if (_ammountGlobalKey
                                                                .currentState!
                                                                .validate() ==
                                                            true) {
                                                          setState(() {
                                                            _transferIndex = 2;
                                                          });
                                                        }
                                                      }
                                                    : () {
                                                        //TODO: add action for transfer
                                                      },
                                            child: Text(
                                              'Next',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.height * 0.02,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
          .where((e) => e.cardNumber == _currentCardNumber)
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
          .where((e) => e.cardNumber == _currentCardNumber)
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
          .where((e) => e.cardNumber == _currentCardNumber)
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
          .where((e) => e.cardNumber == _currentCardNumber)
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
