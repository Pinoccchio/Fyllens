import 'package:flutter/material.dart';
import 'package:fyllens/presentation/shared/widgets/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),

              // logo
              Icon(
                  Icons.energy_savings_leaf,
                  size: 100,
                color: Colors.green[700],
              ),

              const SizedBox(height: 50),

              // App Name
              Text(
                'FYLLENS',
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 20,
                ),
              ),

              const SizedBox(height: 25),

              // forgot password
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // username textfield
                    CustomTextfield(
                      controller: usernameController,
                      obscureText: false,
                      hintText: "Username",
                    ),

                    const SizedBox(height: 15),

                    // password textfield
                    CustomTextfield(
                      controller: passwordController,
                      obscureText: true,
                      hintText: "Password",
                    ),

                    const SizedBox(height: 10),

                    // Forgot password or signup link
                    Row(
                      children: [
                        const SizedBox(width: 260),

                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // sign in button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 160),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                color: Colors.white, // 👈 border color
                                width: 1,            // 👈 border thickness
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // not a member? register now
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Don\'t have an account? Register now!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 70)

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
