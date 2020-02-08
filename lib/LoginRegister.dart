

import 'package:flutter/material.dart';

import 'DialogBox.dart';

import 'Authentication.dart';

class LoginRegiser extends StatefulWidget 
{
  LoginRegiser({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementation auth ;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() {
   return LoginRegiserState();
     }
  
   }

   enum FormType
   {
     login,
     register
   }
   
   class LoginRegiserState extends State<LoginRegiser>
{
DialogBox dialogBox = new DialogBox();

  final formKey = new GlobalKey<FormState>();
  FormType formType = FormType.login;
  String email = "";
  String password = "";



bool validateAndSave() {
  final form = formKey.currentState;
  if (form.validate()) 
  {
    form.save();
    return true;
  }
  else
  {
    return false;
  }

}
void validateAndSubmit() async
{
if (validateAndSave())
{
  try
  {
if (formType == FormType.login)
{
  String userID = await widget.auth.signIn(email, password);
  if (userID!=null){
widget.onSignedIn();
  }
  else
  {
      dialogBox.information(context, "Error :", "please check your email and password");
  }

}
else{
 bool state = await widget.auth.signUp(email, password);
 if (state == true){
widget.onSignedIn();
  }
  else
  {
      dialogBox.information(context, "Error :", "please check your email and password");
  }

}

  }catch(e)
  {
    dialogBox.information(context, "Error :", e.toString());
  }
  
}
}

 
    void moveToRegister(){

      formKey.currentState.reset();
      setState(() {
        formType = FormType.register;
     
      });
    }
     void moveToLogin(){

      formKey.currentState.reset();
      setState(() {
        formType = FormType.login;
      });
    }



  // ui design
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Shopping App")
      ),

       body: new Container(
         margin: EdgeInsets.all(15.0),
         child: new Form(

           key: formKey,
           child: new Column(
             crossAxisAlignment:CrossAxisAlignment.stretch,
children: createInputs() +createButtons(),
           ),
         ),
       ),
    );
    
  }
  List <Widget> createInputs()
  {
    return
    [
      SizedBox(height: 10.0,),
      logo(),
       SizedBox(height: 20.0,),
       new TextFormField(
         decoration: new InputDecoration(labelText: "Email"),

         validator:  (value)
         {
           return value.isEmpty ? "email is required" : null;
         },
         onSaved: (value)
         {
           return email = value;
         },
       ),
         SizedBox(height: 10.0,),
       new TextFormField(
         decoration: new InputDecoration(labelText: "Password"),
         obscureText: true,

          validator:  (value)
         {
           return value.isEmpty ? "password is required" : null;
         },
         onSaved: (value)
         {
           return password = value;
         },
       ),
         SizedBox(height: 20.0,),

    ];
  }

     Widget logo()
     {
       return new Hero(
         tag: "image",
         child: new CircleAvatar(
           backgroundColor: Colors.transparent,
           radius: 110.0,
           child: Image.asset('image/shopping.png'),
           
         ),
       );
     }
     List <Widget> createButtons()
  { 
    if(formType == FormType.login){
    return
    [
     new RaisedButton(  
       child: new Text("Login",style:  new TextStyle(fontSize: 20.0),),
       textColor: Colors.white,
       color: Colors.lightBlue,
        onPressed: validateAndSubmit,
     ),
         
          new FlatButton(  
       child: new Text("Not have an account",style:  new TextStyle(fontSize: 14.0),),
       textColor: Colors.black,
         onPressed: moveToRegister,
     )
    ];}
    else
    {
        return
    [
     new RaisedButton(  
       child: new Text("Register",style:  new TextStyle(fontSize: 20.0),),
       textColor: Colors.white,
       color: Colors.lightBlue,
        onPressed: validateAndSubmit,
     ),
         
          new FlatButton(  
       child: new Text("Already have an account",style:  new TextStyle(fontSize: 14.0),),
       textColor: Colors.black,
         onPressed: moveToLogin,
     )
    ];
    }

  }
}