import 'package:flutter/material.dart';
import 'package:image_collage_widget/utils/CollageType.dart';

import 'src/screens/collage_sample.dart';
import 'src/tranistions/fade_route_transition.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // ignore: deprecated_member_use
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );
}

// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var color = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildRaisedButton(CollageType collageType, String text) {
      return ElevatedButton(
        onPressed: () => pushImageWidget(collageType),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text),
        ),
      );
    }

    ///Create multple shapes
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: <Widget>[
            buildRaisedButton(CollageType.VSplit, 'Vsplit'),
            buildRaisedButton(CollageType.HSplit, 'HSplit'),
            buildRaisedButton(CollageType.VFour, 'VFour'),
            buildRaisedButton(CollageType.HFour, 'HFour'),
            buildRaisedButton(CollageType.ThreeVertical, 'ThreeVertical'),
            buildRaisedButton(CollageType.ThreeHorizontal, 'ThreeHorizontal'),
            buildRaisedButton(CollageType.SixSquare, 'SixSquare'),
            buildRaisedButton(CollageType.LeftBig, 'LeftBig'),
            buildRaisedButton(CollageType.RightBig, 'RightBig'),
            buildRaisedButton(CollageType.VMiddleTwo, 'VMiddleTwo'),
            buildRaisedButton(CollageType.CenterBig, 'CenterBig'),
          ],
        ),
      ),
    );
  }

  ///On click of perticular type of button show that type of widget
  pushImageWidget(CollageType type) async {
    await Navigator.of(context).push(
      FadeRouteTransition(page: CollageSample(type)),
    );
  }

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
  }
}
