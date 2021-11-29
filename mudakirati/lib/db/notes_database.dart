import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/note.dart';

class NotesDatabase {
  Future<List<Note>> getData() async {
    var response =
        await http.get(Uri.https('mudakirati.herokuapp.com', 'todo'));
    var jsonData = jsonDecode(response.body)["data"];
    List<Note> dataList = [];
    for (var u in jsonData) {
      Note data = Note(
          id: u["_id"],
          title: u["title"],
          content: u["content"],
          createdAt: u["createdAt"],
          updatedAt: u["updatedAt"],
          completed: u["completed"]);
      dataList.add(data);
    }
    return dataList;
  }

  Future create(String title, String content) async {
    await http.post(
      Uri.parse('https://mudakirati.herokuapp.com/todo/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'content': content,
      }),
    );
  }

  Future<List<Note>> readAllNotes() async {
    return await getData();
  }

  Future update(Note note, String title, String content) async {
    await http.put(
      Uri.parse('https://mudakirati.herokuapp.com/todo/${note.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'content': content,
      }),
    );
  }

  Future delete(dynamic id) async {
    await http.delete(Uri.parse('https://mudakirati.herokuapp.com/todo/$id'));
  }
}
