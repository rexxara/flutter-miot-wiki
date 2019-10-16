import 'package:flutter/material.dart';
import 'package:flutter_app/src/store.dart' ;
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'action.dart';
import 'store.dart';
import 'query.dart';

ThunkAction<AppStore> warpFetchPost = (Store<AppStore> store) async {
  Res response = await fetchPost();
  store.dispatch(SaveRes(response));
};
ThunkAction<AppStore> warpGetHomePageList (String shortKey) {
  return (Store<AppStore> store) async {
    final HomePageListRes response = await fetchHomePageList(shortKey);
    print(shortKey);
    store.dispatch(SaveHomepageList(response,shortKey));
  };
}
ThunkAction<AppStore> warpGetDetail (String shortKey) {
  return (Store<AppStore> store) async {
    final DetailRes response = await fetchDetail(shortKey);
    store.dispatch(GetDetailTag(response.tagsKey));
    store.dispatch(GetDefaultRec());
    store.dispatch(SaveDetail(response));
  };
}
ThunkAction<AppStore> GetDetailTag (String tagsKey) {
  return (Store<AppStore> store) async {
    final DetailTagRes response = await fetchDetailTag(tagsKey);
    store.dispatch(SaveDetailTag(response));
  };
}

ThunkAction<AppStore> GetDefaultRec () {
  return (Store<AppStore> store) async {
    final DefaultRecRes response = await fetchDefaultRec();
    store.dispatch(SaveDefaultRec(response));
  };
}
AppStore counterReducer(AppStore state, dynamic action) {
  if(action is SaveHomepageList){
    state.homePageList=action.res;
    state.active=action.shortKey;
    return state;
  }
  if(action is SaveDefaultRec){
    state.defaultRec=action.res;
    return state;
  }
  if(action is SaveDetailTag){
    state.detailTag=action.res;
    return state;
  }
  if(action is SaveRes){
      state.homePageTag=action.res;
      return state;
  }
  if(action is SaveDetail){
    print('saveDetal');
    state.detail=action.res;
  }
  if (action == Increment) {
    print('actionIncreament');
    state.counter=state.counter+1;
    return state;
  }
  if (action == ChangeTheme) {
  print('actionChangeTheme');
    state.theme=state.theme==ThemeData.dark()?ThemeData.light():ThemeData.dark();
    return state;
  }
  if (action is OpenBookWithSrc) {
    print(action.src);
    state.currentBook=action.src;
    return state;
  }
  return state;
}