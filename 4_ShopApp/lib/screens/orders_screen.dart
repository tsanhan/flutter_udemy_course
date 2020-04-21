import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders_provider.dart' as ord;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget /* extends StatefulWidget*/ {
  static const routeName = "/orders";

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   // var isInit = true;
  // var _isLoading = false;

  // Future<void> _refreshOrders(BuildContext context) async {
  //   setState(() => _isLoading = true);
  //   await Provider.of<ord.OrdersProvider>(context, listen: false)
  //       .fetchAndSetOrders();
  //   setState(() => _isLoading = false);
  // }

  // @override
  // void initState() {
  //   _isLoading = false;

  //   // when using 'listen: false', there is no need to use the 'Future.delayed(Duration.zero)' hack
  //    Provider.of<ord.OrdersProvider>(context, listen: false).fetchAndSetOrders().then((_){
  //      setState(() {
  //      _isLoading = false;
  //      });
  //    });
  //   super.initState();
  // }
  // void didChangeDependencies() {
  //   if (isInit) {
  //     setState(() => _isLoading = true);
  //     Provider.of<ord.OrdersProvider>(context, listen: false)
  //         .fetchAndSetOrders()
  //         .then((_) {
  //       setState(() => _isLoading = false);
  //     });
  //   }
  //   isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<ord.OrdersProvider>(context);
    print("Printing...");
    return Scaffold(
      appBar: AppBar(
        title: Text('You Orders'),
      ),
      body: FutureBuilder(
            // altevative stateful widget just to animate a spinner when loading
            future: Provider.of<ord.OrdersProvider>(context, listen: false)
                .fetchAndSetOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (dataSnapshot.error != null) {
                // ...
                // Do error handling stuff
                return Center(
                  child: Text("An Error occured"),
                );
              } else {
                return Consumer<ord.OrdersProvider>(
                    builder: (ctx, orderData, child) => ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (ctx, i) =>
                              OrderItem(orderData.orders[i]),
                        ));
              }
            },
          ),
      drawer: AppDrawer(),
    );
  }
}
