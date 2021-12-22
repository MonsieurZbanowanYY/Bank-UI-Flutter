import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountBuild extends StatefulWidget {
  final bool transfer;
  final String accOwner;
  final String accName;
  final String accNumber;
  final String balance;
  final Color bgColor;
  final Color fontColor;
  final String validThru;

  const AccountBuild({
    Key? key,
    required this.accName,
    required this.transfer,
    required this.accOwner,
    required this.accNumber,
    required this.balance,
    required this.bgColor,
    required this.fontColor,
    required this.validThru,
  }) : super(key: key);

  @override
  _AccountBuildState createState() => _AccountBuildState();
}

class _AccountBuildState extends State<AccountBuild> {
  @override
  Widget build(BuildContext context) {
    String accName = widget.accName;
    String accOwner = widget.accOwner;
    String accNumber = widget.accNumber;
    String balance = widget.balance;
    Color bgColor = widget.bgColor;
    Color fontColor = widget.fontColor;
    var size = MediaQuery.of(context).size;

    return buildAccount(
      accName,
      accOwner,
      accNumber,
      balance,
      bgColor,
      fontColor,
      size,
    );
  }

  Widget buildAccount(
    String accName,
    String accOwner,
    String accNumber,
    String balance,
    Color bgColor,
    Color fontColor,
    Size size,
  ) {
    return Center(
      child: Container(
        height: size.height * 0.22,
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: InkWell(
          onTap: () {
            print('pressed $accNumber');
          },
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.03,
                ),
                child: Text(
                  'Account balance',
                  style: TextStyle(
                    color: fontColor.withOpacity(0.8),
                    fontSize: size.height * 0.02,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
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
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.03,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: fontColor,
                    size: size.height * 0.05,
                  ),
                  // Image.asset(
                  //TODO: add bank logo
                  //   width: size.width * 0.1,
                  //   height: size.width * 0.1,
                  // ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.04,
                    left: size.width * 0.05,
                  ),
                  child: Row(
                    children: [
                      Text(
                        accNumber,
                        style: GoogleFonts.inconsolata(
                          color: fontColor,
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.01,
                        ),
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: accNumber,
                              ),
                            ).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.white10,
                                      content: Text(
                                          "Account IBAN number copied to clipboard")));
                            });
                          },
                          child: Icon(
                            Icons.copy,
                            color: fontColor,
                            size: size.height * 0.015,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.045,
                    horizontal: size.width * 0.05,
                  ),
                  child: SizedBox(
                    height: size.height * 0.03,
                    width: size.width * 0.6,
                    child: Text(
                      accName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inconsolata(
                        color: fontColor,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.015,
                    horizontal: size.width * 0.05,
                  ),
                  child: SizedBox(
                    height: size.height * 0.03,
                    width: size.width * 0.6,
                    child: Text(
                      accOwner,
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
            ],
          ),
        ),
      ),
    );
  }
}
