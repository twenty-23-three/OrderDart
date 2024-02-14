import 'package:flutter/material.dart';
import 'package:project23/back.dart';

class InsertPage extends StatefulWidget {
  VoidCallback setHome;
  InsertPage({Key? key, required this.setHome}) : super(key: key);

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  BackEnd be = BackEnd(baseUrl: "http://localhost:3000");
  void setInsert() {
    setState(() {

    });
  }

  TextEditingController custController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController quantController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<LineItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Страница ввода данных"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child:
            Column(
              children: [
                field(custController, "Введите ID пользователя"),
                Text(
                  "Total Items: ${items.length} ",
                  style: TextStyle(fontSize: 18),
                ),


              TextButton(
               onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Ввод Заказа'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        field(itemController, "Введите ID товара"),
                        field(quantController, "Введите количество"),
                        field(priceController, "Введите цену"),
                        ElevatedButton(onPressed: () {
                          addItems();
                          itemController.clear();
                          quantController.clear();
                          priceController.clear();
                          setInsert();
                        },
                            child: const Text("Добавить")
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              child:
                const Text('Добавить товары',
                style: TextStyle(
                  fontSize: 18,
                ),
                )
              ),

                ElevatedButton(
                    onPressed: ( ) {
                      insert();
                    },
                    child: const Text('Сохранить',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    )
                ),

              ],
            ),
        ));
  }

  void addItems() async {
    int item = int.parse(itemController.text);
    int quantity = int.parse(quantController.text);
    int price = int.parse(priceController.text);
    items.add(LineItem(ItemID: item, Quantity: quantity, Price: price));
  }

  void insert() async {
    Order o = Order(
        OrderID: 0,
        CustomerID: int.parse(custController.text),
        LineItems: items,
        Image: "");
    await be.post(o);
    widget.setHome();
    Navigator.of(context).pop();
  }
    field(TextEditingController controller,String Text){
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: Text,
          ),
        ),
      const SizedBox(height: 10),
      ],
    );

  }
}
