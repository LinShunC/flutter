import 'package:flutter/material.dart';
import 'DialogBox.dart';
import 'Authentication.dart';
import 'dart:async';

import 'dart:io';
import 'dart:convert' as convert;
import "package:http/http.dart" as http;



class PayPage extends StatefulWidget
{
  PayPage({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementation auth ;
  final VoidCallback onSignedIn;
  State <StatefulWidget> createState()
  {
    return _PayPageState();
  }
}

class _PayPageState extends State <PayPage>
{
   DialogBox dialogBox = new DialogBox();
  final formKey = new  GlobalKey<FormState>();
  String name;
  String cardNumber;
  String expirationData;
  String securityCode;

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
 Future <bool> paymentRecord() async
    {
     
  
     Map<String, String> headers = {"Content-type": "application/json"};
     String url ;
      if (Platform.isAndroid)
{
  
   url = 'http://10.0.2.2:3001/api/userValidation/PaymentRecord';
}
else
{
   url = 'http://localhost:3001/api/userValidation/PaymentRecord';

}

  
  String json = '{"name":"$name"  , "cardNumber": "$cardNumber", "expirationData": "$expirationData", "securityCode": "$securityCode"}';


  http.Response  response = await http.post(url, headers: headers, body:json);
  Map <String, dynamic> item = convert.jsonDecode(response.body);
  bool state = item["valid"];

  
 if (state == false)
{
  print("error");
  return false;
}
else{
  dialogBox.information(context, "success :", "Payment successfully");
  return true;
}



    }
void validateAndSubmit() async
{
if (validateAndSave())
{

 if(await paymentRecord() )
 {
widget.onSignedIn();
 }
 else
 {
   dialogBox.information(context, "error :", "Payment Failed");
 }

}
else{
  dialogBox.information(context, "error :", "Please check your input");

}
}

  @override
  Widget build(BuildContext context) {

  
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
               icon: new Icon(Icons.arrow_back, color: Colors.white),
               onPressed: (){
                 widget.onSignedIn();
               },
              ), 
            title: new Text("Payment"),
centerTitle: true,
            ),


      
      body: 
        Container(
           margin: const EdgeInsets.all(8),
         child: new Form(
           key: formKey,
           child: Column(
             children: <Widget>[
               SizedBox(height: 10.0,),
      payImage(),
               SizedBox(height: 10),
               TextFormField(
                 
                 decoration: new InputDecoration(
                        border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid))
,
                   labelText: "Name On Card"
                   
                     
                 ),
                 validator:  (value)
         {
           return value.isEmpty ? "Name is required" : null;
         },
         onSaved: (value)
         {
           return name = value;
         },
               ),
               SizedBox(height: 10),
               TextFormField(
                 
                 decoration: new InputDecoration(
                        border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid))
,
                   labelText: "Card Number"
                     
                 ),
                 validator:  (value)
         {
           return value.isEmpty ? "Card number is required" : null;
         },
         onSaved: (value)
         {
           return cardNumber = value;
         },
               ),
               SizedBox(height: 10),
               TextFormField(
                 
                 decoration: new InputDecoration(
                        border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid))
,
                   labelText: "Expiration Date"
                     
                 ),
                 validator:  (value)
         {
           return value.isEmpty ? "Expiration Date is required" : null;
         },
         onSaved: (value)
         {
           return expirationData = value;
         },
               ),
               SizedBox(height: 10),
               TextFormField(
                 
                 decoration: new InputDecoration(
                        border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid))
,
                   labelText: "Security Code (CVV)"
                     
                 ),
                 validator:  (value)
         {
           return value.isEmpty ? "Security Code is required" : null;
         },
         onSaved: (value)
         {
           return securityCode = value;
         },
               ),
                SizedBox(height: 30),
               new SizedBox(
                 width: 240.0,
  height: 50.0,
             child:  new RaisedButton(  
                shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
           // side: BorderSide(color: Colors.red)
            ),
       child: new Text("Submit",style:  new TextStyle(fontSize: 20.0),),
       textColor: Colors.white,
       color: Colors.lightBlue,
        onPressed: validateAndSubmit,
     ),
     
     ),
    
             ],
           ),

          

         ),
     
),
    );
  }

     Widget payImage()
     {
       return new Hero(
         tag: "image",
         child: new CircleAvatar(
           backgroundColor: Colors.transparent,
           radius: 110.0,
           child: Image.asset('image/pay.png'),
           
         ),
       );
     }
  
}