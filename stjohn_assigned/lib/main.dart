import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: const MaterialApp(home: TrackerApp()));
  }
}

class MyAppState extends ChangeNotifier {
  int taskCount = 1;

  int completedTaskCount = 0;

  String taskDescription = "N/A";

  List<Map<String, dynamic>> tasksList = [
      {"name": "+",
      "desc": "N/A",
      "daysTo": -100,
      "Rank": 0,
      "Recurring": 0,
      "Completed": 0},

    {"name": "Bing",
      "desc": "This is a task",
      "daysTo": 5,
      "Rank": 1,
      "Recurring": 0,
      "Completed": 0},

    {"name": "Bang",
      "desc": "This is also a task",
      "daysTo": 6,
      "Rank": 2,
      "Recurring": 0,
      "Completed": 0},
    ];


  void newTask() {
    taskCount += 1;
    notifyListeners();
  }

  void deleteTask() {
    if (taskCount > 1) {
      taskCount -= 1;
      notifyListeners();
    }
  }

  void completeTask() {
    if (taskCount > 1) {
      taskCount -= 1;
      completedTaskCount += 1;
      notifyListeners();
    }
  }

  void uncompleteTask() {
    if (completedTaskCount > 0) {
      taskCount += 1;
      completedTaskCount -= 1;
      notifyListeners();
    }
  }

  updateTaskDescription() {
    notifyListeners();
  }
}

class TrackerApp extends StatelessWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;

    String date = '$day/$month/$year';

    return Scaffold(
        appBar: AppBar(title: Text('Date: $date')),
        body: Row(children: [
          Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 5,
              ),
              child: Image.asset('images/Line.png',
                  width: 450, height: 4.4, fit: BoxFit.fill),
            ),
            Row(
              children: [
                Text(appState.taskDescription),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    height: 90,
                    width: 90,
                    color: const Color.fromARGB(255, 255, 241, 241),
                    child: TextButton(
                      onPressed: () {},
                      child: const Center(child: Text("Edit Task")),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    height: 90,
                    width: 90,
                    color: const Color.fromARGB(255, 255, 241, 241),
                    child: TextButton(
                      onPressed: appState.completeTask,
                      child: const Center(child: Text("Complete Task")),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    appState.deleteTask();
                  },
                  icon: const Icon(Icons.delete),
                  iconSize: 50,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 5,
              ),
              child: Image.asset('images/Line.png',
                  width: 450, height: 4.4, fit: BoxFit.fill),
            ),
            SizedBox(
                width: 400,
                height: 250,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  children: appState.tasksList.map((taskInfo) {
                    final String? name = taskInfo['name'];

                    return Container(
                      height: 92.5,
                      width: 92.5,
                      color: const Color.fromARGB(255, 255, 241, 241),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            appState.updateTaskDescription();
                            },
                        child: Text(name!))),
                    );
                    }).toList(),
                    ),
        )]),

          const CompletedTasks(),
        ]));
  }
}

class CompletedTasks extends StatelessWidget {
  const CompletedTasks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return SizedBox(
        width: 100,
        height: 600,
        child: GridView.count(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          children: List.generate(appState.completedTaskCount, (i) {
            return Container(
              height: 92.5,
              width: 92.5,
              color: const Color.fromARGB(255, 255, 241, 241),
              child: Center(
                  child: TextButton(
                      onPressed: appState.uncompleteTask,
                      child: Text('Completed Task $i'))),
            );
          }),
        ));
  }
}
