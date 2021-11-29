import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../db/notes_database.dart';
import '../widgets/note_card_widget.dart';
import './note_detail_page.dart';
import '../model/note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<Note> notes = [];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
        actions: const [Icon(Icons.search), SizedBox(width: 12)],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const NoteDetailPage(gnote: Note.c())));
        },
      ),
      body: Center(
          child: LiquidPullToRefresh(
        onRefresh: refreshNotes,
        animSpeedFactor: 2,
        showChildOpacityTransition: false,
        color: Colors.orange,
        child: StreamBuilder(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
              if (snapshot.hasData &&
                  snapshot != null &&
                  snapshot.data != ConnectivityResult.none) {
                return isLoading
                    ? buildEffects()
                    : notes.isEmpty
                        ? Text('No Notes ${notes.length}')
                        : buildNotes();
              } else {
                return const Icon(
                  Icons.wifi_off,
                  //color: Colors.orange,
                  size: 50,
                );
              }
            }),
      )),
    );
  }

  Widget buildEffects() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: 10,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (BuildContext context, int index) {
          double height = 150.0 + Random().nextInt(200 - 150);
          return Shimmer.fromColors(
            baseColor: Colors.black12,
            highlightColor: Colors.black26,
            child: Card(
              child: Container(
                height: height,
                width: 150,
                padding: const EdgeInsets.all(10),
              ),
            ),
          );
        },
      );
  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (BuildContext context, int index) {
          final notee = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(gnote: notee),
              ));

              refreshNotes();
            },
            onLongPress: () async {
              //print('select item ${index}');
              //todo deleteMeny+sort periority+add colors and options to editpage+test connection+developper account
            },
            child: NoteCardWidget(note: notee, index: index),
          );
        },
      );
  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase().readAllNotes();
    notes.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
