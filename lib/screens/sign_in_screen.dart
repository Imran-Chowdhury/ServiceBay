import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_bay/screens/sign_up_screen.dart';
import '../controllers/auth_controller.dart';
import '../utils/validator.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';


class SignInScreen extends ConsumerStatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  // String email = '';
  // String password = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authControllerProvider.notifier).signIn(emailController.text.trim(), passwordController.text.trim());
        // await ref.read(authControllerProvider.notifier).signIn(email, password);
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

    Size size = MediaQuery.sizeOf(context);
    double height = size.height;
    double width  = size.width;



    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      // appBar: AppBar(title: Text('Sign In')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height*.01,
              ),

              Image.asset(
                'assets/images/signin.png', // Your image path
                height: height * 0.5,
              ),

              SizedBox(height: height * 0.0001),
              const Text(
                'SIGN IN',
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
                      controller: emailController,
                      labelText: 'Email',
                      validate: Validator.emailValidator,
                    ),
                    SizedBox(height: height * 0.03),

                    CustomTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      validate: Validator.passwordValidator,
                    ),
                    SizedBox(height: height * 0.02),

                    Padding(
                      padding: EdgeInsets.only(left: width * 0.2, right: width * 0.2),
                      child: CustomButton(
                        screenHeight: height,
                        buttonName: 'Sign In',
                        // buttonColor: const Color(0xFFffc801),
                        buttonColor: const Color(0xFFed2f31),
                        icon: const Icon(
                          Icons.login_outlined,
                          color: Colors.white,
                        ),
                        onpressed: () {
                          signIn();

                        },


                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const  Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>SignUpScreen()));
                          },
                          child: const Text(
                            "Sign up!",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ],),

                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
