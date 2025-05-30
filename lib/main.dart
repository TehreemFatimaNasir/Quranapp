import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  Mysplashscreen(),
    );
  }
}

class Mysplashscreen extends StatefulWidget {
  const Mysplashscreen({super.key});

  @override
  State<Mysplashscreen> createState() => _MysplashscreenState();
}

class _MysplashscreenState extends State<Mysplashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>   buttonscreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2193b0), Color(0xff6dd5ed)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            "Mushaf",
            style: GoogleFonts.amiriQuran(fontSize: 35, color: Color(0xFFFFF8E7)),
          ),
        ),
      ),
    );
  }
}

class SurahScreen extends StatefulWidget {
  const SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/QURAN.png",
          width: 100,
          height: 100,
        ),
      ),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => detailsurah(index + 1),
                ),
              );
            },
            leading: CircleAvatar(
                      backgroundColor: Color(0xFF00ACC2),
                foregroundColor: Colors.white,
              child: Text("${index + 1}"),
            ),
            title:Text(quran.getSurahNameArabic(index+1),style: GoogleFonts.amiriQuran(),),
            subtitle: Text(quran.getSurahName(index+1)),
            trailing: Column(
              children: [
                quran.getPlaceOfRevelation(index+1)=="Makkah"?
                Image.asset("assets/images/Makkah.png",width: 30,
                          height: 30,):
                          Image.asset("assets/images/madina.png", 
                           width: 30,
                          height: 30,),
                        Text("verses"+quran.getVerseCount(index+1).toString()),
              ],),
          );
        },
      ),
    );
  }
}
class detailsurah extends StatefulWidget {
 var surahnumber;

  
  detailsurah(this.surahnumber, {super.key});

  @override
  State<detailsurah> createState() => _detailsurahState();
}

class _detailsurahState extends State<detailsurah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          quran.getSurahNameArabic(widget.surahnumber),
          style: GoogleFonts.amiriQuran(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ListView.builder(
            itemCount: quran.getVerseCount(widget.surahnumber),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  quran.getVerse(widget.surahnumber, index + 1, verseEndSymbol: true),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiri(),
                ),
                subtitle: Text(
                  quran.getVerseTranslation(widget.surahnumber, index + 1,
                      translation: quran.Translation.urdu),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.notoNastaliqUrdu(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
class audio extends StatefulWidget {
  var surahnumber;
 audio(this.surahnumber,{super.key});

  @override
  State<audio> createState() => _audioState();
}

class _audioState extends State<audio> {
  AudioPlayer audioPlayer = AudioPlayer();
  IconData playpausebtn =Icons.play_arrow_rounded;
  bool isplaying = true;

  ToggleButton()async{
    final audiourl = await quran.getAudioURLBySurah(widget.surahnumber);
    audioPlayer.setUrl(audiourl);
if(isplaying){
  audioPlayer.play();
  setState(() {
    isplaying=false;
     playpausebtn = Icons.pause;
  });
}else{
  audioPlayer.pause();
  setState(() {
    isplaying=true;
     playpausebtn = Icons.play_arrow_rounded;
  });
}
  }
 @override
 void dispose(){
  super.dispose();
  audioPlayer.dispose();
 }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(quran.getSurahNameArabic(widget.surahnumber),style: GoogleFonts.amiriQuran(fontSize: 30),
          ),
          CircleAvatar(radius: 100,  backgroundColor: Color(0xFF2596BE),backgroundImage: AssetImage("assets/images/alafasy.jpg"),),
          Container(width: double.infinity,color: Color(0xFF2596BE),child: IconButton(onPressed: ToggleButton, icon: Icon(
            playpausebtn,color: Colors.white,
          )),),
          ],
        ),
      ),
    );
  }
}
class buttonscreen extends StatefulWidget {
  const buttonscreen({super.key});

  @override
  State<buttonscreen> createState() => _buttonscreenState();
}

class _buttonscreenState extends State<buttonscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SurahScreen(),));},
           child: Text("Read Quran")),SizedBox(height: 16,),

          ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>audioscreen()));}, 
          child: Text("listen Quran")),SizedBox(height: 16,),
        ],
        ),
      ),
    );
  }
}

class audioscreen extends StatefulWidget {
  const audioscreen({super.key});

  @override
  State<audioscreen> createState() => _audioscreenState();
}

class _audioscreenState extends State<audioscreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/QURAN.png",
          width: 100,
          height: 100,
        ),
      ),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => audio(index + 1),
                ),
              );
            },
            leading: CircleAvatar(
               backgroundColor: Color(0xFF00ACC2),
                foregroundColor: Colors.white,
              child: Text("${index + 1},"),
            ),
            
            title:Text(quran.getSurahNameArabic(index+1),style: GoogleFonts.amiriQuran(),), 
            subtitle: Text("Sheikh Mishary",style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey[700]),),
            trailing: Column(
              children: [
                quran.getPlaceOfRevelation(index+1)=="Makkah"?
                Image.asset("assets/images/Makkah.png",width: 30,
                          height: 30,):
                          Image.asset("assets/images/madina.png", 
                           width: 30,
                          height: 30,),
                        Text("verses"+quran.getVerseCount(index+1).toString()),
              ],),
          );
        },
      ),
    );
  }
}