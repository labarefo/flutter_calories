import 'package:flutter/material.dart';
import 'package:flutter_calorie/models/custom_text.dart';
import 'package:age/age.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Calcul de calories'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool genre = false;
  int age = 0;
  int taille = 100;
  int poids = 0;
  double sliderDouble = 100.0;

  double activiteSportive;


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: couleur(genre),
        title: Text(widget.title),
      ),
      body: ListView(

        children:[ Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new CustomText("Remplissez tous les champs pour obtenir votre besoin journalier en calories", factor: 1.2, color: Colors.grey[900],),

            new Card(
              elevation: 100,
              child: new Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width * 0.93,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new CustomText('Femme', color: Colors.pinkAccent, factor: 1.3,),
                        new Switch(
                            value: genre, activeColor: Colors.pinkAccent, inactiveTrackColor: Colors.blueAccent,
                            onChanged: (bool b){
                              setState(() {
                                genre = b;
                              });
                            }
                        ),
                        new CustomText('Homme', color: Colors.blueAccent, factor: 1.3,),
                      ],
                    ),
                    new RaisedButton(
                      onPressed: calculerAge,
                      color: couleur(genre),
                      child: age == 0 ? new CustomText("Appuyer pour entrer votre âge", factor: 1.3,) : new CustomText("Votre âge est: $age", factor: 1.3,),
                    ),

                    new CustomText("Votre taille est de: $taille cm.", factor: 1.5, color: couleur(genre),),
                    new Slider(
                        value: sliderDouble,
                        divisions: 50,
                        min: 100,
                        max: 210,
                        inactiveColor: Colors.blueGrey,
                        activeColor: couleur(genre),
                        onChanged: (double d){
                          setState(() {
                            taille = d.floor();
                            sliderDouble = d;
                          });
                        }
                    ),
                    new TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 3,

                      onSubmitted: (String i){
                        setState(() {
                          if(i.isEmpty){
                            poids = 0;
                          }else{
                            poids = int.parse(i);
                          }

                        });
                      },
                      decoration: new InputDecoration(labelText: "Entrez votre poids en Kilos"),
                    ),
                    new CustomText("Quelle est votre activité sportive ?", factor: 1.5, color: couleur(genre),),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        radio(1.2, activiteSportive),
                        radio(1.5, activiteSportive),
                        radio(1.8, activiteSportive),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new CustomText("Faible", color: couleur(genre), factor: 1.5,),
                        new CustomText("Moderée", color: couleur(genre), factor: 1.5,),
                        new CustomText("Forte", color: couleur(genre), factor: 1.5,),
                      ],
                    )
                  ],
                ),
                ),
              ),
            new RaisedButton(
              color: couleur(genre),
                child: new CustomText("Calculer"),
                onPressed: _calculerCalories,
            )

          ],
        ),
      ]
      ),

    );
  }

  Widget radio(double radio, double activite){
    return new Radio(
        value: radio,
        groupValue: activite,
        onChanged: (double d){
          setState(() {
            activiteSportive = d;
          });
        }
    );
  }

  Color couleur(bool genre){
    if(genre){
      return Colors.pinkAccent;
    }
    return Colors.blueAccent;
  }

  Future<Null> calculerAge() async {

    DateTime anniversaire = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1945),
        lastDate: new DateTime(2045));
    DateTime today = DateTime.now();
    if(anniversaire != null){
      setState(() {
        age = Age.dateDifference(fromDate: anniversaire, toDate: today).years;
      });
    }
  }

  void _calculerCalories() {
    if(!_isAccepte()){
      // Afficher le message d'erreur : dialogue
      _alert();
      return;
    }
    _resultat();
  }


  Future<Null> _resultat() async {
    int besoin;
    int sportive;
    double calorie;
    if(genre){
      calorie = 655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age);
    }else{
      calorie = 66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age);
    }
    besoin = calorie.floor();
    sportive = (calorie * activiteSportive).floor();
    
    return showDialog(context: context,
    barrierDismissible: false,
      builder: (BuildContext context){
      return new SimpleDialog(
        contentPadding: EdgeInsets.all(5),
        elevation: 10,
        title: new CustomText("Votre besoin en calories", factor: 1.2, color: couleur(genre),textAlign: TextAlign.center,),
        children: [
          new CustomText("Votre besoin de base est: $besoin", color: Colors.black,),

          new CustomText("Votre besoin avec activité sportive est: $sportive", color: Colors.black,),

          new RaisedButton(
              color: couleur(genre),
              child: new CustomText("OK", factor: 1.5,),
              onPressed: (){
                Navigator.pop(context);
              })
        ],
      );
      }
    );
  }

  bool _isAccepte() {
    if(age <= 0){
      return false;
    }
    if(taille <= 0){
      return false;
    }
    if(poids <= 0){
      return false;
    }
    if(activiteSportive == null){
      return false;
    }

    return true;

  }

  Future<Null> _alert() async {
    return showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: new CustomText('Erreur', color: Colors.red,factor: 1.5,),
          contentPadding: EdgeInsets.all(5.0),
          content: new CustomText("Tous les champs ne sont pas remplis", color: Colors.grey[900], factor: 1.3,),
          actions: [
            new RaisedButton(
                color: Colors.red,
                child: new CustomText("OK", factor: 1.2,),
                onPressed: (){
                  Navigator.pop(context);
                }
            )
          ],
        );
      },

    );
  }

}
