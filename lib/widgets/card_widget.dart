import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardBuild extends StatefulWidget {
  final bool transfer;
  final String cardProvider;
  final int cardNumber;
  final String balance;
  final Color bgColor;
  final Color fontColor;

  final String validThru;
  final Function bottomBarVisibilityFunction;
  const CardBuild({
    Key? key,
    required this.transfer,
    required this.cardProvider,
    required this.cardNumber,
    required this.balance,
    required this.bgColor,
    required this.fontColor,
    required this.bottomBarVisibilityFunction,
    required this.validThru,
  }) : super(key: key);

  @override
  _CardBuildState createState() => _CardBuildState();
}

class _CardBuildState extends State<CardBuild> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String cardProvider = widget.cardProvider;
    int cardNumber = widget.cardNumber;
    String balance = widget.balance;
    Color bgColor = widget.bgColor;
    Color fontColor = widget.fontColor;

    Function bottomBarVisibilityFunction = widget.bottomBarVisibilityFunction;
    return buildCard(cardProvider, cardNumber, balance, bgColor, fontColor,
        size, bottomBarVisibilityFunction);
  }

  Widget buildCard(
    String cardProvider,
    int cardNumber,
    String balance,
    Color bgColor,
    Color fontColor,
    Size size,
    Function bottomBarVisibilityFunction,
  ) {
    return Center(
      child: Container(
        height: size.height * 0.22,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: InkWell(
          onTap: () {
            print('pressed $cardNumber');
          },
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.07,
                  vertical: size.height * 0.03,
                ),
                child: Text(
                  'Card balance',
                  style: TextStyle(
                    color: fontColor.withOpacity(0.8),
                    fontSize: size.height * 0.02,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.07,
                  vertical: size.height * 0.055,
                ),
                child: Text(
                  "\$$balance",
                  style: TextStyle(
                    color: fontColor,
                    fontSize: size.height * 0.03,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.005,
                  ),
                  child: Image.asset(
                    cardProvider == "Visa"
                        ? 'assets/visaLogo.png'
                        : cardProvider == "Mastercard"
                            ? 'assets/mastercardLogo.png'
                            : 'assets/avatar.png',
                    width: size.width * 0.1,
                    height: size.width * 0.1,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.08,
                  ),
                  child: Text(
                    "${('*' * 12).replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")}${cardNumber.toString().substring(cardNumber.toString().length - 4)}",
                    style: GoogleFonts.inconsolata(
                      color: fontColor,
                      fontSize: size.height * 0.031,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.04,
                    horizontal: size.width * 0.05,
                  ),
                  child: Text(
                    "VALID THRU ${widget.validThru}",
                    style: GoogleFonts.inconsolata(
                      color: fontColor,
                      fontSize: size.height * 0.015,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.01,
                    horizontal: size.width * 0.05,
                  ),
                  child: SizedBox(
                    height: size.height * 0.03,
                    width: size.width * 0.6,
                    child: Text(
                      "Martin Gogołowicz",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inconsolata(
                        color: fontColor,
                        fontSize: size.height * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: widget.transfer
                    ? null
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.015,
                        ),
                        child: InkWell(
                          onTap: () {
                            bottomBarVisibilityFunction(
                              false,
                              cardProvider,
                              cardNumber,
                              balance,
                              bgColor,
                              fontColor,
                            );
                          },
                          child: Icon(
                            Icons.send_outlined,
                            color: fontColor,
                            size: size.height * 0.025,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
