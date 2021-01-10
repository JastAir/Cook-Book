import 'package:cached_network_image/cached_network_image.dart';
import 'package:cook_book/common/widgets/loading_container_view.dart';
import 'package:cook_book/network/model/product_entity.dart';
import 'package:cook_book/screens/dashboard/dashboard_cubit.dart';
import 'package:cook_book/screens/dashboard/dashboard_state.dart';
import 'package:cook_book/screens/detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DashboardRecommendedItemView extends StatelessWidget {
  const DashboardRecommendedItemView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) => current is DashboardState_OnLoadFavorites,
      builder: (context, state) {
        if (state is DashboardState_OnLoadFavorites) {
          return _list(state.products);
        }
        return Container(
          height: 180,
          child: LoadingContainerView(),
        );
      },
    );
  }

  Widget _list(List<ProductEntity> items) {
    List<Widget> widgets = [];
    items.forEach((element) {
      widgets.add(_listTile(item: element));
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widgets,
      ),
    );
  }

  Widget _listTile({ProductEntity item}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Container(
            height: 180,
            width: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Text Block
                SizedBox.expand(
                  child: Container(
                    margin: EdgeInsets.only(top: 42),
                    padding: EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white30,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 56),
                      child: Column(
                        children: [
                          Text(
                            item.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              item.tags,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Image
                Container(
                  transform: Matrix4.translationValues(0, -48, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Hero(
                        tag: "product_image_${item.id}",
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: item.image,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
      onTap: () {
        Get.to(DetailScreen(entity: item));
      },
    );
  }
}
