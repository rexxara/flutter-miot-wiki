
import 'package:flutter/material.dart';
import './src/app.dart';
import './src/store.dart';
import './src/action.dart';
import './src/reducer.dart';
void main() {
  store.dispatch(warpFetchPost);
  store.dispatch(warpGetHomePageList(store.state.active));
  runApp(new CarouselDemo(
//    title: '产品百科',
//    store: store,
  ));
}

