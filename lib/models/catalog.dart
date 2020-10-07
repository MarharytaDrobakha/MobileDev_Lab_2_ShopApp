// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';

/// A proxy of the catalog of items the user can buy.
///
/// In a real app, this might be backed by a backend and cached on device.
/// In this sample app, the catalog is procedurally generated and infinite.
///
/// For simplicity, the catalog is expected to be immutable (no products are
/// expected to be added, removed or changed during the execution of the app).
class CatalogModel {
  static List<String> itemNames = [
    'Планшет 1',
    'Планшет 2',
    'Планшет 3',
    'Планшет 4',
    'Планшет 5',
    'Планшет 6',
    'Планшет 7',
    'Планшет 8',
    'Планшет 9',
  ];

  static List<Image> itemPhoto = [
    Image.asset("assets/images/image1.jpg"),
    Image.asset("assets/images/image2.jpg"),
    Image.asset("assets/images/image3.jpg"),
    Image.asset("assets/images/image4.jpg"),
    Image.asset("assets/images/image5.png"),
    Image.asset("assets/images/image6.jpg"),
    Image.asset("assets/images/image7.jpg"),
    Image.asset("assets/images/image8.jpg"),
    Image.asset("assets/images/image9.jpg"),
  ];

  static List<String> itemPrice = [
    "15843",
    "57653",
    "38477",
    "23243",
    "12334",
    "25431",
    "35644",
    "33153",
    "94634",
  ];
  /// Get item by [id].
  ///
  /// In this sample, the catalog is infinite, looping over [itemNames].
  Random random = new Random();
  Item getById(int id) => Item(id, itemNames[id % itemNames.length], itemPhoto[id % itemPhoto.length], itemPrice[id % itemPrice.length], id%5+1);

  /// Get item by its position in the catalog.
  Item getByPosition(int position) {
    // In this simplified case, an item's position in the catalog
    // is also its id.
    return getById(position);
  }
}

@immutable
class Item {
  final int id;
  final String name;
  final Image image;
  final String price;
  final int rating;

  Item(this.id, this.name, this.image, this.price, this.rating)
      // To make the sample app look nicer, each item is given one of the
      // Material Design primary colors.
    ;

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}
