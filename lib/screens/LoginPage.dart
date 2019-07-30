import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModel/MainScopedModel.dart';
import '../models/Auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  bool tc = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    't&c': false
  };

  Auth _authMod = Auth.Login;
  bool _hidePassword = true;

  //bool _hideCPassword = true;

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
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          labelText: 'E-mail',
          //filled: true,
          //fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.email,
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
      obscureText: _hidePassword,
      validator: (String value) {
        if (value.isEmpty || value.length < 5)
          return "Empty password or less than 5 character length";
      },
      controller: passwordController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        labelText: 'Password',
        //filled: true,
        //fillColor: Colors.white,
        suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color:
                  _hidePassword ? Theme.of(context).primaryColor : Colors.blue,
            ),
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
            }),
        prefixIcon: Icon(
          Icons.lock,
        ),
      ),
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmField() {
    return _authMod == Auth.Login
        ? Container()
        : TextFormField(
            obscureText: _hidePassword,
            validator: (String value) {
              if (value != passwordController.text)
                return "Passwords don't match";
            },
            decoration: InputDecoration(
              labelText: 'Confirm password',
              labelStyle: TextStyle(color: Colors.black),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              //filled: true,
              //fillColor: Colors.white,
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: _hidePassword
                        ? Theme.of(context).primaryColor
                        : Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  }),
              prefixIcon: Icon(
                Icons.lock,
              ),
            ),
          );
  }

  Widget _buildSwitchListTile() {
    return _authMod == Auth.Login
        ? Container()
        : SwitchListTile(
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

  _showAlertDialog(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login failed'),
            content: Text('$message'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Okay'),
              )
            ],
          );
        });
  }

  void _authenticate(Function authUser, BuildContext context) async {
    Map<String, dynamic> _successInfo;
    _successInfo =
        await authUser(_formData['email'], _formData['password'], _authMod);

    //successInfo = await login(_formData['email'], _formData['password']);
    if (_successInfo['success'] == true)
      Navigator.pushReplacementNamed(context, '/home');
    if (_successInfo['success'] == 'EMAIL_NOT_FOUND')
      _showAlertDialog(_successInfo['message'], context);
    if (_successInfo['success'] == 'USER_DISABLED')
      _showAlertDialog(_successInfo['message'], context);
    if (_successInfo['success'] == 'INVALID_PASSWORD')
      _showAlertDialog(_successInfo['message'], context);

    if (_successInfo['success'] == true) {
      print('success:   ${_successInfo['success']}');
      Navigator.pushReplacementNamed(context, '/home');
    }
    if (_successInfo['success'] == 'EMAIL_EXISTS') {
      print('success:   ${_successInfo['success']}');
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Theme.of(context).primaryColor,
              alignment: Alignment.center,
              child: Text(
                _successInfo['message'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
            );
          });
    }
  }

  Widget _buildLoginButton() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
      return model.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RaisedButton(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Theme.of(context).primaryColor,
              child: _authMod == Auth.Login ? Text('Login') : Text('Signup'),
              onPressed: () {
                if (!_formKey.currentState.validate()) return;
                _formKey.currentState.save();
                _authenticate(model.authUser, context);
              },
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Form(
              key: _formKey,
              child: Container(
                decoration: ShapeDecoration(
                    color: Colors.grey,
                    shadows: [
                      BoxShadow(color: Colors.blue,spreadRadius: 1.0),
                    ],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      '${_authMod == Auth.Login ? 'Login' : 'Signup'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                    _buildEmailTextField(),
                    _buildPasswordField(),
                    SizedBox(height: 10.0),
                    _buildPasswordConfirmField(),
                    _buildSwitchListTile(),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _authMod = _authMod == Auth.Login
                                ? Auth.Signup
                                : Auth.Login;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                              text: 'Switch to ',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '${_authMod == Auth.Login ? 'Signup' : 'Login'}',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold))
                              ]),
                        )),
                    _buildLoginButton(),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
