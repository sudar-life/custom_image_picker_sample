import 'package:flutter/material.dart';
import 'package:image_picker_sample/src/components/photo_list_picker.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("이미지 리스트"),
      ),
      body: PhotoListPicker(),
    );
  }
}
