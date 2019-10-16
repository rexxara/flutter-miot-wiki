import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/store.dart';
import 'store.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'reducer.dart';
import 'package:flutter/painting.dart';
import 'detail.dart';
final List<String> imgList = [
  'http://cnbj1.fds.api.xiaomi.com/plato-banner/developer_15676546142474FM1Bg3H.jpg?GalaxyAccessKeyId=AKVGLQWBOVIRQ3XLEW&Expires=9223372036854775807&Signature=dsuDuOiE1QO8z7tj3h4JcVIWZf0=',
  'http://cnbj1.fds.api.xiaomi.com/plato-banner/developer_1569399877032zKKmZCZU.jpg?GalaxyAccessKeyId=AKVGLQWBOVIRQ3XLEW&Expires=9223372036854775807&Signature=r0TCZZ7eb1Nc4huJC/viuOADwN8=',
  'https://cdn.cnbj0.fds.api.mi-img.com/miio.files/commonfile_jpg_9d44a10962fe9e1aeb5a7bda96b7e0e4.jpg',
  'https://cdn.cnbj0.fds.api.mi-img.com/miio.files/commonfile_jpg_7a2e0eb14bff4687d96f1564c5485a68.jpg'
];
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Detail(),//第二页的组件
    transitionsBuilder: (context, animation, secondaryAnimation, child) {//过度动画
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

final Widget placeholder = Container(color: Colors.grey);

final List child = map<Widget>(
  imgList,
      (index, i) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(children: <Widget>[
          Image.network(i, fit: BoxFit.cover, width: 1000.0),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                'No. $index image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  },
).toList();

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}


class CarouselDemo extends StatelessWidget {

  CarouselDemo({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final CarouselSlider coverScreenExample = CarouselSlider(
      viewportFraction: 1.0,
      aspectRatio: 2.0,
      autoPlay: true,
      enlargeCenterPage: false,
      items: map<Widget>(
        imgList,
            (index, i) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(i), fit: BoxFit.cover),
            ),
          );
        },
      ),
    );

    return MaterialApp(
      title: '产品百科',
      home: Scaffold(
        appBar: AppBar(title: Text('产品百科')),
        body: StoreProvider<AppStore>(
          store: store,
          child: StoreConnector<AppStore,Store<AppStore>>(
            converter: (store)=>store,
            builder: (context,store){
              return ListView(
                children: <Widget>[
                  Container(
                    child: coverScreenExample,
                  ),
                  Container(
                      height: 50.0,
                    //alignment: Alignment.center,
                    child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final item = store.state.homePageTag.dataList[index];
                      final shortKey=item.shortKey;
                      final cnName=item.cnName;
                      return Card(
                        elevation: 10.0,
                          color: shortKey==store.state.active?Color.fromRGBO(0, 188, 156, 1.0):Colors.white,
                        child:GestureDetector(
                          onTap: (){
                          store.dispatch(warpGetHomePageList(shortKey));
                          },
                          child:Container(
                              width: 80.0,
                              height: 45.0,
                              margin: EdgeInsets.only(left:8.0,top:4.5,right:8.0,bottom:4.5),
                              alignment: Alignment.center,
                              child: Text(cnName,style: TextStyle(color:  shortKey==store.state.active?Colors.white:Color.fromRGBO(0, 188, 156, 1.0)))))
                    );
                    //,
                  },
                  itemCount:  store.state.homePageTag.dataList.length)
            ),
                  Container(
                      height: 300.0,
                      //alignment: Alignment.center,
                      child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            final item = store.state.homePageList.content[index];
                            final itemKey=item.shortKey;
                            final name=item.name;
                            final src=item.imgSrc;
                            final owner=item.owner;
                            return Card(
                                elevation: 10.0,
                                child:GestureDetector(
                                    onTap: (){
                                      store.dispatch(warpGetDetail(itemKey));
                                      Navigator.of(context).push(_createRoute());
                                    },
                                    child:Container(
                                        height: 80.0,
                                        margin: EdgeInsets.only(left:8.0,top:4.5,right:8.0,bottom:4.5),
                                        alignment: Alignment.center,
                                        child:ListView(
                                          scrollDirection: Axis.horizontal,
                                         children: <Widget>[
                                            Image.network(src,fit: BoxFit.cover,width: 80.0,),
                                            Container(
                                              height: 80.0,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(itemKey,style: TextStyle(fontSize: 16.0,color: Color.fromRGBO(1, 1, 1, 0))),
                                                  Text(name,style: TextStyle(fontSize: 18.0,color: Color.fromRGBO(51, 51, 51, 1.0))),
                                                  Text(owner,style: TextStyle(fontSize: 16.0,color:Colors.grey),)
                                                ],
                                              ),
                                            )
                                         ],
                                        )))
                            );
                            //,
                          },
                          itemCount:  store.state.homePageTag.dataList.length)
                  )
                ],
              );
          },
          ),
        )
      ),
    );
  }
}
