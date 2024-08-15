import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Categories/AddNotes.dart';
import 'package:flutter_application_1/screens/Categories/EditTaskScreen.dart';
import 'package:flutter_application_1/screens/add%20todolist/Addtodolist.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  final String username;

  const HomeView({super.key, required this.username});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String extractFirstName(String email) {
    final parts = email.split('@')[0].split('.');
    return parts.isNotEmpty ? parts[0] : '';
  }

  List<Note> notes = [];
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final noteStrings = prefs.getStringList('notes') ?? [];
      final todoStrings = prefs.getStringList('todos') ?? [];

      final List<Note> loadedNotes = noteStrings
          .map((noteString) {
            try {
              return Note.fromString(noteString);
            } catch (e) {
              print('Error parsing note: $e');
              return null;
            }
          })
          .whereType<Note>()
          .toList();

      final List<Todo> loadedTodos = todoStrings
          .map((todoString) {
            try {
              return Todo.fromString(todoString);
            } catch (e) {
              print('Error parsing todo: $e');
              return null;
            }
          })
          .whereType<Todo>()
          .toList();

      setState(() {
        notes = loadedNotes;
        todos = loadedTodos;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final noteStrings = notes.map((note) => note.toString()).toList();
    final todoStrings = todos.map((todo) => todo.toString()).toList();

    await prefs.setStringList('notes', noteStrings);
    await prefs.setStringList('todos', todoStrings);
  }

  void _addNote() async {
    final newNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNotes()),
    );

    if (newNote is Note) {
      setState(() {
        notes.add(newNote);
      });
      _saveData();
    }
  }

  void _addTodo() async {
    final newTodo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoListScreen()),
    );

    if (newTodo is Todo) {
      setState(() {
        todos.add(newTodo);
      });
      _saveData();
    }
  }

  Future<void> _deleteItem(int index, bool isNote) async {
    final itemType = isNote ? 'Note' : 'Todo';
    final itemTitle = isNote ? notes[index].title : todos[index].title;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this $itemType titled "$itemTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() {
        if (isNote) {
          notes.removeAt(index);
        } else {
          todos.removeAt(index);
        }
        _saveData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String username = widget.username;
    final firstName = extractFirstName(username);

    final combinedItems = [
      ...notes.map((note) => {'type': 'note', 'item': note}),
      ...todos.map((todo) => {'type': 'todo', 'item': todo}),
    ];

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB3CDE0), Color(0xFF9EBDF1), Color(0xFF2A4D6F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Welcome $firstName',
                    style: GoogleFonts.bonaNova(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildSearchField(),
              SizedBox(height: 20),
              Expanded(
                child: combinedItems.isEmpty
                    ? _buildEmptyState()
                    : _buildGrid(combinedItems),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.note_add),
                    title: Text('Add Note'),
                    onTap: () {
                      Navigator.pop(context);
                      _addNote();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.check_box),
                    title: Text('Add Todo'),
                    onTap: () {
                      Navigator.pop(context);
                      _addTodo();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.blueGrey,
        elevation: 6,
        tooltip: 'Add Note or Todo',
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.black54),
            hintText: 'Search Notes & Todos',
            hintStyle: TextStyle(color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
          ),
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/Todo.png', width: 300, height: 300),
          SizedBox(height: 10),
          Text(
            'No Notes & Todos available',
            textAlign: TextAlign.center,
            style: GoogleFonts.bonaNova(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> combinedItems) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: combinedItems.length,
      itemBuilder: (context, index) {
        final item = combinedItems[index];
        final isNote = item['type'] == 'note';
        final note = isNote ? item['item'] as Note : null;
        final todo = !isNote ? item['item'] as Todo : null;

        return GestureDetector(
          onTap: () {
            if (isNote) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditTaskScreen(note: note!)),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodoListScreen()),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    isNote ? note!.title : todo!.title,
                    style: GoogleFonts.ubuntu(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: Text(
                    isNote
                        ? note!.description
                        : todo!.isDone ? 'Completed' : 'Incomplete',
                    style: GoogleFonts.ubuntu(
                      fontSize: 19,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(index, isNote),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
