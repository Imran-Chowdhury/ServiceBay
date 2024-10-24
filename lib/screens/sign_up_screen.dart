import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';
import '../utils/validator.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';


class SignUpScreen extends ConsumerStatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  // String _name = '';
  // String _email = '';
  // String _password = '';
  // String _confirmPassword = '';
  String _role = 'admin'; // Default role
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


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

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      // if (_password != _confirmPassword) {
      if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Passwords do not match!'),
        ));
        return;
      }
      try {
        await ref.read(authControllerProvider.notifier).signUp(
          // name: _name,
          // email: _email,
          // password: _password,
          // role: _role,
          // context: context
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            role: _role,
            context: context
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

    Size size = MediaQuery.sizeOf(context);
    double height = size.height;
    double width  = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      // appBar: AppBar(
      //   // iconTheme: const IconThemeData(
      //   //   color: Colors.white,
      //   // ),
      //   backgroundColor: const Color(0xFFffffff),
      // // backgroundColor:  Color(0XFFd71e23),
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: EdgeInsets.only(top: width *0.1,left: width * .01),
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/signup2.png', // Your image path
                        height: height * 0.4,
                      ),
                    ),
                  ),


                  const Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Text(
                    'Welcome to Ichiban Auto Limited',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: nameController,
                          labelText: 'Name',
                          validate: Validator.personNameValidator,
                        ),
                        SizedBox(height: height * 0.03),

                        CustomTextField(
                          controller:emailController,
                          labelText: 'Email',
                          validate: Validator.emailValidator,
                        ),
                        SizedBox(height: height * 0.03),
                        CustomTextField(
                          controller: passwordController,
                          labelText: 'Password',
                          validate: Validator.passwordValidator,
                        ),
                        SizedBox(height: height * 0.03),

                        CustomTextField(
                          controller: confirmPasswordController,
                          labelText: 'Confirm Password',
                          validate: Validator.confirmPasswordValidator,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              activeColor:  const Color(0xFFed2f31),
                              value: _isAdmin,
                              onChanged: (_) => _toggleRole('admin'),
                            ),
                            const Text('Admin'),
                            Checkbox(
                              activeColor:  const Color(0xFFed2f31),
                              value: _isMechanic,
                              onChanged: (_) => _toggleRole('mechanic'),
                            ),
                            const Text('Mechanic'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.2, right: width * 0.2),
                    child: CustomButton(
                      screenHeight: height,
                      buttonName: 'Sign Up',
                      // buttonColor: const Color(0xFFffc801),
                      buttonColor: const Color(0XFFd71e23),
                      icon: const Icon(
                        // size: 20,
                        Icons.app_registration_sharp,
                        color: Colors.white,
                      ),
                      onpressed: () {
                        signUp();

                      },

                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
