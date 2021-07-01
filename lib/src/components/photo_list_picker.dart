import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoListPicker extends StatefulWidget {
  PhotoListPicker({Key? key}) : super(key: key);

  @override
  _PhotoListPickerState createState() => _PhotoListPickerState();
}

class _PhotoListPickerState extends State<PhotoListPicker> {
  var albums = <AssetPathEntity>[];
  var imageWidget = <Widget>[];
  var scrollController = ScrollController();
  int currentPage = 0;
  int lastPage = -1;
  @override
  void initState() {
    super.initState();
    _loadMyPhotos();
    _event();
  }

  void _event() {
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      if (currentScroll / maxScroll > 0.33 && currentPage != lastPage) {
        lastPage = currentPage;
        print("Load!!!!!");
        _pagingPhotos();
      }
    });
  }

  void _loadMyPhotos() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      albums = await PhotoManager.getAssetPathList(onlyAll: true);
      _pagingPhotos();
    } else {
      // fail
    }
  }

  _pagingPhotos() async {
    if (albums.isNotEmpty) {
      List<AssetEntity> photos =
          await albums.first.getAssetListPaged(currentPage, 60);
      setState(() {
        photos.forEach((element) {
          imageWidget.add(_photoWidget(element));
        });
        currentPage++;
      });
    }
  }

  Widget _photoWidget(AssetEntity asset) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbDataWithSize(200, 200),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      itemCount: imageWidget.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return imageWidget[index];
      },
    );
  }
}
