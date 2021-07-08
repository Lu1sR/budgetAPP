import 'package:budget/constants.dart';
import 'package:budget/home/main_chart.dart';
import 'package:budget/home/transaction-List/add_transaction_page.dart';
import 'package:budget/home/tab_item.dart';
import 'package:budget/home/transaction-List/transaction_list_tile.dart';
import 'package:budget/models/results.dart';
import 'package:budget/models/transactions.dart';
import 'package:budget/services/auth.dart';
import 'package:budget/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction-List/list_item_builder.dart';

class MaterialHomeScaffold extends StatelessWidget {
  final Auth auth;
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;

  const MaterialHomeScaffold(
      {Key key,
      @required this.auth,
      @required this.currentTab,
      @required this.onSelectedTab})
      : super(key: key);

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _delete(BuildContext context, Transaction transaction) async {
    try {
      final database = Provider.of<Database>(context);
      await database.deletePedido(transaction: transaction);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TabItem.values.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            FlatButton(
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              onPressed: _signOut,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: Icon(
            Icons.add,
          ),
          onPressed: () => AddTransactionPage.show(context),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildHomePage(context),
            Container(
              child: Center(child: Text('Blue')),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo[100],
                  blurRadius: 3,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: TabBar(
              indicator: BoxDecoration(),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.indigo,
              tabs: <Widget>[
                _buildItem(TabItem.feed),
                _buildItem(TabItem.info),
              ],
              onTap: (index) => onSelectedTab(TabItem.values[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    if (currentTab == tabItem) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(itemData.icon, color: Colors.indigo),
          Container(
            margin: EdgeInsets.only(top: 4.0),
            decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: new BorderRadius.all(Radius.circular(2.5))),
            height: 5,
            width: 5,
          )
        ],
      );
    } else {
      return Icon(
        itemData.iconOutline,
        color: Colors.grey,
      );
    }
  }

  Widget _buildHomePage(BuildContext context) {
    return Container(
      height: screenHeight(context),
      child: Column(
        children: [
          Container(
            height: screenHeight(context) * 0.14,
            padding: EdgeInsets.only(left: 16, top: 16),
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Bienvenido\n',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500)),
                TextSpan(
                    text: 'Luis',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w500))
              ]),
            ),
          ),
          Container(
            height: screenHeight(context) * 0.40,
            child: _buildChart(context),
          ),
          Container(
              child: Center(
                  child: _transactionTitle('Transacciones', Colors.black54)),
              height: screenHeight(context) * 0.06),
          Container(
            child: _buildContents(context),
            height: screenHeight(context) * 0.40,
          )
        ],
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Transaction>>(
      stream: database.pedidosStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Transaction>(
          snapshot: snapshot,
          itemBuilder: (context, transaction) => Dismissible(
            key: Key('job-${transaction.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, transaction),
            child: TransactionListTile(transaction: transaction, onTap: () {}),
          ),
        );
      },
    );
  }

  Widget _buildChart(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder(
      stream: database.resultStream(),
      builder: (context, snapshot) {
        dynamic data = snapshot.data;
        print(data['Salud']);
        return PieChartExpenses(
          chartData: [
            ChartData('Salud', data['Salud'].toDouble()),
            ChartData('Vestimenta', data['Vestimenta'].toDouble()),
            ChartData('Otros', data['Otros'].toDouble()),
            ChartData('Vivienda', data['Vivienda'].toDouble()),
            ChartData('Alimentacion', data['Alimentacion'].toDouble())
          ],
        );
      },
    );
  }

  Widget _transactionTitle(String text, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: color),
    );
  }
}
