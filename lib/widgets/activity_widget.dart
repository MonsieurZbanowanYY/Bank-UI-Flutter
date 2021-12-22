import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildActivity(
  String companyName,
  double ammountChange,
  bool income,
  String timestamp,
  Size size,
) {
  return Padding(
    padding: EdgeInsets.only(
      left: size.width * 0.05,
      right: size.width * 0.05,
    ),
    child: SizedBox(
      height: size.height * 0.1,
      width: size.width * 0.9,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.01,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: size.width * 0.5,
                    height: size.height * 0.05,
                    child: Text(
                      companyName,
                      overflow: TextOverflow.clip, //TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.02,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy')
                          .format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(timestamp),
                            ),
                          )
                          .toString(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: size.height * 0.014,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.01),
                      child: Icon(
                        Icons.circle,
                        color: Colors.white.withOpacity(0.8),
                        size: size.height * 0.005,
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm a')
                          .format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(timestamp),
                            ),
                          )
                          .toString(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: size.height * 0.014,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
              ),
              child: SizedBox(
                width: size.width * 0.4,
                child: Text(
                  income == true ? '+ \$$ammountChange' : '- \$$ammountChange',
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: income == true ? Colors.green : Colors.red,
                    fontSize: size.height * 0.018,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.04,
              ),
              child: Text(
                '\$4,855.23', //TODO add balance after activity to model
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: size.height * 0.014,
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Divider(
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
