import 'package:flutter/material.dart';
import 'package:newapp/pay.dart';
import "LoginRegister.dart";
import 'home.dart';
import 'Authentication.dart';



class Mapping extends StatefulWidget 
{
  final AuthImplementation auth ;

  Mapping({
    this.auth,

  });

State <StatefulWidget> createState()
{
  return MappingPageState();
}
}

enum AuthStatus
{
  signedIn,
  notSignedIn,
  pay
}
class MappingPageState extends State <Mapping>

{
  AuthStatus authStatus = AuthStatus.notSignedIn;
  @override
  void initState() {
   widget.auth.getCurrentUser().then((firebaseUserId)
   {
     setState(() {
       authStatus = firebaseUserId == null ? AuthStatus.notSignedIn :AuthStatus.signedIn;
     });

   });
   
   
    super.initState();
  }
  void signedIn()
  {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }
  void signOut()
  {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }
  void toPay()
  {
    setState(() {
      authStatus = AuthStatus.pay;
    });
  }
  @override
  Widget build(BuildContext context) {
   
   switch(authStatus)
   {
     case AuthStatus.notSignedIn :
     return new LoginRegiser(
       auth: widget.auth,
       onSignedIn: signedIn,
     );
     case AuthStatus.signedIn:
    return new Home(
       auth: widget.auth,
       onSignedOut: signOut,
       onPay:toPay,
     );
       break;
     case AuthStatus.pay:
       return new PayPage(
         onSignedIn: signedIn,
       );
       break;
   }
    return null;
  }

}