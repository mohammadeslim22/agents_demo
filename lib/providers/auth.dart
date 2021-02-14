import 'dart:async';
import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/config.dart';
import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/util/data.dart';
import 'package:agent_second/util/dio.dart';
import 'package:agent_second/util/size_config.dart';
import 'package:agent_second/widgets/custom_toast_widget.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:cron/cron.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:agent_second/providers/global_variables.dart';

class Auth with ChangeNotifier {
  Future<dynamic> login(
      String usernametext, String passwordText, BuildContext context) async {
    print("config.base url fucken ${config.baseUrl}");

    SystemChannels.textInput.invokeMethod<String>('TextInput.hide');

    await dio.post<dynamic>("login", data: <String, dynamic>{
      "username": usernametext.toString().trim(),
      "password": passwordText
    }).then<dynamic>((Response<dynamic> value) async {
      if (value.statusCode == 422) {
        return value.data['errors'];
      }
      if (value.statusCode == 200) {
        if (value.data != "fail") {
          if (value.data['agent']['istable'] == 1) {
            print("am the token value : ${value.data['api_token']}");
            await data.setData(
                "authorization", "Bearer ${value.data['api_token']}");
            dio.options.headers['authorization'] =
                'Bearer ${value.data['api_token']}';
            config.verchilId = value.data['vehicle_board_no'].toString();
            data.setData(
                "verchil_id", value.data['vehicle_board_no'].toString());
            data.setData("agent_id", value.data['id'].toString());
            data.setData("company_name", value.data['company_name'].toString());
            data.setData("agent_name", value.data['username'].toString());
            data.setData("tax", value.data['tax'].toString());
            data.setData("trn", value.data['trn'].toString());
            if (value.data['company_name'] != null)
              config.companyName = value.data['company_name'].toString();

            config.address = value.data['settings']['address'].toString();
            config.mobileNo = value.data['settings']['mobile'].toString();
            if (value.data['settings']['logo'] != null)
              config.logo =
                  config.imageUrl + value.data['settings']['logo'].toString();

            print(config.logo);
            config.trn = value.data['trn'].toString();
            if (value.data['tax'] != null)
              config.tax = double.parse(value.data['tax'].toString());
            data.setData("agent_email", value.data['email'].toString());
            config.editPrice = value.data['settings']['edit_price'].toString();
            final String customersLastDate =
                await data.getData("beneficiaries_updated_at");
            final String itemsLastupDate =
                await data.getData("items_updated_at");
            final String benLastDate =
                value.data['settings']['beneficiaries_updated_at'].toString();
            final String itemsLastDate =
                value.data['settings']['items_updated_at'].toString();
            if (customersLastDate == "" ||
                customersLastDate == null ||
                customersLastDate.isEmpty ||
                customersLastDate.toLowerCase() == "null") {
              await data.setData("beneficiaries_updated_at", benLastDate);
              config.dontloadCustomers = true;
            } else {
              if (int.parse(customersLastDate) < int.parse(benLastDate)) {
                config.dontloadCustomers = true;
                await data.setData("beneficiaries_updated_at", benLastDate);
              }
            }
            if (itemsLastupDate == "" ||
                itemsLastupDate == null ||
                itemsLastupDate.isEmpty ||
                itemsLastupDate.toLowerCase() == "null") {
              await data.setData("items_updated_at", itemsLastDate);
              config.dontloadItems = true;
            } else {
              if (int.parse(itemsLastupDate) < int.parse(itemsLastDate)) {
                config.dontloadItems = true;
                await data.setData("items_updated_at", itemsLastDate);
              }
            }
            final GlobalVars globalVarsProv =
                Provider.of<GlobalVars>(context, listen: false);
            cron.schedule(Schedule.parse('*/1 * * * *'), () async {
              globalVarsProv.incrementTimeSinceLogin();
            });
            Navigator.popAndPushNamed(context, '/Home',
                arguments: <String, dynamic>{});
          } else {
            shownoTabletAllowed(
                context, value.data['agent']['puse_reason'].toString());
          }
        } else {
          showToastWidget(
              IconToastWidget.fail(msg: trans(context, 'invalid_credentals')),
              context: context,
              position: StyledToastPosition.center,
              animation: StyledToastAnimation.scale,
              reverseAnimation: StyledToastAnimation.fade,
              duration: const Duration(seconds: 4),
              animDuration: const Duration(seconds: 1),
              curve: Curves.elasticOut,
              reverseCurve: Curves.linear);
        }
      }
    });
  }

  void shownoTabletAllowed(BuildContext context, String suspentionReason) {
    showGeneralDialog<dynamic>(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.73),
        transitionDuration: const Duration(milliseconds: 350),
        context: context,
        pageBuilder: (BuildContext context, Animation<double> anim1,
            Animation<double> anim2) {
          return Container(
            height: SizeConfig.screenHeight / 3,
            width: SizeConfig.screenWidth / 4,
            color: colors.white,
            padding:
                const EdgeInsets.only(bottom: 16, left: 26, right: 26, top: 16),
            margin: const EdgeInsets.only(
                bottom: 160, left: 260, right: 260, top: 160),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SvgPicture.asset("assets/images/no_tablet.svg"),
                Material(
                    child: Text(
                        "${trans(context, 'no_tablet')} $suspentionReason",
                        style: styles.darkbluestyle))
              ],
            ),
          );
        });
  }

  Map<String, dynamic> user;
  StreamSubscription<dynamic> userAuthSub;

  @override
  void dispose() {
    if (userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
    }
    super.dispose();
  }

  bool get isAuthenticated {
    return user != null;
  }

  void signInAnonymously() {}

  void signOut() {}

  BluetoothDevice device;
  bool connected = false;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
}
