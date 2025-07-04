import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/chat/auth/register.dart';
import '../Component/AwesomeDialog.dart';
import '../Component/Button.dart';
import '../Component/logo.dart';
import '../Component/text.dart';
import '../Component/textForm.dart';
import '../ChatsScreen/ChatScreen.dart';
class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login> {
  var formstate = GlobalKey<FormState>();
  var password = TextEditingController();
  var email = TextEditingController();
  bool ispassword = true;
  bool isLoading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null){
      return;  // if it is null ?? stop function (every thing after returning)
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Get.offAll(()=> ChatPage());
  }
  @override
  Widget build(BuildContext context) {
    // ModalProgressHUD= widget for Loading
    return  ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.blue,
        ),
        body:
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const customLogo(),
                  const customText(title: 'Login ', fontSize: 25,),
                  const Text( 'login to continue using app ',
                    style:TextStyle(
                        color: Colors.grey
                    ) ,
                  ),
                  const SizedBox(height: 18,),
                  const customText(title: 'Email', fontSize: 20,),
                  customTextForm(
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: 'please Entre your email ',
                    hintText: 'Entre your email',
                    myController: email,
                  ),
                  const customText(title: 'Password', fontSize: 18,),
                  TextFormField(
                    controller: password,
                    validator: (value){
                      if (value!.isEmpty){
                        return 'please entre your password ';
                      }
                      return null;
                    },
                    // to login with enter
                    onFieldSubmitted: ( value)async
                    {
                      // if fields is not empty ?
                      // لو حابب تخلي المستخدم يقدر يضغط Enter في أي مكان بدون ما يحصل كراش، لازم تتأكد إن formstate مش null:

                      if (formstate.currentState != null && formstate.currentState!.validate()){
                        try {
                          final data = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email.text.trim(),
                              password: password.text.trim()
                          );
                          // if his email  was Verified ? going to =>HomePage());
                          if (data.user!.emailVerified){
                            Get.offAll(()=>ChatPage());
                          }
                          else{
                            customDialog(context,'warning','Check your email and return login',DialogType.warning,);
                          }
                        } on FirebaseAuthException catch (e) {

                          if (e.code == 'user-not-found') {
                            customDialog(context,'error','No user found for that email',DialogType.error,);
                          } else if (e.code == 'wrong-password') {
                            customDialog(context,'error','Wrong password',DialogType.error,);
                          }
                        }
                      }else{
                        customDialog(context,'error','please entre your email and password',DialogType.error,);

                      }
                    },
                    obscureText: ispassword,
                    maxLength: 25,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          ispassword = !ispassword;
                        });
                      },
                        icon: ispassword== true ? const Icon(Icons.remove_red_eye): const Icon(Icons.visibility_off)  ,
                      ),                      // when u press
                      focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 3,
                        ),
                      ),
                      hintText: 'Entre your password',
                      hintStyle: const TextStyle(fontSize: 14),
                      helperStyle: const TextStyle(color: Colors.grey,fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      border:
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabled: true,
                      enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child:
                    TextButton(onPressed: () async {
                      if(email.text == ''){
                        customDialog(context,'error','please entre your email',DialogType.error,);
                        return;
                      }
                      try{
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                        customDialog(context,'warning','Check your email to reset your password',DialogType.success,);
                      }catch(e){
                        customDialog(context,'error','this email is unavailable,please Register',DialogType.error,);
                      }
                    },
                        child: const Text(' Forget Password ? ',
                          style:TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                          ) ,)
                    ),
                  ),
                  customButton(
                    onPressed: ()async{
                      // if fields is not empty ?
                      if (formstate.currentState!.validate()){
                        setState(() {
                          isLoading = true;

                        });
                        try {
                          final data = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email.text, // u should put .text
                              password: password.text
                          );
                          // if his email  was Verified ? going to =>HomePage());
                          if (data.user!.emailVerified){
                            Get.offAll(()=>ChatPage());
                          }
                          else{
                            customDialog(context,'warning','Check your email ro Verify',DialogType.warning,);
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            customDialog(context,'error','No user found for that email',DialogType.error,);
                          } else if (e.code == 'wrong-password') {
                            customDialog(context,'error','Wrong password',DialogType.error,);
                          }
                        }
                      }else{
                        customDialog(context,'error','please entre your email and password',DialogType.error,);
                      }
                      setState(() {
                        isLoading = false;

                      });
                    },
                    color: Colors.blue
                    , text: 'Login',
                  ),
                  const SizedBox(height: 20,),
                  customButton(
                    onPressed: (){
                      signInWithGoogle();
                    },
                    color: Colors.red
                    , text: 'Login with Google',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const customText(
                        title: 'Dont have an account ?',
                        fontSize: 14,
                      ),
                      TextButton(onPressed: (){
                        Get.offAll(()=>const Register());
                      },
                          child: const Text('Register',style: TextStyle(color: Colors.blue),))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}