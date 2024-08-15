import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Categories/AddNotes.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTaskScreen extends StatefulWidget {
  final Note note;

  const EditTaskScreen({super.key, required this.note});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController =
        TextEditingController(text: widget.note.description);
    _selectedStatus = widget.note.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Edit Note',
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
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
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _descriptionController,
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[100]!,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedStatus,
                    items: <String>[
                      'Select Status',
                      'Important',
                      'Top Priority',
                      'Completed',
                      'Should Be Done This Week',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue!;
                      });
                    },
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),
                SizedBox(height: 60),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.isNotEmpty) {
                        Navigator.pop(
                          context,
                          Note(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            status: _selectedStatus,
                            date: widget.note.date,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Title cannot be empty')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.bonaNova(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
