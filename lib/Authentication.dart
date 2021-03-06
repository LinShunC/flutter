import 'dart:async';
import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;

abstract class AuthImplementation
{
Future <String>  signIn(String email, String password);
Future <bool>  signUp(String email, String password);
Future <bool>  signOut();
Future <String>  getCurrentUser();
}

class Auth implements AuthImplementation
{
  
Future <String>  signIn(String email, String password)async {
  String url ;
 if (Platform.isAndroid)
{
  
   url = 'http://10.0.2.2:3001/api/userValidation/validate';
}
else
{
   url = 'http://localhost:3001/api/userValidation/validate';

}


  Map<String, String> headers = {"Content-type": "application/json"};

  String json = '{"username": "$email" , "password": "$password"}';
  // make POST request
  http.Response response = await http.post(url, headers: headers, body:json);
Map <String, dynamic> user = jsonDecode(response.body);
bool state = user['valid'];
String UID = user['userid'];
print(UID);
print(state);
if (state == false)
{
  print("error");
  return null;
}
else{
return UID;
}


}
Future <bool>  signUp(String email, String password)async {
  //http.Response reponse = await http.post("http://localhost:3001/api/userValidation/validate");
String url ;
if (Platform.isAndroid)
{
  
   url = 'http://10.0.2.2:3001/api/userValidation/signup';
}
else
{
   url = 'http://localhost:3001/api/userValidation/signup';

}
  Map<String, String> headers = {"Content-type": "application/json"};
  print(email+password);
  String json2 = '{"username": "$email" , "password": "$password"}';
  // make POST request
  http.Response response = await http.post(url, headers: headers, body: json2);
Map <String, dynamic> user = jsonDecode(response.body);
bool state = user['valid'];


if (state == false)
{
  print("error");
}
else{

}
return state;
}

Future <bool>  signOut()async {
 String url ;
 if (Platform.isAndroid)
{
  
   url = 'http://10.0.2.2:3001/api/userValidation/signout';
}
else
{
   url = 'http://localhost:3001/api/userValidation/signout';

}

 // Map<String, String> headers = {"Content-type": "application/json"};
//  String json = '{"username": "test@gmail.com", "password": "222222"}';
  // make POST request
  http.Response response = await http.post(url); //headers: headers, body: json);
Map <String, dynamic> user = jsonDecode(response.body);
bool state = user['valid'];

print(state);
if (state == false)
{
  print("error");
  return false;
}
else{

return true;
}

}
Future <String>  getCurrentUser()async {
    String url ;
 if (Platform.isAndroid)
{
  
   url = 'http://10.0.2.2:3001/api/userValidation/currentUser';
}
else
{
   url = 'http://localhost:3001/api/userValidation/currentUser';

}

  

 // Map<String, String> headers = {"Content-type": "application/json"};
 // String json = '{"username": "test@gmail.com", "password": "222222"}';
  // make POST request
  http.Response response = await http.post(url);// headers: headers, body: json);
Map <String, dynamic> user = jsonDecode(response.body);
bool state = user['valid'];
String userID = user['userid'];
print(userID);
print(state);
if (state == false)
{
  print("error");
}
else{

}
return userID;

}

}