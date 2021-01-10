import 'package:cached_network_image/cached_network_image.dart';
import 'package:cook_book/network/model/product_entity.dart';
import 'package:cook_book/network/repository.dart';
import 'package:cook_book/screens/detail/detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({Key key, this.entity}) : super(key: key);

  final ProductEntity entity;
  int bottomSelectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailCubit(repository: NetworkRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.entity.title ?? "Детали рецепта"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.bottomSelectedIndex,
          onTap: (value) {
            setState(() {
              widget.bottomSelectedIndex = value;
              widget.pageController.animateToPage(value, duration: Duration(milliseconds: 500), curve: Curves.ease);
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Инфо',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Ингридиенты',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Рецепт',
            ),
          ],
        ),
        body: Container(
          child: PageView(
            controller: widget.pageController,
            onPageChanged: (value) {
              setState(() {
                widget.bottomSelectedIndex = value;
              });
            },
            children: [
              _infoPage(),
              _ingridientsPage(),
              _recieptPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoPage() {
    return SingleChildScrollView(
      child: Container(
        // padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 16),
              child: Container(
                height: 200,
                child: Hero(
                  tag: "product_image_${widget.entity.id}",
                  child: CachedNetworkImage(
                    imageUrl: widget.entity.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        // color: Colors.green,
                        // borderRadius: BorderRadius.circular(8),
                        ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4),
                      child: Text(
                        widget.entity.tags,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      // borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4),
                      child: Text(
                        "Калорийность: ${widget.entity.total_calories} ккал.",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Описание",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                    ),
                  ),
                  Divider(),
                  Text(widget.entity.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ingridientsPage() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Ингридиенты",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  for (var ingridient in widget.entity.ingredients)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          Container(
                            // padding: EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    ingridient.ingredient,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Text(
                                  ingridient.amount,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8),
                            child: Divider(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recieptPage() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Рецепт",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
              ),
            ),
            Divider(),
            Container(
              child: Column(
                children: [
                  for (StepsEntity item in widget.entity.steps)
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              padding: EdgeInsets.all(8),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: item.image,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(item.description),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
