import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_flash/NewsView.dart';
import 'dart:convert';

import 'package:news_flash/model.dart';

class Category extends StatefulWidget {

  // ignore: non_constant_identifier_names
  final String Query;

  // ignore: non_constant_identifier_names
  const Category({Key? key, required this.Query}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  bool isLoading = true;
  getNewsByQuery(String query) async{
    String url = "";
   // if(query == "India"){
   //   url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=32d6a25f5fbe40218d3cba485eec08fe";

   // }
    if(query == "Health"){
      url = "https://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=32d6a25f5fbe40218d3cba485eec08fe";
    }

    else{
      url = "https://newsapi.org/v2/everything?q=$query&apiKey=32d6a25f5fbe40218d3cba485eec08fe";
    }

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element){
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NEWSFLASH"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin :EdgeInsets.fromLTRB(15, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
     SizedBox(width: 12,)   ,
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Text(widget.Query,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 39,
                      ),),
                    ),
                  ],
                ),
              ),
              isLoading ? Container(height: MediaQuery.of(context).size.height - 350, child: Center(child: CircularProgressIndicator(),),) :
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:newsModelList.length,
                  itemBuilder: (context, index) {
                    //    Image.asset("images/news.jpeg")
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsView(newsModelList[index].newsUrl)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 1.0,
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(newsModelList[index].newsImg)),
                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(

                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black12.withOpacity(0),
                                                Colors.black
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter
                                          )
                                      ),
                                      padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            newsModelList[index].newsHead,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(newsModelList[index].newsDES.length > 50 ? "${newsModelList[index].newsDES.substring(0,52)}...." : newsModelList[index].newsDES, style: TextStyle(color: Colors.white,fontSize: 12)
                                            ,)

                                        ],
                                      )))
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

            ],
          ),
        ),
      ),
    );
  }
}
