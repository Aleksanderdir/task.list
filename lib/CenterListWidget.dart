import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_list/flavor.dart';
import 'package:task_list/fluversCrud.dart';
import 'package:task_list/list_page.dart';
import 'package:task_list/repoData.dart';



class CenterListWidget extends StatefulWidget {
  const CenterListWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CenterListWidget> createState() => _CenterListWidgetState();
}

class _CenterListWidgetState extends State<CenterListWidget> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const Expanded(
                      child: Text('Tasks',
                          //  textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    IconButton(
                    iconSize: 50.0,

                      onPressed: () {
                        context.read<RepoData>().setVisible(true);
                      },
                      icon: const Icon(Icons.add,),

                    ),                      SizedBox(height: 100,),
                  ]),
            ),

            VisibleWidget(controller: controller),
            Expanded(
              child: Container(
                child: Center(
                  child: ListPage(),

                  /*
                   ListView(
                    children: _buildList(),
                  ),  */
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




  _loadItemTasks() async {
    fluversCrud crud = fluversCrud();
    List<Flavor> list = await crud.getAll();
    context.read<RepoData>().setFlavor(list);
  }

  @override
  void initState() {
    fluversCrud crud = fluversCrud();
    crud.init();

    super.initState();
    _loadItemTasks();
  }
}

class VisibleWidget extends StatelessWidget {
  const VisibleWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      replacement: const SizedBox.shrink(),
      // maintainSize: false,
      // maintainAnimation: true,
      visible: context.watch<RepoData>().getVisible,
      child: TextField(
        enabled: true,
        autofocus: true,
        controller: controller,
        onEditingComplete: () async {

        fluversCrud crud = fluversCrud();
        crud.init();
        // int id = await  crud.add(controller.text);
   Flavor flavor = Flavor(name: controller.text, id:0);
    context.read<RepoData>().addFlavor(flavor);
       context.read<RepoData>().setVisible(false);
         controller.text = '';
          /*
          ItemTaskCrud crud = ItemTaskCrud();
          int id = await crud.add(controller.text);
          ItemTask itemTask = ItemTask.create(id, controller.text, false);
          context.read<RepoData>().addTask(itemTask);
           */
        },
        decoration: const InputDecoration(
          hintText: 'Enter text of task',
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0)),
        ),
      ),
    );
  }
}
