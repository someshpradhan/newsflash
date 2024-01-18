class NewsQueryModel{
  late String newsHead;
  late String newsDES;
  late String newsImg;
  late String newsUrl;
  NewsQueryModel({this.newsHead ="NEWS HEADLINE",this.newsDES = "SOME NEWS",this.newsImg="SOME URL",this.newsUrl="SOME URL"});
  factory NewsQueryModel.fromMap(Map news){
    return NewsQueryModel(
      newsHead: news["title"],
      newsDES: news["description"],
      newsImg: news["urlToImage"],
      newsUrl: news["url"],

    );
  }



}
