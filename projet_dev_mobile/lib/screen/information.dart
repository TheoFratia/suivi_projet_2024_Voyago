import 'package:flutter/material.dart';


class Information extends StatelessWidget {
  const Information({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      Container(color: const Color.fromRGBO(130, 205, 249, 1),
      child: SafeArea(child:Column(children: [
        Row(children: [
          const SizedBox( width: 50),
          const Expanded(child: Text('Destination', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),),
          IconButton(onPressed: (){}, icon: const Icon(Icons.search))],),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          height: 60,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(90),
          ),
          child: const Row(
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
