import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class AssetEntityValue extends AssetEntity {
  late bool isSelected;
  Uint8List? unit8List = Uint8List(0);
  AssetEntityValue({
    asset,
    this.isSelected = false,
  }) : super(
          id: asset.id,
          typeInt: asset.typeInt,
          width: asset.width,
          height: asset.height,
          duration: asset.duration,
          orientation: asset.orientation,
          isFavorite: asset.isFavorite,
          title: asset.title,
          createDtSecond: asset.createDtSecond,
          modifiedDateSecond: asset.modifiedDateSecond,
          relativePath: asset.relativePath,
          latitude: asset.latitude,
          longitude: asset.latitude,
        );

  Future<Uint8List> loadImageFile() async {
    if (unit8List!.isNotEmpty) {
      return Future.value(unit8List);
    }
    unit8List = await this.thumbDataWithSize(200, 200);
    return Future.value(unit8List);
  }
}
