import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_sample/src/model/asset_entity_value.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoListPicker extends StatefulWidget {
  PhotoListPicker({Key? key}) : super(key: key);

  @override
  _PhotoListPickerState createState() => _PhotoListPickerState();
}

class _PhotoListPickerState extends State<PhotoListPicker> {
  var albums = <AssetPathEntity>[];
  var imageList = <AssetEntityValue>[];
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
          imageList.add(AssetEntityValue(asset: element));
        });
        currentPage++;
      });
    }
  }

  Widget _photoWidget(AssetEntityValue asset) {
    return FutureBuilder<Uint8List>(
      future: asset.loadImageFile(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              setState(() {
                asset.isSelected = !asset.isSelected;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: asset.isSelected ? 10 : 0, color: Colors.blue),
              ),
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      itemCount: imageList.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (BuildContext context, int index) {
        return _photoWidget(imageList[index]);
      },
    );
  }
}
