import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:velo/currency.dart';
import 'package:velo/tabs.dart';

import 'model.dart';

class ObjectivePage extends AppTab {
  static const double ICON_SIZE = 80;
  static const radius = Radius.circular(ICON_SIZE);
  final String title;

  ObjectivePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VeloModel>(builder: (context, model, child) {
      return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: model.items.length,
          itemBuilder: (BuildContext context, int index) {
            Item item = model.items[index];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    item.getIcon(),
                    size: 40,
                    color: Colors.red,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.name,
                          style: Theme.of(context).textTheme.body2),
                    ),
                    LinearPercentIndicator(
                      width: 250,
                      lineHeight: 9.0,
                      percent: min(1, item.priceReimbursed / item.price),
                      backgroundColor: Colors.white,
                      progressColor: Theme.of(context).accentColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          Currency.formatPrice(item.priceReimbursed) +
                              "€ remboursés sur " +
                              Currency.formatPrice(item.price) +
                              '€',
                          style: Theme.of(context).textTheme.caption),
                    ),
                  ],
                )
              ],
            );
          });
    });
  }

  @override
  Widget getFloatingActionButton(BuildContext context) {
    return Consumer<VeloModel>(builder: (context, model, child) {
      return FloatingActionButton(
        tooltip: "Créer un nouvel objectif",
        onPressed: () => showDialog(
            context: context,
            builder: (context) => getAddObjectiveDialog(context, model)),
        child: Icon(Icons.add),
      );
    });
  }

  AlertDialog getAddObjectiveDialog(BuildContext context, VeloModel model) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    return AlertDialog(
      title: Text('Créer un nouvel objectif'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: "Nom de l'objectif"),
            controller: nameController,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: priceController,
            decoration: InputDecoration(
                hintText: "0.00", suffixIcon: Icon(Icons.euro_symbol)),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: new Text('ENREGISTRER'),
          onPressed: () {
            model.addItem(nameController.text,
                (100 * double.parse(priceController.text)).toInt());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
