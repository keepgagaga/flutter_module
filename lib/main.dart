import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider(
  //     create: (context) {
  //       return Model1();
  //     },
  //     child: MaterialApp(
  //       theme: ThemeData(
  //         primarySwatch: Colors.blue,
  //       ),
  //       home: Scaffold(
  //         body: SingleStateView(),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Model1()),
        ChangeNotifierProvider.value(value: Model2()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Scaffold(
          body: MultiStateView(),
        ),
      ),
    );
  }
}

class SingleStateView extends StatelessWidget {
  SingleStateView({Key? key}) : super(key: key);

  final ValueNotifier<int> _count = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    _count.value = Provider.of<Model1>(context).count;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              Provider.of<Model1>(context, listen: false).count++;
            },
            child: const Text(
              'Model1 count++',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Model count value change listen'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('Model1 count: ${Provider.of<Model1>(context).count}'),
          ),
          ValueListenableBuilder(
            valueListenable: _count,
            builder: (context, count, child) =>
                Text('ValueListenableBuilder count: $count'),
          )
        ],
      ),
    );
  }
}

class MultiStateView extends StatelessWidget {
  const MultiStateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              Provider.of<Model1>(context, listen: false).count++;
            },
            child: const Text(
              'Model1 count++',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              Provider.of<Model2>(context, listen: false).count++;
            },
            child: const Text(
              'Model2 count++',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Model count value change listen'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('Model1 count: ${Provider.of<Model1>(context).count}'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('Model2 count: ${Provider.of<Model2>(context).count}'),
          ),
          ProxyProvider<Model1, User>(
            update: (context, value, previous) =>
                User("change value ${value.count}"),
            builder: (context, child) => Text(
              'ProxyProvider: ${Provider.of<User>(context).name}',
            ),
          ),
          FutureProvider<Model1>(
            create: (context) {
              return Future.delayed(const Duration(seconds: 2))
                  .then((value) => Model1()..count = 11);
            },
            initialData: Model1(),
            builder: (context, child) => Text(
              'FutureProvider ${Provider.of<Model1>(context).count}',
            ),
          ),
          StreamProvider(
            create: (context) {
              return Stream.periodic(
                  const Duration(seconds: 1), (data) => Model1()..count = data);
            },
            initialData: Model1(),
            builder: (context, child) => Text(
              'StreamProvider: ${Provider.of<Model1>(context).count}',
            ),
          ),
          Consumer<Model1>(
            builder: (context, model, child) {
              return Text('Model1 count: ${model.count}');
            },
          ),
          Selector<Model1, int>(
            builder: (context, count, child) => Text('Selector演示: $count'),
            selector: (context, model) => model.count,
          ),
        ],
      ),
    );
  }
}

class Model1 extends ChangeNotifier {
  int _count = 1;
  int get count => _count;
  set count(int value) {
    _count = value;
    notifyListeners();
  }
}

class Model2 extends ChangeNotifier {
  int _count = 1;
  int get count => _count;
  set count(int value) {
    _count = value;
    notifyListeners();
  }
}

class User {
  var name;
  User(this.name);
}
