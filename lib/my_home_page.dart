import 'dart:convert';

import 'package:audio/detail_audio_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:audio/app_colors.dart' as AppColors;
import 'package:flutter/material.dart';

import 'my_tabs.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  List popularBooks;
  List books;
  ScrollController _scrollController;
  TabController _tabController;
  ReadData() async {
   await DefaultAssetBundle.of(context).loadString("json/popularBooks.json").then((s){
      setState(() {
       popularBooks = json.decode(s);
      });
    });
   await DefaultAssetBundle.of(context).loadString("json/books.json").then((s){
     setState(() {
       books = json.decode(s);
     });
   });
  }

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    ReadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
          child: SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImageIcon(AssetImage("img/menu.png"), size:24, color:Colors.black),
                      Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 10,),
                          Icon(Icons.notifications),
                        ],
                      )
                    ],
                  ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Text("Popular Books", style: TextStyle(fontSize: 30))

                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 180,
                    child: Stack(
                     children: [

                      Positioned(
                        top:0,
                        left: -20,
                        right: 0,
                        child: Container(
                    height: 180,
                    child: PageView.builder(
                        controller: PageController(viewportFraction: 0.8),
                        itemCount: popularBooks==null?0:popularBooks.length,
                        itemBuilder: (_, i){
                      return Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image:DecorationImage(
                            image:AssetImage(popularBooks[i]["img"]),
                            fit:BoxFit.fill,
                          )
                        ),
                      );
                    }),
                  )
                      )
                      ]

                    )
                  ),
                  Expanded(child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (BuildContext context, bool isScroll){

                      return[
                        SliverAppBar(
                          pinned: true,
                            backgroundColor:AppColors.sliverBackground,
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(50),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20, left: 10),
                              child: TabBar(
                                indicatorPadding: const EdgeInsets.all(0),
                                indicatorSize: TabBarIndicatorSize.label,
                                labelPadding: const EdgeInsets.only(right: 10),
                                controller: _tabController,
                                isScrollable: true,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color:Colors.grey.withOpacity(0.2),
                                      blurRadius: 7,
                                      offset: Offset(0, 0),
                                    )
                                  ]
                                ),
                                tabs: [
                                  AppTabs(color:AppColors.menu1Color, text:"New"),
                                  AppTabs(color:AppColors.menu2Color, text:"Popular"),
                                  AppTabs(color:AppColors.menu3Color, text:"Trending"),
                                ],
                              ),
                            ),
                          ),
                        )
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        ListView.builder(
                            itemCount: books==null?0:books.length,
                            itemBuilder: (_,i){
                          return
                            GestureDetector(
                              onTap:(){
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>DetailAudioPage(booksData:books, index:i))
                                );
                              },

                            child:Container(
                            margin: const EdgeInsets.only(left:20, right: 20,top:10, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:AppColors.tabVarViewColor,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    offset: Offset(0, 0),
                                    color:Colors.grey.withOpacity(0.2),
                                  )
                                ]
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: AssetImage(books[i]["img"]),
                                          )
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.star, size:24, color:AppColors.starColor),
                                            SizedBox(width: 5,),
                                            Text(books[i]["rating"], style: TextStyle(
                                                color:AppColors.menu2Color
                                            ),),
                                          ],
                                        ),
                                        Text(books[i]["title"], style: TextStyle(fontSize: 16, fontFamily: "Avenir", fontWeight: FontWeight.bold),),
                                        Text(books[i]["text"], style: TextStyle(fontSize: 16, fontFamily: "Avenir", color:AppColors.subTitleText),),
                                        Container(
                                          width: 60,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            color:AppColors.loveColor,
                                          ),
                                          child:Text("Love", style: TextStyle(fontSize: 10, fontFamily: "Avenir", color:Colors.white),),
                                          alignment: Alignment.center,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                            );
                        }),
                        Material(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                            ),
                            title: Text("Content"),
                          ),

                        ),
                        Material(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                            ),
                            title: Text("Content"),
                          ),

                        ),
                      ],

                    ),
                  ))
                ],
              ),
            ),
          ),
    );
  }
}
