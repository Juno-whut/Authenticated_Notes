import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'forgotpasswordpage.dart';



class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState(); 
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

 

  // sign user in 
  Future signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return showDialog(
        context: context,
        builder: (content) {
          return const AlertDialog(
            content: Text(
              "Please enter your email and password",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.red
              ),
            ),
          );
        }
      );
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim(),
      );
    } catch (e) {
      return showDialog(
        context: context,
        builder: (content) {
          return AlertDialog(
            content: Text(
              e.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.red
              ),
            ),
          );
        }
      );
    }
  }

  // dispose text controllers
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],

        body:  SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      // welcom message
                      const SizedBox(height: 50),
                      const Text(
                        "Hello Again",
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "You've been missed!", 
                        style: TextStyle(
                          fontSize: 20,
                        )
                      ),
              
                      const SizedBox(height: 20),
                      // email text field
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextField(
                                  controller: _emailController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Email',
                                    )
                                ),
                              ),
                          ),
                      ),
              
                      const SizedBox(height: 25),
                      // password text field
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Password',
                                    )
                                ),
                              ),
                          )
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, 
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPasswordPage();
                                  }),
                                );
                              },
                              child: const Text(
                                "Forgot Password",
                                style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
                      // Sign in button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: signIn,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                      ),

                      const SizedBox(height: 15),
                      // not a member? register now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              "Not a member?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                          GestureDetector(
                            onTap: widget.showRegisterPage,
                            child: const Text(
                              "Register Now",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          )
                        ],
                      )
                  ],
              ),
            )
        )
    );
  }
}