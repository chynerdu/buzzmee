import 'package:flutter/material.dart';


class CustomTextFormField extends StatelessWidget {
   final String placeholder;
   Function addEmailToFormData;
   CustomTextFormField(this.placeholder, this.addEmailToFormData);
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override

  Widget build(BuildContext context) {
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
        if (value.isEmpty ||
          !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        print('saved here $value');
         addEmailToFormData(value);
      },
    );
  }
}

