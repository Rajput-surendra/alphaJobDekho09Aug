import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:job_dekho_app/Services/api_path.dart';
import 'package:job_dekho_app/Utils/CustomWidgets/TextFields/authTextField.dart';
import 'package:job_dekho_app/Utils/CustomWidgets/customTextButton.dart';
import 'package:job_dekho_app/Utils/CustomWidgets/jobseeker_Tab.dart';
import 'package:job_dekho_app/Utils/CustomWidgets/recruiter_Tab.dart';
import 'package:job_dekho_app/Views/accountcreated_Screen.dart';
import 'package:job_dekho_app/Views/signin_Screen.dart';
import '../Utils/style.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  /// seeker controllers
  TextEditingController jemailController = TextEditingController();
  TextEditingController jmobileController = TextEditingController();
  TextEditingController jpasswordController = TextEditingController();
  TextEditingController jcpasswordController = TextEditingController();
  TextEditingController jfirstNameController = TextEditingController();
  TextEditingController jlastNameController = TextEditingController();

  /// recruiter section

  TextEditingController remailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();

  bool showPassword = false;
  bool isLoading = false;


  seekerSignUp()async{
    var headers = {
      'Cookie': 'ci_session=b2a1ec2780ae767ff59e374f863d83e3a991de16'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}signUp'));
    request.fields.addAll({
      'type': ' seeker',
      'email': jemailController.text,
      'surname':jlastNameController.text,
      'name': jfirstNameController.text,
      'mno':  jmobileController.text,
      'ps': jpasswordController.text
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      print("final response here ${jsonResponse}");
      if (jsonResponse['staus'] == "true" || jsonResponse['staus'] ==  true){
        Fluttertoast.showToast(msg: "Registered Successfully");
        setState(() {});
        Navigator.push(context, MaterialPageRoute(builder: (context) => AccountCreatedScreen()));
      }
      else {
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        print(response.reasonPhrase);
      }
    }
  }

  recruiterSignUp()async{
    var headers = {
      'Cookie': 'ci_session=ec94f0bdb488239dc4b0f8c114420748ca7c936d'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}signUp'));
    request.fields.addAll({
      'type': 'recruiter',
      'email': remailController.text,
      'name': fullNameController.text,
      'company': companyNameController.text,
      'mno': mobileController.text,
      'ps':  passwordController.text
    });
    print("paramters here ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print("final response here ${jsonResponse}");
      if (jsonResponse['staus'] == "true" || jsonResponse['staus'] ==  true){
        Fluttertoast.showToast(msg: "Registered Successfully");
        setState(() {});
        Navigator.push(context, MaterialPageRoute(builder: (context) => AccountCreatedScreen()));
      }
      else {
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        print(response.reasonPhrase);
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: primaryColor,
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 30),
                  height: 90,
                  // height: size.height / 5.5 ,
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: Image.asset(
                    'assets/jobdekho_logo.png',
                    scale: 1.0,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(14),
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(70))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TabBar(
                          labelColor: primaryColor,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          unselectedLabelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          indicator: UnderlineTabIndicator(
                              borderSide:
                                  BorderSide(width: 4.5, color: primaryColor)),
                          indicatorColor: primaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Tab(
                              text: "Job Seeker",
                            ),
                            Tab(
                              text: "Recruiter",
                            ),
                          ]),
                      SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 1.65,
                        child: TabBarView(children: [
                          // JobSeekerTab(),
                          /// seeker section
                          Container(
                            child: Form(
                              key: _formkey,
                              child: ListView(
                                children: [
                                  AuthTextField(
                                    // validatior: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return "Enter Some Text";
                                    //     print("Email");
                                    //   }
                                    //   return null;
                                    // },
                                    validatior: (val) => val!.isEmpty || !val.contains("@")
                                        ? "Enter a valid email"
                                        : null,
                                    obsecureText: false,
                                    iconImage: Image.asset(
                                      'assets/AuthAssets/Icon material-email.png',
                                      scale: 1.3,
                                      color: primaryColor,
                                    ),
                                    hintText: "Email",
                                    keyboardtype: TextInputType.emailAddress,
                                    controller: jemailController,
                                  ),
                                  AuthTextField(
                                    validatior: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter a First Name';
                                      }
                                      return null;
                                    },
                                    // validatior: (value) {
                                    //   if (value == null || value.isEmpty) {
                                    //     return 'Enter above Detail';
                                    //   }
                                    // },
                                    obsecureText: false,
                                    iconImage: Image.asset(
                                      'assets/AuthAssets/Icon awesome-user.png',
                                      scale: 1.3,
                                      color: primaryColor,
                                    ),
                                    hintText: "First Name",
                                    controller: jfirstNameController,
                                  ),
                                  AuthTextField(
                                    validatior: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter a Last Name';
                                      }
                                      return null;
                                    },
                                    // validatior: (value) {
                                    //   if (value == null || value.isEmpty) {
                                    //     return 'Enter above Detail';
                                    //   }
                                    // },
                                    obsecureText: false,
                                    iconImage: Image.asset(
                                      'assets/AuthAssets/Icon awesome-user.png',
                                      scale: 1.3,
                                      color: primaryColor,
                                    ),
                                    hintText: "Last Name",
                                    controller: jlastNameController,
                                  ),
                                  AuthTextField(

                                    validatior: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a mobile number.';
                                      }
                                      // Use your mobile number validation regex here
                                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                        return 'Please Enter a Valid 10-digit mobile';
                                      }
                                      return null;
                                    },

                                    obsecureText: false,
                                    iconImage: Image.asset(
                                      'assets/AuthAssets/Icon ionic-ios-call.png',
                                      scale: 1.3,
                                      color: primaryColor,
                                    ),
                                    hintText: "Mobile No.",
                                    keyboardtype: TextInputType.number,
                                    length: 10,
                                    controller: jmobileController,
                                  ),
                                  AuthTextField(
                                    suffixIcons: InkWell(
                                        onTap: (){
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                        child: Icon(showPassword == true ? Icons.visibility : Icons.visibility_off,color: primaryColor,)),
                                    obsecureText:showPassword == true ? false : true,
                                    controller: jpasswordController,
                                    iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-lock.png', scale: 1.3, color: primaryColor,),
                                    hintText: 'Password',
                                    validatior: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter a password.';
                                      }
                                      if (value.length < 8) {
                                        return 'Password must be at least 8 characters long.';
                                      }
                                      if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$').hasMatch(value)) {
                                        return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character.';
                                      }
                                      return null;
                                    },

                                  ),

                                  // AuthTextField(
                                  //   suffixIcons: InkWell(
                                  //       onTap: (){
                                  //         setState(() {
                                  //           showPassword = !showPassword;
                                  //         });
                                  //       },
                                  //       child: showPassword == true ? Icon(Icons.visibility) : Icon(Icons.visibility_off)
                                  //   ),
                                  //
                                  //   validatior: (value) {
                                  //     if (value == null || value.isEmpty) {
                                  //       return 'Enter above Detail';
                                  //     }
                                  //   },
                                  //   obsecureText: showPassword == true ? true : false,
                                  //   iconImage: Image.asset(
                                  //     'assets/AuthAssets/Icon ionic-ios-lock.png',
                                  //     scale: 1.3,
                                  //     color: primaryColor,
                                  //   ),
                                  //   hintText: "Password",
                                  //   controller: jpasswordController,
                                  // ),

                                  // AuthTextField(
                                  //   validatior: (value){
                                  //     if (value == null || value.isEmpty) {
                                  //       return 'Enter above Detail';
                                  //     }
                                  //   },
                                  //   obsecureText: true,
                                  //   iconImage: Image.asset(
                                  //     'assets/AuthAssets/Icon ionic-ios-lock.png',
                                  //     scale: 1.3,
                                  //     color: primaryColor,
                                  //   ),
                                  //   hintText: "Confirm Password",
                                  //   controller: jcpasswordController,
                                  // ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (_formkey.currentState!.validate()) {
                                        seekerSignUp();
                                        setState(() {
                                          isLoading = true;
                                        });
                                      }
                                      else {
                                        Fluttertoast.showToast(
                                            msg: "All fields are required");
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 1.1,
                                      height: 52,
                                      alignment: Alignment.center,
                                      //padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: isLoading ?
                                      Center(
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                          : Text("Submit", style: buttonTextStyle,),
                                    ),
                                  ),
                                  // CustomTextButton(
                                  //   buttonText: 'Submit',
                                  //   onTap: () {
                                  //    if( _formkey.currentState!.validate()){
                                  //      seekerSignUp();
                                  //    }
                                  //    else{
                                  //     Fluttertoast.showToast(msg: "All fields are required");
                                  //    }
                                  //     //jobseekersignup();
                                  //   },
                                  // ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "I already have an account!",
                                        style: TextStyle(
                                            color: greyColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                        GestureDetector(onTap: (){Get.to(SignInScreen());},child: Text(" Sign In", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /// Recruiter section
                         Container(
              child: Form(
                key: _formkey1,
                child: ListView(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    AuthTextField(
                      validatior: (val) => val!.isEmpty || !val.contains("@")
                          ? "Enter a valid email"
                          : null,
                      obsecureText: false,
                      keyboardtype: TextInputType.emailAddress,
                      iconImage: Image.asset('assets/AuthAssets/Icon material-email.png', scale: 1.3, color: primaryColor,),hintText: "Email", controller: remailController,),
                    AuthTextField(
                      validatior: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a First Name';
                        }
                        return null;
                      },
                      obsecureText: false,
                      iconImage: Image.asset('assets/AuthAssets/Icon awesome-user.png', scale: 1.3, color: primaryColor,),hintText: "Full Name",controller: fullNameController,),
                    AuthTextField(
                      validatior: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a First Name';
                        }
                        return null;
                      },
                      obsecureText: false,iconImage: Image.asset('assets/AuthAssets/Icon awesome-user.png', scale: 1.3, color: primaryColor,),hintText: "Company Name", controller: companyNameController ,),
                    AuthTextField(
                      validatior: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter a Mobile Number.';
                        }
                        // Use your mobile number validation regex here
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return 'Please Enter a Valid 10-digit mobile';
                        }
                        return null;
                      },
                      obsecureText: false,
                      keyboardtype: TextInputType.number,
                      length: 10,
                      controller: mobileController,
                      iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-call.png', scale: 1.3, color: primaryColor,),hintText: "Mobile No.",),
                    AuthTextField(
                      validatior: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter a Password.';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long.';
                        }
                        if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$').hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character.';
                        }
                        return null;
                      },
                      suffixIcons: InkWell(
                          onTap: (){
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: Icon(showPassword == true ? Icons.visibility : Icons.visibility_off,color: primaryColor,)),
                      obsecureText:showPassword == true ? false : true,
                      controller: passwordController,
                      iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-lock.png', scale: 1.3, color: primaryColor,),
                      hintText: 'Password',
                    ),
                    // AuthTextField(
                    //   obsecureText: true,
                    //   iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-lock.png', scale: 1.3, color: primaryColor,),hintText: "Confirm Password",),
                    // SizedBox(height: 30,),
                    // CustomTextButton(buttonText:  'Submit', onTap: (){
                    //   if(_formkey1.currentState!.validate()){
                    //     recruiterSignUp();
                    //   }
                    //   else{
                    //     Fluttertoast.showToast(msg: "All fields are required");
                    //   }
                    //   //recruitersignup();
                    //   },),
                    InkWell(
                      onTap: (){
                          if(_formkey1.currentState!.validate()){
                            recruiterSignUp();
                            setState(() {
                              isLoading = true;
                            });
                          }
                          else{
                            Fluttertoast.showToast(msg: "All fields are required");
                          }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 52,
                        alignment: Alignment.center,
                        //padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: isLoading ?
                        Center(
                          child: Container(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                            : Text("Submit", style: buttonTextStyle,),
                      ),
                    ),

                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "I already have an account!",
                          style: TextStyle(
                              color: greyColor,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(onTap: (){Get.to(SignInScreen());},child: Text("  Sign In", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),))
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
                          //RecruiterTab()
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    ));
  }
}
