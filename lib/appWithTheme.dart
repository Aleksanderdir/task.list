import 'package:flutter/material.dart';

class appWithTheme extends StatelessWidget {
  const appWithTheme({Key? key}) : super(key: key);

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
            body: null,
          ),
        );
      },
    );
  }
}
