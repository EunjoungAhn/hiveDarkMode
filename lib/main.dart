import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/model/inputform.dart';
import 'package:image_picker/page/user_list_page.dart';

void main() async {
  await _initHive();
  
  runApp(const MyApp());
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(InputFormAdapter());
  //앱이 실행될때 box(테이블)에 저장되어 있는 값을 가져오기 위해 등록
  await Hive.openBox('darkModeBox');
  await Hive.openBox<InputForm>('inputFormBox');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  return ValueListenableBuilder(
    //다크모드 박스가 변경될때 마다
    valueListenable: Hive.box('darkModeBox').listenable(),
    //listen해서 builder가 다시 그릴 수 있게끔
    builder: (context, Box box, widget) {//box를 오브젝트로 인식하게해서 .get을 넣을 수 있도록 수정
      final darkMode = box.get('darkMode', defaultValue: false);

        return MaterialApp(
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(),
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const UserListPage(),
        );
      }
    );
  }
}
