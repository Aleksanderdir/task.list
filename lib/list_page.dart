import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_list/repoData.dart';

import 'flavor.dart';
import 'fluversCrud.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Flavor> flavors = [];
  /* [
    Flavor(name: 'Chocolate'),
    Flavor(name: 'Strawberry'),
    Flavor(name: 'Hazelnut'),
    Flavor(name: 'Vanilla'),
    Flavor(name: 'Lemon'),
    Flavor(name: 'Yoghurt'),
    Flavor(name: 'Chocolate'),
    Flavor(name: 'Strawberry'),
    Flavor(name: 'Hazelnut'),
    Flavor(name: 'Vanilla'),
    Flavor(name: 'Lemon'),
    Flavor(name: 'Yoghurt'),
    Flavor(name: 'Chocolate'),
    Flavor(name: 'Strawberry'),
    Flavor(name: 'Hazelnut'),
    Flavor(name: 'Vanilla'),
    Flavor(name: 'Lemon'),
    Flavor(name: 'Yoghurt'),
  ];*/

  @override
  Widget build(BuildContext context) {
    flavors = context.watch<RepoData>().getFlavors;

    return ListView.builder(
      itemCount: flavors.length,
      itemBuilder: (context, index) {
        final flavor = flavors[index];
        return Dismissible(
          key: Key(flavor.NameFlavor),
          background: Container(
            color: Colors.green,
            child: Align(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(Icons.favorite),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            child: Align(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.delete),
              ),
              alignment: Alignment.centerRight,
            ),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              fluversCrud crud = fluversCrud();

              await crud.edit(flavors[index].Id, flavors[index].NameFlavor,
                  !flavors[index].isFavorite);
              setState(() {
                flavors[index] =
                    flavor.copyWith(isFavorite: !flavor.isFavorite);
              });
              return false;
            } else {
              bool delete = true;
              final snackbarController =
                  ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted ${flavor.NameFlavor}'),
                  action: SnackBarAction(
                      label: 'Undo', onPressed: () => delete = false),
                ),
              );
              await snackbarController.closed;
              return delete;
            }
          },
          onDismissed: (_) async {
            fluversCrud crud = fluversCrud();

            await crud.del(flavors[index].Id);
            print(flavors[index].Id);
            setState(() {
              flavors.removeAt(index);
            });
          },
          child: Card(
            child: GestureDetector(
              onLongPress: () {
                print('xdha');
              },
              child: ListTile(
                title: Text(
                  flavor.NameFlavor,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),

                trailing: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                      flavor.isFavorite ? Icons.favorite : Icons.favorite_border),
                ),
              ),
            ),
          ),
        );
      },
      // ),
    );
  }
}
