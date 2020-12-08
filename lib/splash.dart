import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/config.dart';
import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/util/data.dart';
import 'package:agent_second/util/dio.dart';
import 'package:agent_second/util/size_config.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: colors.blue,
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(120.0),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: colors.white,
            ),
            height: SizeConfig.blockSizeVertical * 54,
            width: SizeConfig.blockSizeHorizontal * 60,
            child: Column(
              children: <Widget>[
                FutureBuilder<Response<dynamic>>(
                  future: dio.get<dynamic>("logo"),
                  builder: (BuildContext context,
                      AsyncSnapshot<Response<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: CircleAvatar(
                          radius: SizeConfig.screenWidth * .07,
                          backgroundImage: CachedNetworkImageProvider(
                            config.imageUrl + "${snapshot.data}",
                          ),
                        ),
                      );
                    } else {
                      return const Icon(Icons.error);
                    }
                  },
                ),
                Text(trans(context, "demo_or_qr"), style: styles.thirtyblack),
                const Spacer(),
                const Divider(thickness: 2, color: Colors.grey),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 4),
                        autofocus: true,
                        onPressed: () {
                          Navigator.popAndPushNamed(context, "/login");
                        },
                        child: Text(trans(context, "go_demo"),
                            style: styles.underHeadred),
                      ),
                    ),
                    verticalDiv(),
                    Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 4),
                        onPressed: () async {
                          final ScanResult result = await BarcodeScanner.scan();

                          try {
                            Fluttertoast.showToast(msg: result.rawContent);
                            await data.setData("baseUrl", result.rawContent);
                            config.baseUrl = "${result.rawContent}api/";
                            config.imageUrl = "${result.rawContent}image/";
                            Navigator.popAndPushNamed(context, "/login");
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: trans(context, 'use_right_qr_code'));
                          }
                        },
                        child: Text(trans(context, "activate"),
                            style: styles.underHeadgreen),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget verticalDiv() {
    return Container(
        padding: EdgeInsets.zero,
        child: const VerticalDivider(
          color: Colors.grey,
          thickness: 2,
        ),
        height: SizeConfig.screenHeight * .155);
  }
}
