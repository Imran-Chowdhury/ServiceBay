import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';


class SignInScreen extends ConsumerStatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authControllerProvider.notifier).signIn(email, password);
        Navigator.pushNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) =>
                value!.isEmpty ? 'Email is required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                onChanged: (value) => password = value,
                obscureText: true,
                validator: (value) =>
                value!.isEmpty ? 'Password is required' : null,
              ),
              Row(
                children: [
                  Text("Don't have an account?"),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/signUp');
                    },
                    child: Text("SignUp"),),
                ],
              ),
              ElevatedButton(
                onPressed: signIn,
                child: Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
