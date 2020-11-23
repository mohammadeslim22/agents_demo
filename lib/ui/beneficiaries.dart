import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/models/ben.dart';
import 'package:agent_second/providers/export.dart';
import 'package:agent_second/providers/global_variables.dart';
import 'package:agent_second/util/service_locator.dart';
import 'package:agent_second/util/size_config.dart';
import 'package:agent_second/widgets/global_drawer.dart';
import 'package:agent_second/widgets/text_form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Beneficiaries extends StatefulWidget {
  const Beneficiaries({Key key}) : super(key: key);

  @override
  _BeneficiariesState createState() => _BeneficiariesState();
}

class _BeneficiariesState extends State<Beneficiaries> {
  Set<int> selectedOptions = <int>{};
  BeneficiariesModel beneficiaries;
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final GlobalVars globalVarsProv =
        Provider.of<GlobalVars>(context, listen: false);
    beneficiaries = globalVarsProv.beneficiaries;
    
  }

  @override
  Widget build(BuildContext context) {
    final GlobalVars globalVarsProv = Provider.of<GlobalVars>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, "beneficiaries"), style: styles.appBar),
        centerTitle: true,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
            width: 240,
            child: TextFormInput(
              text: trans(context, 'ben_name'),
              cController: searchController,
              prefixIcon: Icons.search,
              kt: TextInputType.emailAddress,
              obscureText: false,
              readOnly: false,
              onTab: () {},
              onFieldChanged: (String st) {
                setState(() {});
              },
              onFieldSubmitted: () {},
            ),
          ),
        ],
      ),
      drawer: GlobalDrawer(sourceContext: context),
      body: GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          crossAxisCount: 3,
          childAspectRatio: 2,
          addRepaintBoundaries: true,
          children: globalVarsProv.beneficiaries.data.where((Ben element) {
            return element.name
                .trim()
                .toLowerCase()
                .contains(searchController.text.trim().toLowerCase());
          }).map((Ben item) {
            return Card(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (selectedOptions.contains(item.id)) {
                      selectedOptions.clear();
                    } else {
                      selectedOptions.clear();
                      selectedOptions.add(item.id);
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      SizeConfig.blockSizeHorizontal * 1,
                      SizeConfig.blockSizeVertical * 1.5,
                      SizeConfig.blockSizeHorizontal * 1,
                      0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(item.id.toString(),
                                    style: styles.beneficires),
                                const SizedBox(height: 6),
                                const Icon(Icons.phone_forwarded,
                                    size: 16, color: Colors.green),
                              ],
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(item.name,
                                            style: styles.beneficiresNmae),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(item.phone,
                                          style: styles.underHeadgray),
                                      Text(item.address,
                                          style: styles.underHeadgray),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (item.visited)
                              SvgPicture.asset("assets/images/visitedsign.svg",
                                  width: SizeConfig.blockSizeHorizontal * 6,
                                  height: SizeConfig.blockSizeVertical * 6)
                            else
                              SvgPicture.asset("assets/images/unvisitedBen.svg",
                                  width: SizeConfig.blockSizeHorizontal * 6,
                                  height: SizeConfig.blockSizeVertical * 6),
                          ],
                        ),
                      ),
                      const Divider(),
                      if (selectedOptions.contains(item.id))
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      getIt<OrderListProvider>()
                                          .clearOrcerList();
                                      getIt<OrderListProvider>()
                                          .setScreensToPop(2);

                                      globalVarsProv.setBenInFocus(item);
                                      Navigator.pushNamed(
                                          context, "/Order_Screen",
                                          arguments: <String, dynamic>{
                                            "ben": item,
                                            "isORderOrReturn": true
                                          });
                                    },
                                    child: SvgPicture.asset(
                                        "assets/images/orderButton.svg",
                                        height:
                                            SizeConfig.blockSizeHorizontal * 5),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      getIt<OrderListProvider>()
                                          .clearOrcerList();
                                      getIt<OrderListProvider>()
                                          .setScreensToPop(2);
                                      globalVarsProv.setBenInFocus(item);
                                      Navigator.pushNamed(
                                          context, "/Order_Screen",
                                          arguments: <String, dynamic>{
                                            "ben": item,
                                            "isORderOrReturn": false
                                          });
                                    },
                                    child: SvgPicture.asset(
                                        "assets/images/returnButton.svg",
                                        height:
                                            SizeConfig.blockSizeHorizontal * 5),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      getIt<OrderListProvider>()
                                          .setScreensToPop(2);

                                      globalVarsProv.setBenInFocus(item);
                                      getIt<OrderListProvider>()
                                          .setScreensToPop(2);
                                      Navigator.pushNamed(
                                          context, "/Payment_Screen",
                                          arguments: <String, dynamic>{
                                            "orderTotal": item.totalOrders,
                                            "returnTotal": item.totalReturns,
                                            "cashTotal":
                                                double.parse(item.balance),
                                          });
                                    },
                                    child: SvgPicture.asset(
                                        "assets/images/collectionButton.svg",
                                        height:
                                            SizeConfig.blockSizeHorizontal * 5),
                                  )
                                ],
                              )),
                        )
                      else
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 6,
                                vertical: 0),
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.blockSizeHorizontal * 2,
                                  vertical: SizeConfig.blockSizeVertical * 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(180.0),
                                  side: const BorderSide(color: Colors.blue)),
                              onPressed: () async {
                                getIt<OrderListProvider>().setScreensToPop(3);
                                globalVarsProv.setBenInFocus(item);
                                Navigator.pushNamed(
                                    context, "/Beneficiary_Center",
                                    arguments: <String, Ben>{"ben": item});
                              },
                              color: colors.myBlue,
                              textColor: colors.white,
                              child: Text(trans(context, 'view_more'),
                                  style: styles.seeMOre),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }
}
