import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../scoped-models/main.dart';
// widgets
import '../../widgets/firstButton.dart';

class Auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Auth();
  }
}

class _Auth extends State <Auth> {
  final Map<String, dynamic> _formData = {
  'email': null,
  'password': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  login(model) {
    print('param $model');
    _submitFunction(model.login);
  }

  // addEmailToFormData(String value) {
  //   print('value is $value');
  //   _formData['email'] = value;
  // }

    void _submitFunction(Function login) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    
      // print(_formData['subtitle']);
      login(
        _formData['phone'],
        _formData['password'],
      ).then((Map<String, dynamic> success) {
        if(success['success']) {
          print('successsful');
            Navigator.pushReplacementNamed(context, '/home');
        } else {
          Flushbar(
            title:  "An Error Occured!",
            message:  success['message'],
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
            backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
            icon: Icon(
              Icons.warning,
              color: Colors.redAccent,
            ),
 
            duration:  Duration(seconds: 3),              
          )..show(context);
        }
      });
    }
  @override

  Widget buildPhoneTextFormField() {
    return TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        ),
        labelText: 'Phone Number',
        labelStyle: TextStyle(fontSize: 15,
        color: Colors.white)
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter a valid phone number';
        }
      },
      onSaved: (String value) {
        print('saved here $value');
        _formData['phone'] = value;
      },
    );
  }
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/buzzmee.jpg'),
              fit: BoxFit.cover,
            )
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ModalProgressHUD(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.all(23),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 130,),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text('BuzzMee', style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold
                              ))
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 80, 0, 20),
                              child: buildPhoneTextFormField()
                            ),
                            TextFormField(
                              obscureText: true,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white
                                    )
                                  ),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(fontSize: 15,
                                  color: Colors.white)
                                ),
                                validator: (String value) {
                                  if (value.isEmpty || value.length < 6) {
                                    return 'Password invalid';
                                  }
                                },
                                onSaved: (String value) {
                                  print('value passswod $value');
                                  _formData['password'] = value;
                                }
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20,bottom: 5),
                        child: Text('Forgot your password?',
                        textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'SFUIDisplay',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          child: FirstButton(login, 'Login')
                          // MaterialButton(
                          //   onPressed: (){
                          //     //  Navigator.pushReplacementNamed(context, '/dashboard'); 
                          //     Navigator.pushReplacementNamed(context, '/listing');
                          //   },
                          //   child: Text('SIGN IN',
                          //   style: TextStyle(
                          //     fontSize: 15,
                          //     fontFamily: 'SFUIDisplay',
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.white
                          //   ),
                          //   ),
                          //   color: Color(0xffff2d55),
                          //   elevation: 0,
                          //   minWidth: 350,
                          //   height: 60,
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(50)
                          //   ),
                          // ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 20),
                      //   child: MaterialButton(
                      //     onPressed: (){
                      //        Navigator.pushReplacementNamed(context, '/register');
                      //     },
                      //     child: Row(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: <Widget>[
                      //         // Icon(Icons.person_add),
                      //         // Icon(FontAwesomeIcons.facebookSquare),
                      //         Text('Sign up',
                      //         style: TextStyle(
                      //           fontSize: 15,
                      //           fontFamily: 'SFUIDisplay'
                      //         ),)
                      //       ],
                      //     ),
                      //     color: Colors.transparent,
                      //     elevation: 0,
                      //     minWidth: 350,
                      //     height: 60,
                      //     textColor: Colors.white,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(50),
                      //       side: BorderSide(color: Colors.white)
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // text: TextSpan(
                              children: [
                                Text(
                                   "Don't have an account?",
                                  style: TextStyle(
                                    fontFamily: 'SFUIDisplay',
                                    color: Colors.white,
                                    fontSize: 15,
                                  )
                                ),
                                FlatButton(
                                  child: Text('Create Account', 
                                  style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(context, '/register');
                                    }
                                ),
                              ]
                            // ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              inAsyncCall:model.isLoading,
              opacity: 0.6,
              color:Colors.black87,
              progressIndicator: SpinKitRipple(
                color: Colors.white,
                size: 100.0,
              )
            )
          ),
        );
      });
  }
}