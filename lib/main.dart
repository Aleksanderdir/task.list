import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:task_list/CenterListWidget.dart';
import 'package:task_list/repoData.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepoData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        final textColor = mode == ThemeMode.light ? Colors.black : Colors.white;
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: Scaffold(
            appBar: AppBar(
              title: Text('Список задач', style: TextStyle(color: textColor)),
              actions: <Widget>[
                IconButton(
                  icon: Icon(mode == ThemeMode.light
                      ? Icons.wb_incandescent
                      : Icons.wb_incandescent_outlined),
                  color: Colors.white,
                  onPressed: () => _notifier.value = mode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light,
                ),
              ],
            ),
            body: ScaffoldWithWillpop(),
          ),
        );
      },
    );
  }
}

class ScaffoldWithWillpop extends StatelessWidget {
  const ScaffoldWithWillpop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      print('_onWillPop');

      try {
        return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit an App'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                ],
              ),
            )) ??
            false;
      } catch (e) {
        print('Error: $e');
        return true;
      }
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: CenterListWidget(),
      ),
    );
  }
}
