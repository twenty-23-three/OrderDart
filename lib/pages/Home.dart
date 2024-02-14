import 'package:flutter/material.dart';
import 'package:project23/pages/Insert.dart';
import 'package:project23/back.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BackEnd be = BackEnd(baseUrl: "http://localhost:3000");


  void setHome() {
    setState(() {

    });
  }
  void update(int id,String status) async{
    await be.put(id,status);
    setHome();
  }
  void remove(int id) async{
    await be.delete(id);
    setHome();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Order>>(
        future: be.get(),
        builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
          if (snapshot.hasData) {
            List<Order>? items = snapshot.data;
            if (items != null) {
              return ListView.builder(itemCount:items.length, itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Айди заказа: ${items[index].OrderID}'),
                  leading: GestureDetector(
                    onTap: () =>showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                         title: Center(child: const Text('Информация')),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                             children: [
                              CircleAvatar(
                                radius:30,
                                backgroundImage:NetworkImage(items[index].Image),
                                backgroundColor: Colors.white,
                              ),
                              Text('Время заказа: ${items[index].CreatedAt}\n'
                              'Время отправки: ${items[index].ShippedAt}\n'
                              'Время доставки: ${items[index].CompletedAt}'),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      update(items[index].OrderID,"shipped");
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      update(items[index].OrderID,"completed");
                                    },
                                  ),
                                ],
                              ),
                             ],
                            ),
                          ),
                        ),
                    ),
                    child: CircleAvatar(
                    radius:30,
                    backgroundImage:NetworkImage(items[index].Image),
                    backgroundColor: Colors.white,
                  ),
                  ),
                  subtitle: Text('Время заказа: ${items[index].CreatedAt}\n'
                      'Время отправки: ${items[index].ShippedAt}\n'
                      'Время доставки: ${items[index].CompletedAt}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          remove(items[index].OrderID);
                        },
                      ),


                    ],
                  ) ,
                );

              });
            } else {
              return Center(child: Text("Empty"),);
            }
          } else if (snapshot.hasError) {
            return Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          dynamic result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>  InsertPage(setHome: setHome,),
            ),
          );
          setState(() {

          });
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),


    );
  }
}
