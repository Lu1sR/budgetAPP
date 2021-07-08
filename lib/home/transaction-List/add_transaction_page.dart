import 'package:budget/home/transaction-List/models/categories.dart';
import 'package:budget/models/transactions.dart' as model;
import 'package:budget/services/database.dart';
import 'package:budget/widgets/custom_text_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'search_list_items.dart';

//TODO: change to stateless widget
class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key key, this.database}) : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTransactionPage(
          database: database,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  List<DropdownMenuItem> items = [];
  final _formKey = GlobalKey<FormState>();
  String fecha, amount;
  String deducible = '0';
  String ruc = '';

  DateTime selectedDate = DateTime.now();
  List<DropdownMenuItem<Category>> _dropdownMenuItems;
  Category _selectedCategory;

  @override
  void initState() {
    _dropdownMenuItems = Category.buildDropdownMenuItems();
    _selectedCategory = _dropdownMenuItems[0].value;
    searchList.forEach((key, value) {
      items.add(DropdownMenuItem(
        child: _menuItem('$value - $key'),
        value: '$value - $key',
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.close,
          color: Colors.black54,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Text(
          'Nueva Transaccion',
          style: TextStyle(color: Colors.black54),
        ),
      ),
      body: _buildContent(),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _amountEntry(),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, top: 16),
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 8.0,
                        color: Colors.black12,
                        offset: Offset(0, 3)),
                  ]),
              child: Column(
                children: _buildFormChildren(context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _submitButtom(),
          )
        ],
      ),
    );
  }

  List<Widget> _buildFormChildren(BuildContext context) {
    return [
      SearchableDropdown.single(
        items: items,
        onChanged: (value) {
          setState(() {
            ruc = value;
          });
        },
        isExpanded: true,
        clearIcon: Icon(MdiIcons.domain),
        hint: _menuItemHint(),
        displayClearIcon: false,
      ),
      CustomTextForm(
        controller: TextEditingController(
            text: "${selectedDate.toLocal()}".split(' ')[0]),
        onPressed: () => _selectDate(context),
        function: (String input) => fecha = input,
        hintText: 'Fecha',
        prefixIcon: Icons.date_range,
        keyboardType: null,
      ),
      Divider(
        color: Colors.indigo[100],
        height: 0.5,
      ),
      CustomTextForm(
        function: (String input) => deducible = input,
        hintText: 'Deducible',
        prefixIcon: MdiIcons.percent,
        keyboardType: TextInputType.number,
      ),
      Divider(
        color: Colors.indigo[100],
        height: 0.5,
      ),
      Divider(
        color: Colors.indigo[100],
        height: 0.5,
      ),
      _dropDownMenu(),
    ];
  }

  Widget _amountEntry() {
    return TextFormField(
      onSaved: (input) => amount = input,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          color: Colors.indigo[200]),
      decoration: InputDecoration(
          hintStyle: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
              color: Colors.indigo[200]),
          alignLabelWithHint: true,
          border: InputBorder.none,
          hintText: '0.00',
          prefixIcon: Icon(Icons.attach_money),
          suffixIcon: Icon(Icons.attach_money, color: Colors.white)),
    );
  }

  Widget _submitButtom() {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.indigo,
      highlightColor: Colors.indigo,
      splashColor: Colors.white.withAlpha(100),
      padding: EdgeInsets.only(top: 16, bottom: 16),
      onPressed: _submit,
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              "INGRESAR",
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Positioned(
            right: 16,
            child: ClipOval(
              child: Container(
                color: Colors.indigo[700],
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(
                      MdiIcons.arrowRight,
                      color: Colors.white,
                      size: 18,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    try {
      _formKey.currentState.save();

      final id = doucmentIFromCurrentDate();
      final transaction = model.Transaction(
          category: _selectedCategory.name,
          date: Timestamp.fromDate(selectedDate),
          id: id,
          amount: double.parse(amount),
          deducible: double.parse(deducible),
          nameRUC: ruc.split('-')[0]);

      await widget.database.createTransaction(transaction);
      await widget.database
          .updateCounter(_selectedCategory.name, double.parse(amount));
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  Widget _dropDownMenu() {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecoration(
        prefixIcon: Icon(MdiIcons.toolboxOutline),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.all(16),
      ),
      value: _selectedCategory,
      items: _dropdownMenuItems,
      onChanged: (selectedElement) {
        setState(() {
          _selectedCategory = selectedElement;
        });
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2040, 1));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget _menuItem(String data) {
    return Container(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Icon(
              MdiIcons.domain,
              color: Colors.grey,
              size: 19,
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                data,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                    color: Colors.indigo[400]),
              ))
        ],
      ),
    );
  }

  Widget _menuItemHint() {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Icon(
              MdiIcons.domain,
              color: Colors.grey,
              size: 19,
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Establecimiento",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                    color: Colors.indigo[400]),
              ))
        ],
      ),
    );
  }
}
