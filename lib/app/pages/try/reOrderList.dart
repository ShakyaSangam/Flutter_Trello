import 'package:flutter/material.dart';

class ReOrderList extends StatefulWidget {
  @override
  _ReOrderListState createState() => _ReOrderListState();
}

class _ReOrderListState extends State<ReOrderList> {
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> orderCharacter = [
    'akon',
    'bkon',
    'ckon',
    'dkon',
    'ekon',
    'fkon',
  ];

  int insetIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Re-Order List"),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: orderCharacter.length,
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: Card(
              child: Text("item ${orderCharacter[index]}"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            insetIndex = orderCharacter.length ;
            orderCharacter.insert(insetIndex, "sangam");
            _listKey.currentState.insertItem(insetIndex);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// return Scaffold(
//       appBar: AppBar(
//         title: Text("Re-Order List"),
//       ),
//       body: ReorderableListView(
//         children: List.generate(
//           orderCharacter.length,
//           (index) => Container(
//             key: Key(index.toString()),
//             width: MediaQuery.of(context).size.width,
//             child: Card(
//               child: Text(orderCharacter[index]),
//             ),
//           ),
//         ),
//         onReorder: (int oldOrder, int newOrder) {
//           print('Old order: $oldOrder');
//           print('New order: $newOrder');

//           if(newOrder > oldOrder){
//             newOrder -= 1;
//           }

//           setState(() {
//             final String item = orderCharacter.removeAt(oldOrder);
//             print(item);
//             orderCharacter.insert(newOrder, item);
//           });
//         },
//       ),
//       floatingActionButton: FloatingActionButton(onPressed: (){
//         setState(() {
//           orderCharacter.insert(1, "sangam");
//         });
//       }, child: Icon(Icons.add),),
//     );
