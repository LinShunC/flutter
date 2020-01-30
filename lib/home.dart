

import 'package:flutter/material.dart';
import 'package:newapp/DialogBox.dart';


import 'Authentication.dart';

import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert' as convert;




class home extends StatefulWidget
{
  home({
    this.auth,
    this.onSignedOut,
  
  });
   final AuthImplementation auth ;
 
  final VoidCallback onSignedOut;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState


    return HomePageState();
  }
}
 enum FormType
   {
     home,
     cart
   }
  class HomePageState extends State <home>
  {
     DialogBox dialogBox = new DialogBox();
     FormType formType = FormType.home;
   //List data;
   List data;
   Map <String, dynamic> cartData;
    void logout() async
    {
      try{
        await widget.auth.signOut();
        widget.onSignedOut();
      }
      catch(e)
      {
        print("error:"+e.toString());
      }
    }

      void moveToHome(){

     
      setState(() {
        formType = FormType.home;
     this.getCartJsonData();
   this.getJsonData();
   print(data);
   print(cartData);
      });
    }
     void moveToCart(){

   
      setState(() {
        formType = FormType.cart;
        this.getCartJsonData();
   this.getJsonData();
    print(data);
   print(cartData);
      });
    }
    Future <void> addToCart(String id,String price,String name,String imageurl) async
    {
      print("id is :"+id);
   String json = '{"id": "$id", "price": "$price", "name": "$name","url": "$imageurl"}';
     Map<String, String> headers = {"Content-type": "application/json"};
  var url = 'http://localhost:3001/api/userValidation/AddToCart';


  http.Response  response = await http.post(url, headers: headers, body:json);
  Map <String, dynamic> item = convert.jsonDecode(response.body);
  bool state = item["valid"];
  print(state);
 if (state == false)
{
  print("error");
}
else{
  dialogBox.information(context, "success :", "item add to cart successfully");

}

    }
    Future <void> removeFromCart(String id) async
    {
      print("id is :"+id);
   String json = '{"id": "$id"}';
     Map<String, String> headers = {"Content-type": "application/json"};
  var url = 'http://localhost:3001/api/userValidation/RemoveFromCart';


  http.Response  response = await http.post(url, headers: headers, body:json);
  Map <String, dynamic> item = convert.jsonDecode(response.body);
  bool state = item["valid"];
  print(state);
 if (state == false)
{
  print("error");
}
else{
  dialogBox.information(context, "success :", "item remove successfully");

}
setState(() {
  this.getCartJsonData();
   this.getJsonData();
});


    }

 @override
  void initState() {
   
    super.initState();
    this.getJsonData();
    this.getCartJsonData();
  }
  Future <void> getJsonData() async {

  var url = 'http://localhost:3001/api/userValidation/getInfo';

  var response = await http.get(url);
  if (response.statusCode == 200) {

  setState(() {
    List user = convert.jsonDecode(response.body)['image'];
    data = user;
  });
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  
}
 Future <void> getCartJsonData() async {

  var url = 'http://localhost:3001/api/userValidation/getCartInfo';

  var response = await http.get(url);

  if (response.statusCode == 200) {


 setState(() {
    Map <String, dynamic> item = convert.jsonDecode(response.body)['snapshot'];
    cartData = item;
    print(cartData['1']['url']);
    print("leanjadfhl");
    print(cartData.length);
  });
 
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  
}
  @override
  Widget build(BuildContext context) {
  if (formType == FormType.home){
    return new Scaffold(

      appBar: new AppBar(
        title:  new Text("Home"),
      ),
      body: new ListView.builder(
         itemCount: data == null ? 0: data.length,
        itemBuilder: (BuildContext context,index)
        {
          new Container(

          );
        
          return  _buildColumn(data[index]);
          
        },
       


      ),

      bottomNavigationBar: new BottomAppBar(

      color: Colors.lightBlue,
      child: new Container(
        margin: const EdgeInsets.only(left:50.0,right:50.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.exit_to_app),
              iconSize: 50,
              color: Colors.white, onPressed: logout,
            ),
            new IconButton(
              icon: new Icon(Icons.shopping_cart),
              iconSize: 40,
              color: Colors.white, onPressed: moveToCart,
              
            ),
          ],
        ),
      ),
      ),
    );
  }
  if(formType == FormType.cart)
  {
    return new Scaffold(

      appBar: new AppBar(
        title:  new Text("Cart"),
      ),
      body: new ListView.builder(
         itemCount: cartData == null ? 0: cartData.length,
        itemBuilder: (BuildContext context,index)
        {
          new Container(

          );
          print("container");
          print(cartData);
              return  _buildCartColumn(cartData[index]);
           /* if(cartData[index] != null)
            {
          return  _buildCartColumn(cartData[index]);}
          else { return new Container();}*/
      
        },
       


      ),

      bottomNavigationBar: new BottomAppBar(

      color: Colors.lightBlue,
      child: new Container(
        margin: const EdgeInsets.only(left:50.0,right:50.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.exit_to_app),
              iconSize: 50,
              color: Colors.white, onPressed: logout,
            ),
            new IconButton(
              icon: new Icon(Icons.home),
              iconSize: 40,
              color: Colors.white, onPressed: moveToHome,
            
            ),
          ],
        ),
      ),
      ),
    );
  }
  }
    
Widget _buildColumn(dynamic item) => Container
(
  
  decoration: BoxDecoration
  (
    color: Colors.blue[50]
  ),
  margin: const EdgeInsets.all(8),
  child: Column(
    
    children: <Widget>[

      Image.network(
          item['url'],
          width: 300,
           height: 220.0,
          //MediaQuery.of(context).size.width,  width of the screen
          fit: BoxFit.fill,
         
        ),
   new ListTile(
            title: new Center(child: new Text(item['name']+" - "+item['price'],
              style: new TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 25.0),)),
            subtitle: new Text(item['id']),
          ),
      
      new RaisedButton(  
       child: new Text("Add to cart",style:  new TextStyle(fontSize: 20.0),),
       textColor: Colors.white,
       color: Colors.lightBlue,
        onPressed:() => addToCart(item['id'],item['price'],item['name'],item['url']),
     ),
      
    ],
  ),
);

Widget _buildCartColumn(dynamic cartitem) => Container
(
  decoration: BoxDecoration
  (
    color: Colors.blue[50]
  ),
  margin: const EdgeInsets.all(8),
  child: Column(
    
    children: <Widget>[

      Image.network(
      
          cartitem['url'],
          width: 300,
           height: 220.0,
          //MediaQuery.of(context).size.width,  width of the screen
          fit: BoxFit.fill,
         
        ),
   new ListTile(
            title: new Center(child: new Text(cartitem['name']+" - "+cartitem['price'],
              style: new TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 25.0),)),
            subtitle: new Text(cartitem['id']),
          ),
      
      new RaisedButton(  
       child: new Text("Remove from cart",style:  new TextStyle(fontSize: 20.0),),
       textColor: Colors.white,
       color: Colors.lightBlue,
        onPressed:() => removeFromCart(cartitem['id']),
     ),
      
    ],
  ),
);

  }
  
