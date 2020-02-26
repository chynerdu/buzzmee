import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';


class FirstButton extends StatelessWidget {
   final Function initFunction;
   final String title;
   FirstButton(this.initFunction, this.title);
  @override

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return MaterialButton(
          onPressed: (){
            initFunction(model);
            //  Navigator.pushReplacementNamed(context, '/dashboard'); 
            // Navigator.pushReplacementNamed(context, '/listing');
          },
          child: Text(title,
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'SFUIDisplay',
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
          ),
          // color: Color(0xff3700b3),
          color: Color(0xffff0266),
          elevation: 0,
          minWidth: 350,
          height: 40,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
          ),
        );
      });
  }
}
