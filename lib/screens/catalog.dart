// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/cart.dart';
import 'package:flutter_app/models/catalog.dart';

class MyCatalog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _MyAppBar(),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MyListItem(index),
            ),
          ),
        ],
      ),
    );
  }
}


class _AddButton extends StatelessWidget {
  final Item item;

  const _AddButton({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The context.select() method will let you listen to changes to
    // a *part* of a model. You define a function that "selects" (i.e. returns)
    // the part you're interested in, and the provider package will not rebuild
    // this widget unless that particular part of the model changes.
    //
    // This can lead to significant performance improvements.
    var isInCart = context.select<CartModel, bool>(
      // Here, we are only interested whether [item] is inside the cart.
      (cart) => cart.items.contains(item),
    );

    return FlatButton(
      onPressed: isInCart
          ? null
          : () {
              // If the item is not in cart, we let the user add it.
              // We are using context.read() here because the callback
              // is executed whenever the user taps the button. In other
              // words, it is executed outside the build method.
              var cart = context.read<CartModel>();
              cart.add(item);
            },
      splashColor: Theme.of(context).primaryColor,
      child: isInCart
          ? Icon(Icons.check, semanticLabel: 'ADDED')
          : Image.asset(
              "web/icons/buy.png",
              width: 40,
            ),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('Планшеты', style: Theme.of(context).textTheme.headline1),
      floating: true,
      backgroundColor: Colors.greenAccent[700],
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: null),
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ],
    );
  }
}

class _MyListItem extends StatefulWidget {
  final int index;

  _MyListItem(this.index, {Key key}) : super(key: key);

  @override
  __MyListItemState createState() => __MyListItemState();
}

class __MyListItemState extends State<_MyListItem> {
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var item = context.select<CatalogModel, Item>(
      // Here, we are only interested in the item at [index]. We don't care
      // about any other change.
      (catalog) => catalog.getByPosition(widget.index),
    );
    var isInCart = context.select<CartModel, bool>(
      // Here, we are only interested whether [item] is inside the cart.
      (cart) => cart.items.contains(item),
    );
    var textTheme = Theme.of(context).textTheme.headline6;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
          //color: Colors.amber,
          //margin: ,
          child: Column(
        children: [
          LimitedBox(
            maxHeight: 90,
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    child: item.image,
                  ),
                ),
                SizedBox(width: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: textTheme),
                      SizedBox(height: 10),
                      StarDisplay(value: item.rating),
                      SizedBox(height: 10),
                      Text(
                        item.price.toString() + "\u20B4",
                        style: textTheme,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: IconButton(
                              icon: Image.asset(
                                "web/icons/heart.png",
                                width: 70,
                              ),
                              onPressed: null)),
                      Expanded(
                          child: FlatButton(
                        minWidth: 10,
                        onPressed: isInCart
                            ? null
                            : () {
                                var cart = context.read<CartModel>();
                                cart.add(item);
                              },
                        splashColor: Theme.of(context).primaryColor,
                        child: isInCart
                            ? Icon(
                                Icons.check,
                                size: 40.0,
                              )
                            : Image.asset(
                                "web/icons/buy.png",
                                width: 70,
                              ),
                      ) //IconButton(icon: Image.asset("web/icons/buy.png", width: 70,), onPressed: null),)
                          )
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
        ],
      )),
    );
  }
}

class StarDisplay extends StatelessWidget {
  final int value;

  const StarDisplay({Key key, this.value = 0})
      : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}
