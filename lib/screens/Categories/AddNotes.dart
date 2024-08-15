import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Categories/EditTaskScreen.dart';
import 'package:flutter_application_1/screens/add%20todolist/Addtodolist.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  String _selectedStatus = 'Select Status';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('MMMM d, yyyy hh:mm a');
    final formattedDate = formatter.format(now);

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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Row(
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
                  IconButton(
                    onPressed: () async {
                      final updatedNote = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskScreen(
                            note: Note(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              status: _selectedStatus,
                              date: formattedDate,
                            ),
                          ),
                        ),
                      );

                      if (updatedNote != null) {
                        setState(() {
                          _titleController.text = updatedNote.title;
                          _descriptionController.text = updatedNote.description;
                          _selectedStatus = updatedNote.status;
                        });
                      }
                    },
                    icon: Icon(Icons.edit, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 24),
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
              SizedBox(height: 16),
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
                  hintText: 'Note something down',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              Spacer(),
              DropdownButton<String>(
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
                    child: Text(
                      value,
                      style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue ?? _selectedStatus;
                  });
                },
                style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                dropdownColor: Colors.white,
                iconEnabledColor: Colors.grey[900],
                underline: SizedBox(),
                isExpanded: true,
              ),
              SizedBox(height: 10),
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
                        date: formattedDate,
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
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                ),
                child: Text(
                  'Save',
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
              SizedBox(height: 9),
            ],
          ),
        ),
      ),
      bottomNavigationBar:  Container(
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
     child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomAppBar(
          color: Color(0xFFA7D1F3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.photo, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.check_box, color: Colors.black),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TodoListScreen()));
                },
              ),
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class Note {
  final String title;
  final String description;
  final String status;
  final String date;

  Note({
    required this.title,
    required this.description,
    required this.status,
    required this.date,
  });

  @override
  String toString() {
    return '$title|$description|$status|$date';
  }

  factory Note.fromString(String noteString) {
    final parts = noteString.split('|');
    return Note(
      title: parts[0],
      description: parts[1],
      status: parts[2],
      date: parts[3],
    );
  }
}
