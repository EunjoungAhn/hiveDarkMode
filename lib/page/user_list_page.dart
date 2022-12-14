import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/model/inputform.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  UserListPageState createState() => UserListPageState();
}

bool isDarkMode = false;

class UserListPageState extends State<UserListPage> {
TextEditingController nameController = TextEditingController();
TextEditingController ageController = TextEditingController();

late Box _darkMode;
late Box<InputForm> _inputFormBox;

@override
  void initState() {
    super.initState();
    _darkMode = Hive.box('darkModeBox');
    _inputFormBox = Hive.box<InputForm>('inputFormBox');
  }


// dispose 하는 이유는 컨트롤러 객체가 제거될 때 변수에 할당 된 메모리를 해제하기 위해서이다.
@override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          CupertinoSwitch(
                value: isDarkMode,
                onChanged: (val) {
                  isDarkMode = val;
                  _darkMode.put('darkMode', val);
                },
              ),
              const SizedBox(width: 10),
            ],
        ),
      body: Column(children: [
        Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                label: Text('name'),
              ),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('age'),
              ),
            ),
            ElevatedButton(onPressed: () {
              _inputFormBox.add(InputForm(
                name: nameController.text, 
                age: int.parse(ageController.text)
                ),
              );
            }, 
            child: const Text('add')),
          ],
        ),
        const Divider(),
        ValueListenableBuilder(
          valueListenable: Hive.box<InputForm>('inputFormBox').listenable(),
          builder: (context, Box<InputForm> inputFormBox, widget) {

          final users = inputFormBox.values.toList();


            return Expanded(
              child: users.isEmpty ? const Text('empty') :
              ListView.builder(
                //itemBuilder에서 목록을 보여줄때는 itemCount가 필요하다.
                itemCount: users.length,
                itemBuilder: (context, i) {
                return
                  ListTile(
                    title: Text(users[i].name),
                    subtitle: Text(users[i].age.toString()),
                    trailing: IconButton(onPressed: () {
                      final inputForm = users[i];
                      inputFormBox.delete(inputForm.key);
                    }, icon: const Icon(Icons.delete),),
                  );
              },),
            );
          }
        ),
      ]),
    );
  }
}