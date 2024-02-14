import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project23/pages//Insert.dart';

class BackEnd {
  late String baseUrl;
  var client = http.Client();

  BackEnd({required this.baseUrl});

  Future <void> delete(int id) async{
    try {
      var request = await client.delete(Uri.parse("$baseUrl/orders/$id"));
    } catch (e) {
      print("Error $e");
    }
  }
  Future<void> put(int id,String status) async{
    try {
      var response = await client.put(Uri.parse("$baseUrl/orders/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'status': status,
        }),
      );
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> post(Order order) async {
      try {
        var request = await client.post(
          Uri.parse("$baseUrl/orders"),
          body: json.encode({
            "customer_id": order.CustomerID,
            "line_items": order.LineItems.map((item) => {
              "item_id": item.ItemID,
              "quantity": item.Quantity,
              "price": item.Price,
            }).toList(),
          }),
          headers: {
            "Content-Type": "application/json",
          },
        );
      } catch (e) {
        print("Error $e");
      }
  }

  Future<List<Order>> get() async {
    List<Order> orders = [];
    try {
      var response = await client.get(Uri.parse("$baseUrl/orders"));
      print(response.body);
      var userMap = jsonDecode(response.body);
      for (var o in userMap["orders"]) {
        List<LineItem> items = [];
        for (var i in o["line_items"]) {
          LineItem ln = LineItem(ItemID: i["item_id"], Quantity: i["quantity"], Price: i["price"]);
          items.add(ln);
        }
        Order order = Order(OrderID: o["order_id"],
            CustomerID: o["customer_id"],
            LineItems: items,
            Image: o["image"],
            CreatedAt: o["created_at"] ==  null ? null : DateTime.tryParse(o["created_at"]),
            ShippedAt: o["shipped_at"] ==  null ? null : DateTime.tryParse(o["shipped_at"]),
            CompletedAt: o["completed_at"] ==  null ? null : DateTime.tryParse(o["completed_at"]));
        orders.add(order);
      }
    } catch (e) {
      print("Error $e");
    } finally {
      return orders;
    }
  }

  void close() {
    client.close();
  }
}

class Order {
  final int OrderID;
  final int CustomerID;
  final List<LineItem> LineItems;
  final String Image;
  final DateTime? CreatedAt;
  final DateTime? ShippedAt;
  final DateTime? CompletedAt;

  Order({required this.OrderID,
         required this.CustomerID,
         required this.LineItems,
         required this.Image,
          this.CreatedAt,
          this.ShippedAt,
          this.CompletedAt});
}

class LineItem  {
  final int ItemID;
  final int Quantity;
  final int Price;

  LineItem({required this.ItemID,
            required this.Quantity,
            required this.Price});
}

