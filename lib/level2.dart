import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

// Сверстать скроллящийся список чатов. Данные берутся из локального файла bootcamp.json,
// аватарки пользователей находятся в папке avatars - все это находится в архиве bootcamp.zip
// или уже в готовом виде в шаблоне на гитхабе.
// Чат не отображается если поле lastMessage имеет значение null;
// поле date никогда не будет не null, если lastMessage является null;
// если поле userAvatar имеет значение null, то отображаем первую букву имени пользователя; 
// поле date имеет значение milliseconds since epoch;
// поле countUnreadMessages отображает количество непрочитанных сообщений (На этом этапе не требуется).
// Данные из bootcamp.json можно изменять и добавлять.
// Используемые виджеты: ListView.builder, ListTile, CircleAvatar, Text

class User {
  String userName;
  String? lastMessage;
  DateTime? date;
  String? userAvatar;
  int countUnreadMessages;

  User(this.userName, this.lastMessage, this.date, this.userAvatar, this.countUnreadMessages);

  factory User.fromJson(dynamic json) =>
  User(
      json['userName'],
      json['lastMessage'],
      json['date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['date']),
      json['userAvatar'],
      json['countUnreadMessages']
    );
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
      home: const MyHomePage(title: 'Effective Practice'),
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
  List<User> users = [];

  @override
  void initState()
  {
    super.initState();
    readJson();
    initializeDateFormatting();
  }

  Future<void> readJson() async
  {
    String data = await rootBundle.loadString("assets/bootcamp.json");
    List<dynamic> list = jsonDecode(data)['data'] as List<dynamic>;
    setState(() => users = list.map((user) => User.fromJson(user)).toList());
    setState(() => users.removeWhere((user) => user.date == null));
    setState(() => users.sort((a, b) => b.date!.compareTo(a.date!)));
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
            const Text("Effective")
          ],
        ),

        actions: const <Widget>[
          Icon(
            Icons.search
          )
        ],
      ),

      body: Center(

        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index)
          {
            return ListTile(
              leading: users[index].userAvatar != null ?
                CircleAvatar(
                  backgroundImage: AssetImage("avatars/${users[index].userAvatar}"),
                ) : 
                CircleAvatar(
                  child: Text(users[index].userName[0]),
                ),

              title: Text(users[index].userName),

              subtitle: Text("${users[index].lastMessage}"),

              trailing: Column(
                children: [
                  Expanded(
                    child: users[index].date!.difference(DateTime.now()).inDays > -1 ?
                           Text(DateFormat.Hm('ru').format(users[index].date!)) : 
                           users[index].date!.difference(DateTime.now()).inDays > -7 ?
                           Text(DateFormat.EEEE('ru').format(users[index].date!)) :
                           Text(DateFormat.MMMd('ru').format(users[index].date!))
                    ),
                  // Text("${users[index].countUnreadMessages}")
                ],
              ),

              shape: const Border(
                top: BorderSide(color: Color.fromARGB(255, 252, 197, 215)),
                bottom: BorderSide(color: Color.fromARGB(255, 252, 197, 215))
              ),
            );
          }
        )
      ),
    );
  }
}
