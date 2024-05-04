import 'package:flutter/material.dart';

class BuildForm extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function validator;
  final Function onSaved;

  const BuildForm({
    Key key,
    this.title,
    this.icon,
    this.validator,
    this.onSaved,
  }) : super(key: key);
  @override
  _BuildFormState createState() => _BuildFormState();
}

class _BuildFormState extends State<BuildForm> {
  bool _isObscure = true;
  IconData _iconData = Icons.visibility_off;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
          ),
          suffixIcon: IconButton(
              icon: Icon(_iconData),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _iconData =
                      _isObscure ? Icons.visibility_off : Icons.visibility;
                });
              }),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blue[600], width: 2.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blue[600], width: 2.0),
          ),
          labelText: widget.title,
          hintText: widget.title,
        ),
        validator: widget.validator,
        obscureText: _isObscure,
        onSaved: widget.onSaved,
      ),
    );
  }
}
