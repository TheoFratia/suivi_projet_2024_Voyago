import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Information extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      Container(color: Color.fromRGBO(130, 205, 249, 1),
      child: SafeArea(child:Column(children: [
        Row(children: [
          SizedBox( width: 50),
          Expanded(child: Text('Destination', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),),
          IconButton(onPressed: (){}, icon: Icon(Icons.search))],),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          height: 60,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(90),
          ),
          child: Row(
          children: [
            Expanded(child: Text("Infos utiles", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(255, 227, 97, 1)),),),
            Expanded(child: Text("Activités", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(130, 205, 249, 1))),),
            Expanded(child: Text("Hôtels", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(130, 205, 249, 1))),),
          ],
        ),)
      ],)
      ),
      ),
    );
  }
}
