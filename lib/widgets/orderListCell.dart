import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:agent_second/models/transactions.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/constants/styles.dart';

class OrderListCell extends StatelessWidget {
  const OrderListCell({Key key, this.items}) : super(key: key);
  final List<MiniItems> items;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(

            scrollDirection: Axis.vertical,
            child: DataTable(
              horizontalMargin: 0,
              columnSpacing: SizeConfig.blockSizeHorizontal * 2,

              columns: <DataColumn>[
                DataColumn(
                  label: Text(trans(context, '#'), style: styles.bill),
                  numeric: true,
                ),
                DataColumn(
                    label: Text(trans(context, 'product_name'),
                        style: styles.bill)),
                DataColumn(
                  label: Text(trans(context, 'quantity'), style: styles.bill),
                  numeric: true,
                ),
                DataColumn(
                    label: Text(trans(context, 'unit'), style: styles.bill)),
                DataColumn(
                  label: Text(trans(context, 'unit_price'), style: styles.bill),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(trans(context, 'total'), style: styles.bill),
                  numeric: true,
                )
              ],
              rows: items.map((MiniItems e) {
                return DataRow(cells: <DataCell>[
                  DataCell(Text(e.itemId.toString(),style: TextStyle(color: colors.black))),
                  DataCell(Text(e.item,style: TextStyle(color: colors.black))),
                  DataCell(Text(e.quantity.toString(),style: TextStyle(color: colors.black))),
                  DataCell(Text(e.unit.toString(),style: TextStyle(color: colors.black))),
                  DataCell(Text(e.itemPrice.toString(),style: TextStyle(color: colors.black))),
                  DataCell(Text(e.total.toString(),style: TextStyle(color: colors.black)))
                ]);
              }).toList(),
            )));
  }
}
