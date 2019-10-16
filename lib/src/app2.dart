//import 'package:flutter/material.dart';
//import 'store.dart';
//import 'package:flutter_redux/flutter_redux.dart';
//import 'package:redux/redux.dart';
//import 'action.dart';
//import 'components/darwer.dart';
//import 'package:flutter/painting.dart';
//import './components/reader.dart';
//
//
//Route _createRoute() {
//  return PageRouteBuilder(
//    pageBuilder: (context, animation, secondaryAnimation) => MainReader(),//第二页的组件
//    transitionsBuilder: (context, animation, secondaryAnimation, child) {//过度动画
//      var begin = Offset(0.0, 1.0);
//      var end = Offset.zero;
//      var curve = Curves.ease;
//      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//      return SlideTransition(
//        position: animation.drive(tween),
//        child: child,
//      );
//    },
//  );
//}
//
//class FlutterReduxApp extends StatelessWidget {
//  final Store<AppStore> store;
//  final String title;
//  FlutterReduxApp({Key key, this.store, this.title}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    // StoreProvider包裹整个app
//    return new StoreProvider<AppStore>(
//      store: store,
//      child:  StoreConnector<AppStore,Store<AppStore>>(
//        converter: (store)=>store,
//        builder: (context, store) {
//          return MaterialApp(
//            theme: store.state.theme,
//            title: title,
//            home: new Scaffold(
//              drawer: CustomDrawer(),
//              appBar: new AppBar(
//                title: new Text(title),
//              ),
//              body:GridView.builder(
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: 2,
//                mainAxisSpacing: 20.0,
//                crossAxisSpacing: 20.0,
//                childAspectRatio: 0.56,
//                ),
//                itemCount: store.state.books.length,
//                itemBuilder: (BuildContext context,int index){
//                  return GestureDetector(
//                    onTap: (){
//                          store.dispatch(OpenBookWithSrc(store.state.books[index].src));
//                          Navigator.of(context).push(_createRoute());
//                    },
//                    child:GridTile(
//                      child:  Container(
//                          color: store.state.theme.primaryColorDark,
//                          padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
//                          child:Image.network(store.state.books[index].coverSrc,scale: 1,fit:BoxFit.cover)),
//                      footer: Text(store.state.books[index].title,style:TextStyle(fontSize: 16.0,color: store.state.theme.primaryColorLight)),
//                    )  ,
//                  );
//                },
//              ),
//              floatingActionButton: FloatingActionButton(
//                    onPressed: ()=>store.dispatch(Increment),
//                    tooltip: 'Increment',
//                    child: new Icon(Icons.add),
//                  )
//            ),
//          );
//        },
//      )
//    );
//  }
//}
//



import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


final List<String> imgList = [
  'http://cnbj1.fds.api.xiaomi.com/plato-banner/developer_15676546142474FM1Bg3H.jpg?GalaxyAccessKeyId=AKVGLQWBOVIRQ3XLEW&Expires=9223372036854775807&Signature=dsuDuOiE1QO8z7tj3h4JcVIWZf0=',
  'http://cnbj1.fds.api.xiaomi.com/plato-banner/developer_1569399877032zKKmZCZU.jpg?GalaxyAccessKeyId=AKVGLQWBOVIRQ3XLEW&Expires=9223372036854775807&Signature=r0TCZZ7eb1Nc4huJC/viuOADwN8=',
  'https://cdn.cnbj0.fds.api.mi-img.com/miio.files/commonfile_jpg_9d44a10962fe9e1aeb5a7bda96b7e0e4.jpg',
  'https://cdn.cnbj0.fds.api.mi-img.com/miio.files/commonfile_jpg_7a2e0eb14bff4687d96f1564c5485a68.jpg'
];
CarouselSlider getFullScreenCarousel(BuildContext mediaContext) {
  return CarouselSlider(
    autoPlay: true,
    viewportFraction: 1.0,
    aspectRatio: MediaQuery.of(mediaContext).size.aspectRatio,
    items: imgList.map(
          (url) {
        return Container(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              width: 1000.0,
            ),
          ),
        );
      },
    ).toList(),
  );
}
Future<Res> fetchPost() async {
  final response =
  await http.get('https://home.mi.com/newoperation/firstCatalogsNoExpand?platform=2&sessionId=9cdd82fb-a7e4-46dc-9701-9d64cc3fe1aa');
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Res.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}


class Item{
  final String shortKey;
  final String name;
  Item({this.shortKey,this.name});
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      shortKey: json['shortKey'],
      name:Utf8Decoder().convert(json['firstCatalogExpanded']['baseInfo']['name']['cn'] )
    );
  }
}
class Res {
   String result;
   List<Item> dataList;
   Res({this.result,this.dataList});

  factory Res.fromJson(Map<String, dynamic> json) {
    var valuesFromJson = json['data']['values'] as List;
    List<Item> valueList = valuesFromJson.map((i) => Item.fromJson(i)).toList();
    return Res(
      result: json['result'], dataList:valueList
    );
  }
}

class FlutterReduxApp extends StatelessWidget {
  final Future<Res> post;

  FlutterReduxApp({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '产品百科',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('产品百科'),
        ),
        body:ListView(
          children: <Widget>[
            Container(
              height: (MediaQuery.of(context).size.width/16)*9,
                //Builder needed to provide mediaQuery context from material app
                child: Padding(
                  child: Builder(builder: (context) {
                    return Column(
                        children:[getFullScreenCarousel(context)]
                    );
                  }),
                )),
            Container(
              padding: EdgeInsets.only(top: 15.0),
              height: 400.0,
              child: FutureBuilder<Res>(
                future: post,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(itemBuilder: (BuildContext context, int index) {
                      final item = snapshot.data.dataList[index];
                      final shortKey=item.name;
                      return new Text('NO.$index,____$shortKey');
                    },itemCount: snapshot.data.dataList.length);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
            )

          ],
        ),
//        Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: [
//            CarouselSlider(
//            height: 400.0,
//            items: [1,2,3,4,5].map((i) {
//              return Builder(
//                builder: (BuildContext context) {
//                  return Container(
//                      width: MediaQuery.of(context).size.width,
//                      margin: EdgeInsets.symmetric(horizontal: 5.0),
//                      decoration: BoxDecoration(
//                          color: Colors.amber
//                      ),
//                      child: Text('tx98xt $i', style: TextStyle(fontSize: 16.0),)
//                  );
//                },
//              );
//            }).toList(),
//          ),
//
//          ],
//        )
      ),
    );
  }
}