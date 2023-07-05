import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:search_page/search_page.dart';

// Улучшаем внешний вид экрана.
// Для аватарок без картинки делаем градиент на заднем фоне:
// линейный, снизу вверх, цвет выбираем рандомно, градиент делаем от выбранного цвета внизу до белого вверху;
// добавляем индикатор непрочитанных сообщений (при условии, что поле countUnreadMessages > 0);
// реализовать экран поиска: поиск осуществляется по никнейму и последнему сообщению,
// результат выводится в виде списка чатов, подходящих условию.
// Дальше приложение можно улучшать и развивать по своему желанию или спрашивать совет у менторов буткемпа.

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 234, 151, 215)),
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

class TileConstruct extends StatelessWidget
{
  final User user;
  const TileConstruct(this.user, {super.key});

  @override
  Widget build(BuildContext context)
  {
    return ListTile(
              leading: user.userAvatar != null ?
                CircleAvatar(
                  backgroundImage: AssetImage("avatars/${user.userAvatar}"),
                ) : 
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                        Colors.white
                      ],
                      begin: const Alignment(0, 1),
                      end: const Alignment(0, -1)
                    )
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(user.userName[0]),
                  ),
                ),

              title: Text(user.userName),

              subtitle: Text("${user.lastMessage}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis),

              trailing: Column(
                children: [
                  Expanded(
                    child: user.date!.difference(DateTime.now()).inDays > -1 ?
                           Text(DateFormat.Hm('ru').format(user.date!)) : 
                           user.date!.difference(DateTime.now()).inDays > -7 ?
                           Text(DateFormat.EEEE('ru').format(user.date!)) :
                           Text(DateFormat.MMMd('ru').format(user.date!))
                    ),
                  user.countUnreadMessages > 0 ? 
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 252, 197, 215),
                      borderRadius: BorderRadius.all(Radius.circular(2))
                    ),
                    child: Text("${user.countUnreadMessages}")
                  ) :
                  const Spacer()
                ],
              ),

              shape: const Border(
                bottom: BorderSide(color: Color.fromARGB(255, 252, 197, 215))
              ),
              tileColor: const Color.fromARGB(255, 252, 239, 242)
            );
  }
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
            const Spacer(),
            const ImageIcon(AssetImage("assets/1.png")),
            const Spacer(),
            const Text("Effective-Practice"),
            const Spacer(),
            const ImageIcon(AssetImage("assets/1.png")),
            const Spacer(),
          ],
        ),

        actions: <Widget>[
          IconButton(onPressed: () => showSearch(
            context: context, 
              delegate: SearchPage(
              builder: (user) => TileConstruct(user),
              filter: (user) => [user.userName, user.lastMessage],
              items: users
            )
          ), icon: const Icon(Icons.search))
        ],
      ),

      body: Center(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => TileConstruct(users[index])
        )
      ),
    );
  }
}
