import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

//Сверстать экран с аппбаром и одним элементом списка чатов.
//В аппбаре должно быть текстовое название, в начале аппбара должна быть иконка меню (три полоски), 
//в конце аппбара должна быть иконка поиска (лупа).
//На данном этапе элемент списка чатов может содержать захардкоженную информацию.
//Элемент должен иметь скругленный аватар, имя пользователя, последнее сообщение
//(под именем пользователя, максимум одна строка, overflow - ellipsis),
//дату сообщения (если дата последнего сообщения на этой неделе, то выводим короткое название дня,
//если дата сообщения сегодня, то выводим только время, иначе выводим в формате 1 фев).
//Используемые виджеты: Scaffold, AppBar, Text, Icon, ListTile, CircleAvatar

class User 
{
  String userName;
  String lastMessage;
  int dateInMills; 
  String userAvatar;
  int countUnreadMessages;
  late DateTime date = DateTime.fromMillisecondsSinceEpoch(dateInMills);

  User(this.userName, this.lastMessage, this.dateInMills, this.userAvatar, this.countUnreadMessages);
}

void main() 
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  User user1 = User("Роман", "Привет, ты подготовился к буткемпу?", 1675169940000, "1.jpg", 1);

  @override
  void initState()
  {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(

      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Row(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            const Text('Effective')
          ],
        ),

        actions: const <Widget>[
          Icon(
            Icons.search
          )
        ],
      ),

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            ListTile(

              leading: CircleAvatar(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('avatars/${user1.userAvatar}'),
                    )
                  ),
                )
              ),

              title: Text(user1.userName),

              subtitle: Text(user1.lastMessage,
                overflow: TextOverflow.ellipsis
              ),

              trailing: Column(
                children: [
                  Expanded(child: Text(DateFormat.MMMd('ru').format(user1.date))),
                  // Text("${user1.countUnreadMessages}")
                 const Spacer()
                ],
              ),

              shape: const Border(
                top: BorderSide(color: Color.fromARGB(255, 252, 197, 215)),
                bottom: BorderSide(color: Color.fromARGB(255, 252, 197, 215))
              ),
            )
          ],
        ),
      ),
    );
  }
}
