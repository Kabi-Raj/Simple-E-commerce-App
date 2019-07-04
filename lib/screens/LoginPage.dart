import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModel/MainScopedModel.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  bool tc = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    't&c': false
  };

  Widget _buildEmailTextField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
                  .hasMatch(value)) return "Empty or invalid email";
        },
        decoration: InputDecoration(
          labelText: 'E-mail',
          filled: true,
          fillColor: Colors.white,
          icon: Icon(
            Icons.email,
            color: Colors.blue,
            size: 40.0,
          ),
        ),
        onSaved: (String value) {
          _formData['email'] = value;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty || value.length < 5)
          return "Empty password or less than 5 character length";
      },
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
        icon: Icon(
          Icons.vpn_key,
          color: Colors.blue,
          size: 40.0,
        ),
      ),
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildSwitchListTile() {
    return SwitchListTile(
      activeColor: Theme.of(context).primaryColor,
      value: tc,
      title: Text(
        'Accept T&C',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onChanged: (bool value) {
        setState(() {
          tc = value;
        });
      },
    );
  }

  Widget _buildLoginButton() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
      return RaisedButton(
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).primaryColor,
        child: Text('Login'),
        onPressed: () {
          if (!_formKey.currentState.validate()) return;
          _formKey.currentState.save();
          model.login(_formData['email'], _formData['password']);
          Navigator.pushReplacementNamed(context, '/home');
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: DecoratedBox(
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildEmailTextField(),
                  _buildPasswordField(),
                  _buildSwitchListTile(),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5), BlendMode.dstATop),
          ),
        ),
      ),
    );
  }
}
