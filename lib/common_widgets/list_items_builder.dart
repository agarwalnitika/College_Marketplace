import 'package:flutter/material.dart';
import 'package:marketplace/common_widgets/empty_content.dart';


typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({Key key, this.snapshot, this.itemBuilder}) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;


  @override
  Widget build(BuildContext context) {
    if(snapshot.hasData) {
      final List<T> items = snapshot.data;
      if(items.isNotEmpty){
        return _buildList(items);
      }
      else {
        return EmptyContent();
      }
    }else if (snapshot.error){
      return EmptyContent(
        title:'Something went wrong' ,
        message: 'Can\'t load items right now',
      );
    }

      return Center(child: CircularProgressIndicator());

  }


  Widget _buildList(List<T> items){
    return ListView.builder(
      itemBuilder: (context , index) => itemBuilder(context,items[index]),
      itemCount: items.length,
    );
  }

}
