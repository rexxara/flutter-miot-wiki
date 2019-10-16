import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../action.dart';
import '../store.dart';
import 'package:shared_preferences/shared_preferences.dart';

clearLocalStroage(context)async{
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
  Navigator.pop(context);
}

class CustomDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppStore>(
      store: store,
      child: StoreConnector<AppStore,Store<AppStore>>(
        converter: (store)=>store,
    builder: (context, store) {
      return     Material( //创建透明层
        type: MaterialType.transparency, //透明类型
        child:ListView(padding: EdgeInsets.only(right:150.0),
          children: <Widget>[
            DrawerHeader(
              child: Text(store.state.counter.toString()),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            Container(
              height: 9000,
              color: Colors.blueAccent,
              child:ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('change Theme'),
                    onTap: () {
                      store.dispatch(ChangeTheme);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('清除缓存'),
                    onTap: () {
                      clearLocalStroage(context);
                    },
                  )
                ],
              )
            ),

          ],
        ),
      );
        }));
  }
}


