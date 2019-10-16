import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/src/store.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import './store.dart';
import 'dart:convert';
const arr='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAA8CAYAAAA6/NlyAAAAAXNSR0IArs4c6QAAA9pJREFUaAXtml1IVEEUgN0/3SRCeojapQh6CgIfgt4iDX+KColgwTAXMbV66McIgqiHonoqKupBV9m0IFgoKAofCswWIoICX4oWCimKkMAIItlYt+9cHBmWVfZH5M7tDoxz5sy97P3OOXNm7lwrKtziWsC1gGsB1wKuBVwLuBZYIgt4luh3Cv6Z/v7+Q1x8ljoWCASOdHR0/Cz45gIu9BZwzVJfciabzYaorel0+vnw8PCqxXwAOwLf0QBrp6enk319fes0XVmi7UIaz3oI62tQHdXIvng8nobu7u6UpitJtJ2HAcv29PQcg+aCRrQWQyQHBwdrNV1Jou08rFPg6V5ArygdxpAEtgtPv1S6YltbAwsM8/egNFQrGoH+Td3b1dX1VMaLLbYHFiA8HcHTdxED0gc4TW0F+oH0iym2m8P5Hp4QTgDYwtgfGQe+kprA+9F81y+kMwJYAIAe8Xq9zYi/pA+wDyPEgdazuQwtWIwBFgpCOAn0dsQf0gdapuR1oGVnVlAxYg7nksRisY0zMzOStMJqDG9fJQpOqv58rZHAAhOPx9ez9XyGuEHBAT1IFHTTzihdbmsssIAAvRpo8fQmBQZsglBvY/PyV+n01qg5rD+4yLxJfff5fNuAfK3GgI3Qf5hIJJYpnd4a7WEFAtzyqampR/TrlQ7oZHV19e62tjYrq8/plWB6S3gHCe8EHHs0lrfIzYS3ldVF7wgPK8DR0VF/KpUaor9f6fD0+6qqqsZoNPpVdI4CFiDmsJet6E3Ew9KfLRO0DXj6o+OAFSGbkcvIp1WfVhJco2OBBRRoARZwqxDer4xelhTIfC2A2dwxx3p4vpD25VrA9L4krVAodAuOExrLBHIde+0PjvLwf7Us5dt4MIff4PEdjtt4/Fdby4GBgZW8G4/gyS1qzuLZkZqamn2RSMQ6ElJ6aY1elsjEazKZzFgOrLwetuSDFWC//DGx5DsAgGOAA4AePOysA4ByjniMC2lgNzNnX+DNufMs5HOFnGdJJBu1DgO7FdjHPPcK6+HZOlKOs+zckH4hxRhgXvl2AncfKOvohnmaod8J7FAhoOoaI4AX81OL7ffSLD3yMe021VpR8Kx8TGshGz9RXiumtXXSwrO9wMSo1nMCKp9Lm4CVo9mSim1DGs+eh0j/hDLp9/ubOjs7x0sinb3JdiFNIvKEw2HJuqc0sM94tx7PvtN0JYm2Awb2EtBz34gAlf/rqCcbfyqJMOcmO24tD2jPOB4MBpva29snNV1Zoh2T1kW8+o16r7Kysm4xYcuylHuzawHXAq4FXAu4FnAt4FqgWAv8A9InW0hpLSK0AAAAAElFTkSuQmCC';
const handle='data:image/png;base64,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';
class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: JsonView(),
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
  @override
  void initState () {
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppStore>(
        store: store,
        child: StoreConnector<AppStore,Store<AppStore>>(
            converter: (store)=>store,
            builder: (context, store) {
              print(store.state.detail.banner[0]);
              final String youpinLogo=store.state.detail.youpinLogo;
              return ListView(
                children: <Widget>[
                  Image.network(store.state.detail.banner[0],fit: BoxFit.cover),
                  Container(
                    padding: EdgeInsets.only(left: 16.0,top: 8.0,right: 0.0,bottom: 8.0),
                    child: Text(store.state.detail.name,style: TextStyle(fontSize: 24.0,color: Colors.grey),),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    height: 160.0,
                    child:Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 20.0,top: 10.0,right: 20.0,bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  height: 30.0,
                                  child: Text('产品说明书',style: TextStyle(fontSize: 18.0),),
                                ),
                                Container(
                                  width: 30.0,
                                  height: 30.0,
                                  child:Image.memory(Base64Decoder().convert(arr.substring("data:image/png;base64,".length)),fit: BoxFit.cover,),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10.0),
                                height: 1.0,
                                width: MediaQuery.of(context).size.width*0.9,
                                color: Color.fromRGBO(229, 229, 229, 1),
                                child: null,
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20.0,top: 10.0,right: 20.0,bottom: 00.0),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 5.0,top: 5.0,right: 0.0,bottom: 5.0),
                                  child: Text('标签',style: TextStyle(fontSize: 18.0),),
                                ),
                                Container(
                                  height: 50.0,
                                  child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                    color: Color.fromRGBO(237, 237, 237, 1),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 5.0,top: 5.0,right: 5.0,bottom: 5.0),
                                          child:ClipRRect(
                                            borderRadius: BorderRadius.circular(100.0),
                                            child: Image.network(store.state.detailTag.logo,fit: BoxFit.cover),
                                          )
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 5.0,top: 00.0,right: 5.0,bottom: 00.0),
                                          child:Text(store.state.detailTag.name),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),),
                        ],
                      ),
                    ) ,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    height: 80.0,
                    child:Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 20.0,top: 10.0,right: 20.0,bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 30.0,
                                  height: 30.0,
                                  child:Image.memory(Base64Decoder().convert(youpinLogo.substring("data:image/png;base64,".length)),fit: BoxFit.cover,),
                                ),
                                Container(
                                  height: 30.0,
                                  child: Text('在有品平台购买',style: TextStyle(fontSize: 18.0),),
                                ),
                                Container(
                                  width: 30.0,
                                  height: 30.0,
                                  child:Image.memory(Base64Decoder().convert(arr.substring("data:image/png;base64,".length)),fit: BoxFit.cover,),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ) ,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    height: 80.0,
                    child:Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 20.0,top: 10.0,right: 20.0,bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 30.0,
                                  height: 30.0,
                                  child:Image.memory(Base64Decoder().convert(handle.substring("data:image/png;base64,".length)),fit: BoxFit.cover,),
                                ),
                                Container(
                                  height: 30.0,
                                  child: Text('预约安装',style: TextStyle(fontSize: 18.0),),
                                ),
                                Container(
                                  width: 30.0,
                                  height: 30.0,
                                  child:Image.memory(Base64Decoder().convert(arr.substring("data:image/png;base64,".length)),fit: BoxFit.cover,),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ) ,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0,top: 8.0,right: 0.0,bottom: 8.0),
                    child: Text('默认推荐',style: TextStyle(fontSize: 24.0,color: Colors.grey),),
                  ),
                  Container(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            child:Container(
                              padding: EdgeInsets.only(left: 15.0,top: 15.0,right: 15.0,bottom: 5.0),
                              width: 100,
                              height: 100,
                              child: Column(
                                children: <Widget>[
                                  Image.network(store.state.defaultRec.value[index].imgSrc,fit: BoxFit.cover,),
                                  Text(store.state.defaultRec.value[index].name),
                                ],
                              ),
                            ),
                        );
                          
                      },
                      itemCount: store.state.defaultRec.value.length,
                    ),
                  )
                ],
              );

            }
        ));}
}