import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> users = [
    User(
      name: 'John Doe',
      phone: '+1 (555) 123-4567',
      imagePath: 'assets/images/john_doe.jpg',
    ),
    User(
      name: 'Jane Smith',
      phone: '+1 (555) 987-6543',
      imagePath: 'assets/images/jane_smith.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(user.imagePath),
            ),
            title: Text(user.name),
            subtitle: Text(user.phone),
            onTap: () {
              _editUser(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addUser();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editUser(int index) async {
    final editedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserPage(user: users[index]),
      ),
    );

    if (editedUser != null) {
      setState(() {
        users[index] = editedUser;
      });
    }
  }

  void _addUser() async {
    final newUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserPage(),
      ),
    );

    if (newUser != null) {
      setState(() {
        users.add(newUser);
      });
    }
  }
}

class User {
  final String name;
  final String phone;
  final String imagePath;

  User({
    required this.name,
    required this.phone,
    required this.imagePath,
  });
}

class EditUserPage extends StatefulWidget {
  final User? user;

  EditUserPage({this.user});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _phoneController.text = widget.user!.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user != null ? 'Edit User' : 'Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final editedUser = User(
                  name: _nameController.text,
                  phone: _phoneController.text,
                  imagePath: '',
                );

                Navigator.pop(context, editedUser);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
