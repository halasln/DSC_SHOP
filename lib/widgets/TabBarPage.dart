import 'package:dsc_shop/widgets/products_list_veiw.dart';
import 'package:flutter/material.dart';

class TabBarPage extends StatefulWidget {
  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBar(
              unselectedLabelColor:
                  Theme.of(context).textTheme.headline1!.color,
              labelColor: Theme.of(context).primaryColor,
              isScrollable: true,
              indicator: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  text: 'All products',
                ),
                Tab(
                  text: 'Men\'s clothing',
                ),
                Tab(
                  text: 'Jewelery',
                ),
                Tab(
                  text: 'Electronics',
                ),
                Tab(
                  text: 'Women\'s clothing',
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            width: double.infinity,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                ProductsListView(),
                ProductsListView(categoryName: "men's clothing"),
                ProductsListView(categoryName: 'jewelery'),
                ProductsListView(categoryName: "electronics"),
                ProductsListView(categoryName: "women's clothing"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
