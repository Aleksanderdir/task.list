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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: Row(children: <Widget>[
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('Tasks',
                      //  textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w800,
                      )),
                ),
              ),
              IconButton(
                iconSize: 54.0,
                splashRadius: 32.0,
                onPressed: () {
                  context.read<RepoData>().setVisible(true);
                },
                icon: const Icon(
                  Icons.add,
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ]),
          ),
          VisibleWidget(controller: controller),
          SizedBox(
            height: 5,
          ),
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
  VisibleWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    void _onChange() {
      context.read<RepoData>().setErrorText(false);
    }

    return Visibility(
      replacement: const SizedBox.shrink(),
      // maintainSize: false,
      // maintainAnimation: true,
      visible: context.watch<RepoData>().getVisible,
      child: TextField(
        onChanged: (String a) {
          _onChange();
        },
        textInputAction: TextInputAction.done,
        keyboardAppearance: Brightness.light,
        enabled: true,
        autofocus: true,
        controller: controller,
        onEditingComplete: () async {
          if (controller.text == null || controller.text == '') {
            context.read<RepoData>().setErrorText(true);
          } else {
            context.read<RepoData>().setErrorText(false);
            fluversCrud crud = fluversCrud();
            // crud.init();
            int id = await crud.add(controller.text);
            Flavor flavor = Flavor(NameFlavor: controller.text, Id: id);
            context.read<RepoData>().addFlavor(flavor);
            context.read<RepoData>().setVisible(false);
            _onChange();

            controller.clear();
          }
          /*
          ItemTaskCrud crud = ItemTaskCrud();
          int id = await crud.add(controller.text);
          ItemTask itemTask = ItemTask.create(id, controller.text, false);
          context.read<RepoData>().addTask(itemTask);
           */
        },
        decoration: InputDecoration(
            labelText: 'Введите имя задачи',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: context.read<RepoData>().getErrorText
                        ? Colors.red
                        : Colors.blueAccent,
                    width: 1.0)),
            errorText: context.read<RepoData>().getErrorText
                ? 'Поле ввода не может быть пустым'
                : null),
        // decoration: const InputDecoration(
        //   hintText: '',
      ),
    );
  }
}
