import 'query.dart';
class  Increment {}

class ChangeTheme{}

class OpenBookWithSrc {
   final String src;
   OpenBookWithSrc(this.src);
}

class SaveRes{
   Res res;
   SaveRes(this.res);
}
class SaveHomepageList{
   HomePageListRes res;
   String shortKey;
   SaveHomepageList(this.res,this.shortKey);
}
class SaveDetail{
   DetailRes res;
   SaveDetail(this.res);
}
class SaveDetailTag{
   DetailTagRes res;
   SaveDetailTag(this.res);
}
class SaveDefaultRec{
   DefaultRecRes res;
   SaveDefaultRec(this.res);
}