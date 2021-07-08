import 'package:flutter/material.dart';

class Category {
  int id;
  String name;

  Category(this.id, this.name);

  static List<Category> getCompanies() {
    return <Category>[
      Category(1, 'Vivienda'),
      Category(2, 'Alimentacion'),
      Category(3, 'Salud'),
      Category(4, 'Vestimenta'),
      Category(5, 'Otros'),
    ];
  }

  static List<DropdownMenuItem<Category>> buildDropdownMenuItems() {
    List<DropdownMenuItem<Category>> items = List();
    for (Category company in getCompanies()) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(
            company.name,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                color: Colors.indigo[400]),
          ),
        ),
      );
    }
    return items;
  }
}
