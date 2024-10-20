import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';


class SignUpScreen extends ConsumerStatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _role = 'admin'; // Default role

  bool _isAdmin = true;
  bool _isMechanic = false;

  void _toggleRole(String role) {
    setState(() {
      if (role == 'admin') {
        _isAdmin = true;
        _isMechanic = false;
        _role = 'admin';
      } else {
        _isAdmin = false;
        _isMechanic = true;
        _role = 'mechanic';
      }
    });
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Passwords do not match!'),
        ));
        return;
      }
      try {
        await ref.read(authControllerProvider.notifier).signUp(
          name: _name,
          email: _email,
          password: _password,
          role: _role,
        );
        // Navigator.pushNamed(context, '/signIn');
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
      appBar: AppBar(title: Text('Sign Up')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => _name = value,
                validator: (value) =>
                value!.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => _email = value,
                validator: (value) =>
                value!.isEmpty ? 'Email is required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                onChanged: (value) => _password = value,
                obscureText: true,
                validator: (value) =>
                value!.length < 6 ? 'Password too short' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                onChanged: (value) => _confirmPassword = value,
                obscureText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isAdmin,
                    onChanged: (_) => _toggleRole('admin'),
                  ),
                  Text('Admin'),
                  Checkbox(
                    value: _isMechanic,
                    onChanged: (_) => _toggleRole('mechanic'),
                  ),
                  Text('Mechanic'),
                ],
              ),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
