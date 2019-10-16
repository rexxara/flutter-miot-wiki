
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../store.dart';

class MainReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new JsonView(),
    );
  }
}

class JsonView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _JsonViewState();
  }
}

class _JsonViewState extends State<JsonView> {
  double offset=0;
  bool notLoaded=true;
  ScrollController _controller = new ScrollController();
  final key=store.state.currentBook+'offset';

  @override
  void initState () {
    //监听滚动事件，打印滚动位置
    getInitOffset();
    _controller.addListener(() async{
      final prefs = await SharedPreferences.getInstance();
      prefs.setDouble(key, _controller.offset);
    });

  }
  getInitOffset()async{
    final prefs = await SharedPreferences.getInstance();
    final keys=prefs.getKeys();
    if(!keys.contains(key)){
      setState(() {
        notLoaded=false;
      });
    }
  }
  animateTo()async{
    await new Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    final cacheOffset=prefs.getDouble(key);
    setState(() {
      offset=cacheOffset;
    });
    _controller.jumpTo(cacheOffset);
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppStore>(
        store: store,
        child: StoreConnector<AppStore,Store<AppStore>>(
            converter: (store)=>store,
            builder: (context, store) {
              return FutureBuilder(
                future: DefaultAssetBundle.of(context).loadString(store.state.currentBook),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Scrollbar(
                        child:notLoaded?Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('从上次结束的地方开始吗？',style: TextStyle(color: store.state.theme.primaryColorLight)),
                                  RaisedButton(
                                      child: Text('是'),
                                      onPressed: () {
                                        animateTo();
                                        setState(() {
                                          notLoaded=false;
                                        });
                                      }
                                  ),
                                  RaisedButton(
                                      child: Text('否'),
                                      onPressed: () {
                                        setState(() {
                                          notLoaded=false;
                                        });
                                      }
                                  )
                                ],
                              )])
                            :ListView.builder(
                            itemCount: 1,
                            controller: _controller,
                            itemBuilder: (context, index) {
                              return Text(snapshot.data.toString(),style: TextStyle(fontSize: 24.0,color: store.state.theme.primaryColorLight));
                            }
                        )
                    );
                  }
                  return new CircularProgressIndicator();
                },
              );
            }
        ));}
}

