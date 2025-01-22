import 'package:assignmentapp/database/database_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  Map<String, dynamic>? user;

  // Logout function
  Future<void> logout(BuildContext context) async {
    try {
      // Clear user data from SQLite
      await DatabaseHelper.instance.deleteUserData();

      // Update the state
      setState(() {
        _isLoggedIn = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out')),
      );
    }
  }

  Future<void> auth(BuildContext context) async {
    try {
      final user = await DatabaseHelper.instance.getUser();
      if (user != null) {
        setState(() {
          _isLoggedIn = true;
        });
      }
      setState(() {
        this.user = user;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error getting user data')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[100],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 250,
                  ),
                  const SizedBox(height: 40),
                  const Text('Welcome!',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else if (_isLoggedIn)
                    Column(
                      children: [
                        Text('User Code: ${user?['userCode']}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20),
                        Text('Display Name: ${user?['userDisplayName']}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20),
                        Text('Email: ${user?['email']}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20),
                        Text('Employee Code: ${user?['userEmployeeCode']}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Logout'),
                                content: const Text('Are you sure you want to logout?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Dismiss the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop(); // Dismiss the dialog
                                      await logout(context); // Call the logout function
                                    },
                                    child: const Text('Logout'),
                                  ),
                                ],
                              );
                            },
                          );
                          },
                          style: ElevatedButton.styleFrom(
                             shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor:
                                Colors.red, // Updated to modern syntax
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),),
                          backgroundColor:
                              Colors.blue, // Updated from deprecated property
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                              
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ]),
                ],
              ),
            ),
          ),
          const Text('Made by Thathsara Dinuwan',
              style: TextStyle(color: Colors.black, fontSize: 18)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
