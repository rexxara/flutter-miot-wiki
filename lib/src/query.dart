
import 'dart:convert';
import 'package:http/http.dart' as http;

class Item{
  final String shortKey;
  final String name;
  final String cnName;
  Item({this.shortKey,this.name,this.cnName});
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        shortKey: json['shortKey'],
        name:json['firstCatalogExpanded']['baseInfo']['name']['en'],
        cnName:json['firstCatalogExpanded']['baseInfo']['name']['cn']
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

Future<Res> fetchPost() async {
  final response =
  await http.get('https://home.mi.com/newoperation/firstCatalogsNoExpand?platform=2&sessionId=9cdd82fb-a7e4-46dc-9701-9d64cc3fe1aa');
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    Utf8Decoder utf8decoder = Utf8Decoder();
    return Res.fromJson(json.decode(utf8decoder.convert(response.bodyBytes)));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
///////////////////////
class HomePageListRes {
  String result;
  List<HomePageListItem> content;
  HomePageListRes({this.result,this.content});

  factory HomePageListRes.fromJson(Map<String, dynamic> json) {
    var valuesFromJson = json['data']['firstCatalogExpanded']['content'] as List;
    List<HomePageListItem> valueList = valuesFromJson.map((i) => HomePageListItem.fromJson(i)).toList();
    return HomePageListRes(
        result: json['result'], content:valueList
    );
  }
}
class HomePageListItem{
  final String shortKey;
  final String name;
  final String imgSrc;
  final String owner;
  HomePageListItem({this.shortKey,this.name,this.imgSrc,this.owner});
  factory HomePageListItem.fromJson(Map<String, dynamic> json) {
    return HomePageListItem(
        shortKey: json['shortKey'],
        name:json['product']['name'],
        imgSrc:json['product']['realIcon'],
      owner: json['product']['brandName']['cn']
    );
  }
}
//可以的：新上线 摄像机 传感器 生活家居 门铃门锁 运动穿戴 儿童 健康 车载出行 配件 玩乐
//不可以的：生活家居 照明 开关插座 餐厨 卫浴？？？
Future<HomePageListRes> fetchHomePageList(String shortKey) async {
  final response =
  await http.get('https://home.mi.com/newoperation/firstCatalogWithExpand?platform=1&sessionId=11c9c8eb-17c1-4ba3-86e2-023ff5ce70b1&shortKey=$shortKey');
  if (response.statusCode == 200) {
    Utf8Decoder utf8decoder = Utf8Decoder();
    return HomePageListRes.fromJson(json.decode(utf8decoder.convert(response.bodyBytes)));
  } else {
    throw Exception('Failed to load post');
  }
}
//////////////////////
class DetailRes {
  String result;
  List<String> banner;
  String instructions;
  String tagsKey;
  String youpinLogo;
  String name;
  String installUrl;
  //List<HomePageListItem> content;
  DetailRes({this.result,this.banner,this.instructions,this.tagsKey,this.youpinLogo,this.installUrl,this.name});
  factory DetailRes.fromJson(Map<String, dynamic> json) {

    List<String> bigicons = List<String>.from(json['data']['product']['bigIcons']);
    var tagsKey=json['data']['product']['btChildGatewayShortKey'];
    return DetailRes(
        result: json['result'],
        banner:bigicons,
        instructions:'说明书链接',
        tagsKey:tagsKey==0?'753081211000000001':tagsKey,
        name:json['data']['product']['name'],
        youpinLogo:'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHIAAAByCAYAAACP3YV9AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyhpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTM4IDc5LjE1OTgyNCwgMjAxNi8wOS8xNC0wMTowOTowMSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTcgKE1hY2ludG9zaCkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6Mzg2MDIzRTk3QzUzMTFFOEFCQjREQ0VGNjdERTVDN0QiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6Mzg2MDIzRUE3QzUzMTFFOEFCQjREQ0VGNjdERTVDN0QiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDozODYwMjNFNzdDNTMxMUU4QUJCNERDRUY2N0RFNUM3RCIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDozODYwMjNFODdDNTMxMUU4QUJCNERDRUY2N0RFNUM3RCIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PsARthMAAA0KSURBVHja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'
        ,installUrl:'data:image/png;base64,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'
    );
  }
}

Future<DetailRes> fetchDetail(String shortKey) async {
  final response =
  await http.get('https://home.mi.com/newoperation/product?platform=1&sessionId=efa86f4b-b87f-49ed-b274-eb7bb4d4ba1e&shortKey=$shortKey');
  if (response.statusCode == 200) {
    Utf8Decoder utf8decoder = Utf8Decoder();
    return DetailRes.fromJson(json.decode(utf8decoder.convert(response.bodyBytes)));
  } else {
    throw Exception('Failed to load post');
  }
}

////
class DetailTagRes{
  String result;
  String name;
  String logo;
  //List<HomePageListItem> content;
  DetailTagRes({this.result,this.name,this.logo});
  factory DetailTagRes.fromJson(Map<String, dynamic> json) {
    return DetailTagRes(
        result: json['result'],
        name:json['data']['ablilityReturnValueExpanded']['baseInfo']['name']['cn'],
        logo:json['data']['ablilityReturnValueExpanded']['baseInfo']['logo']
    );
  }
}

Future<DetailTagRes> fetchDetailTag(String tagsKey) async {
  final response =
  await http.get('https://home.mi.com/newoperation/ability?platform=1&sessionId=8386b9e3-94c5-48b9-aa5a-7e90ea0434d3&shortKey=$tagsKey');
  if (response.statusCode == 200) {
    Utf8Decoder utf8decoder = Utf8Decoder();
    return DetailTagRes.fromJson(json.decode(utf8decoder.convert(response.bodyBytes)));
  } else {
    throw Exception('Failed to load post');
  }
}
class Rec{
  String name;
  String imgSrc;
  Rec({this.name,this.imgSrc});
  factory Rec.fromJson(Map<String, dynamic> json) {
    return Rec(
        name:json['name'],
        imgSrc:json['realIcon'],
    );
  }
}
class DefaultRecRes{
  List<Rec> value;
  DefaultRecRes({this.value});
  factory DefaultRecRes.fromJson(Map<String, dynamic> json) {
    var valuesFromJson = json['data']['recommendValue']['products'] as List;
    List<Rec> list = valuesFromJson.map((i) => Rec.fromJson(i)).toList();
    return DefaultRecRes(
        value: list
    );
  }
}
Future<DefaultRecRes> fetchDefaultRec() async {
  final response =
  await http.get('https://home.mi.com/newoperation/getDefaultRecommend?platform=1&sessionId=c799e51c-2b95-448b-9a2a-9feed5fbf1af');
  if (response.statusCode == 200) {
    Utf8Decoder utf8decoder = Utf8Decoder();
    return DefaultRecRes.fromJson(json.decode(utf8decoder.convert(response.bodyBytes)));
  } else {
    throw Exception('Failed to load post');
  }
}