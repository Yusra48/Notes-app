import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; 

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _todoController = TextEditingController();
  final List<Todo> _todos = []; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body:  SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFB3CDE0),
                Color(0xFF9EBDF1),
                Color(0xFF2A4D6F),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              _buildHeader(),
              SizedBox(height: 24),
              _buildTitleField(),
              SizedBox(height: 16),
              _buildTodoInputField(),
              Expanded(child: _buildTodoList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final formatter = DateFormat('MMMM d, yyyy hh:mm a');
    final formattedDate = formatter.format(now);
    
    return Row(
      children: [
        Text(
          formattedDate,
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              Navigator.pop(
                context,
                Todo(
                  title: _titleController.text,
                  isDone: false, 
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Title cannot be empty')),
              );
            }
          },
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      style: GoogleFonts.ubuntu(
        textStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.grey[900],
        ),
      ),
      decoration: InputDecoration(
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.grey[600]),
        border: InputBorder.none,
      ),
      maxLines: 1,
    );
  }

  Widget _buildTodoInputField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _todoController,
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              decoration: InputDecoration(
                hintText: 'Add a new to-do',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) => _addTodo(),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (_todoController.text.isNotEmpty) {
                _addTodo();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return CheckboxListTile(
          title: Text(
            todo.title,
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          value: todo.isDone,
          onChanged: (bool? value) {
            setState(() {
              todo.isDone = value ?? false;
            });
          },
        );
      },
    );
  }

  void _addTodo() {
    final newTodo = _todoController.text;
    if (newTodo.isNotEmpty) {
      setState(() {
        _todos.add(Todo(
          title: newTodo,
          isDone: false,
        ));
        _todoController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('To-do cannot be empty')),
      );
    }
  }
}

class Todo {
  String title;
  bool isDone;

  Todo({
    required this.title,
    this.isDone = false,
  });

  static fromString(String todoString) {}
}
