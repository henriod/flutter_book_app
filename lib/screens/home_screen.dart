import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbookapp/constants/color_constant.dart';
import 'package:flutterbookapp/models/newbook_model.dart';
import 'package:flutterbookapp/models/popularbook_model.dart';
import 'package:flutterbookapp/screens/selected_book_screen.dart';
import 'package:flutterbookapp/widgets/custom_tab_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future getPopbook() async{
    var response = await http.get(Uri.http("138.68.180.28","api/v1/library/books/"));
    var jsonData = jsonDecode(response.body);

    List<PopularBookModel> pops =[];

    for(var p in jsonData['results']){
      // var author = await http.get(Uri.http('138.68.180.28', 'api/v1/library/authors/${p["author"][0]}'));
      // var authorj = jsonDecode(author.body);
      PopularBookModel pop = PopularBookModel(p["title"], p["id"], p["publication_date"], p["book_cover"], 0xFFFFD3B6, p["summary"]);
      pops.add(pop);
    }
    return pops;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 25, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hi, Rizki',
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kGreyColor),
                      ),
                      Text(
                        'Discover Latest Book',
                        style: GoogleFonts.openSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: kBlackColor),
                      ),
                    ],
                  )),
              Container(
                height: 39,
                margin: EdgeInsets.only(left: 25, right: 25, top: 18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kLightGreyColor),
                child: Stack(
                  children: <Widget>[
                    TextField(
                      maxLengthEnforced: true,
                      style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: kBlackColor,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 19, right: 50, bottom: 8),
                          border: InputBorder.none,
                          hintText: 'Search book..',
                          hintStyle: GoogleFonts.openSans(
                              fontSize: 12,
                              color: kGreyColor,
                              fontWeight: FontWeight.w600)),
                    ),
                    Positioned(
                      right: 0,
                      child: SvgPicture.asset('assets/svg/background_search.svg'),
                    ),
                    Positioned(
                      top: 8,
                      right: 9,
                      child:
                          SvgPicture.asset('assets/icons/icon_search_white.svg'),
                    )
                  ],
                ),
              ),
              Container(
                height: 25,
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(left: 25),
                child: DefaultTabController(
                  length: 3,
                  child: TabBar(
                      labelPadding: EdgeInsets.all(0),
                      indicatorPadding: EdgeInsets.all(0),
                      isScrollable: true,
                      labelColor: kBlackColor,
                      unselectedLabelColor: kGreyColor,
                      labelStyle: GoogleFonts.openSans(
                          fontSize: 14, fontWeight: FontWeight.w700),
                      unselectedLabelStyle: GoogleFonts.openSans(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      indicator: RoundedRectangleTabIndicator(
                          weight: 2, width: 10, color: kBlackColor),
                      tabs: [
                        Tab(
                          child: Container(
                            margin: EdgeInsets.only(right: 23),
                            child: Text('New'),
                          ),
                        ),
                        Tab(
                          child: Container(
                            margin: EdgeInsets.only(right: 23),
                            child: Text('Trending'),
                          ),
                        ),
                        Tab(
                          child: Container(
                            margin: EdgeInsets.only(right: 23),
                            child: Text('Best Seller'),
                          ),
                        )
                      ]),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 21),
                height: 210,
                child:
                  FutureBuilder(
                    future: getPopbook(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
                            child: Text('Loading...'),
                          ),
                        );
                      } else
                        return
                          ListView.builder(
                              padding: EdgeInsets.only(left: 25, right: 6),
                              itemCount: snapshot.data.length,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      print('ListView Tapped');
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SelectedBookScreen(
                                                  popularBookModel: snapshot
                                                      .data[index]),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 19),
                                      height: 210,
                                      width: 153,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          color: kMainColor,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                snapshot.data[index].image),
                                          )),
                                    )
                                );
                              });
                    })
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 25),
                child: Text(
                  'Popular',
                  style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: kBlackColor),
                ),
              ),
              FutureBuilder(
                  future: getPopbook(),
                  builder: (context, snapshot){
                    if(snapshot.data == null){
                      return Container(
                        child: Center(
                          child: Text('Loading...'),
                        ),
                      );
                    } else return
                      ListView.builder(
                        padding: EdgeInsets.only(top: 25, right: 25, left: 25),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print('ListView Tapped');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectedBookScreen(
                                      popularBookModel: snapshot.data[index]),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 19),
                              height: 81,
                              width: MediaQuery.of(context).size.width - 50,
                              color: kBackgroundColor,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 81,
                                    width: 62,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          image: NetworkImage(snapshot.data[index].image),
                                        ),
                                        color: kMainColor),
                                  ),
                                  SizedBox(
                                    width: 21,
                                  ),
                                  Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index].title,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: GoogleFonts.openSans(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: kBlackColor),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            snapshot.data[index].author,
                                            style: GoogleFonts.openSans(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: kGreyColor),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '\$' + snapshot.data[index].price,
                                            style: GoogleFonts.openSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: kBlackColor),
                                          )
                                        ],
                                      )
                                  ),

                                ],
                              ),
                            ),
                          );
                        });

                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
