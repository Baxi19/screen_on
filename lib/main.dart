import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      return;
    }

    final isBackground = state == AppLifecycleState.paused;
    if (isBackground) {
      print("In Background!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Screen On / Off'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Spacer(
                flex: 3,
              ),
              FutureBuilder(
                future: Wakelock.enabled,
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  final data = snapshot.data;
                  // The use of FutureBuilder is necessary here to await the
                  // bool value from the `enabled` getter.
                  if (data == null) {
                    // The Future is retrieved so fast that you will not be able
                    // to see any loading indicator.
                    return Container();
                  }

                  return Text('The wakelock is currently '
                      '${data ? 'enabled' : 'disabled'}. ');
                },
              ),
              OutlinedButton(
                onPressed: () {
                  // The following code will enable the wakelock on the device
                  // using the wakelock plugin.
                  setState(() {
                    if (!isEnabled) {
                      Wakelock.enable();
                      isEnabled = true;
                    } else {
                      Wakelock.disable();
                      isEnabled = false;
                    }
                    // You could also use Wakelock.toggle(on: true);
                  });
                },
                child: isEnabled
                    ? const Text('disable wakelock')
                    : const Text('enable wakelock'),
              ),
              const Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
