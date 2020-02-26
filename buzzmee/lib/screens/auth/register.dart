import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../scoped-models/main.dart';
// widgets
import '../../widgets/firstButton.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State <Register> {
  final Map<String, dynamic> _formData = {
  'email': null,
  'password': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  register(model) {
    print('param $model');
    _submitFunction(model.register);
  }

  // addEmailToFormData(String value) {
  //   print('value is $value');
  //   _formData['email'] = value;
  // }

    void _submitFunction(Function register) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    
      // print(_formData['subtitle']);
      register(
        _formData['phone'],
        _formData['password'],
        _formData['first_name'],
        _formData['last_name'],
        _formData['username'],
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
  Widget buildNameTextFormField(placeholder, textValue) {
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
        labelText: placeholder,
        labelStyle: TextStyle(fontSize: 15,
        color: Colors.white)
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter a valid input';
        }
      },
      onSaved: (String value) {
        print('saved here $value');
        _formData[textValue] = value;
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
                      SizedBox(height: 45,),
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
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text('Signup', style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal
                              ))
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: buildNameTextFormField('Username', 'username')
                            ),
                           Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: buildNameTextFormField('First Name', 'first_name')
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: buildNameTextFormField('Last Name', 'last_name')
                            ),

                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          child: FirstButton(register, 'register')
                         
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // text: TextSpan(
                              children: [
                                Text(
                                   "Already have an account?",
                                  style: TextStyle(
                                    fontFamily: 'SFUIDisplay',
                                    color: Colors.white,
                                    fontSize: 15,
                                  )
                                ),
                                FlatButton(
                                  child: Text('Login Now', 
                                  style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(context, '/');
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