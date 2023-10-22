import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 28, 0, 75),
            brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Spooky Reader - 3 Tarot Card Spread'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String API_KEY = "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";
  Random rnd = Random();
  dynamic listImages = [
    "0-TheFool.png",
    "1-TheMagician.png",
    "2-HighPriestess.png",
    "3-TheEmpress.png",
    "4-TheEmperor.png",
    "5-TheHierophant.png",
    "6-TheLovers.png",
    "7-TheChariot.png",
    "8-Strength.png",
    "9-TheHermit.png",
    "10-WheelofFortune.png",
    "11-Justice.png",
    "12-HangedMan.png",
    "13-Death.png",
    "14-Temperance.png",
    "15-TheDevil.png",
    "16-TheTower.png",
    "17-TheStar.png",
    "18-TheMoon.png",
    "19-TheSun.png",
    "20-Judgement.png",
    "21-TheWorld.png"
  ];
  dynamic chosenNumber = [];
  int _numCardsChosen = 0;
  String _responseText = """
🌟🌕🌿 Greetings, intrepid soul, and welcome to the realm of the Major Arcana! 🌿🌕🌟

I am your spectral guide for this enigmatic Celtic Cross tarot reading. As you draw the cards, we'll uncover the secrets of your past, present, and future. Embrace the unknown, for within its depths lies the wisdom you seek.

Draw your cards, and let our journey into the arcane begin. 🌙🔮🍂""";
  dynamic currentCards = [];
  bool loading = false;
  String textCardList = "";
  dynamic listCardNames = [
    "The Fool",
    "The Magician",
    "High Priestess",
    "The Empress",
    "The Emperor",
    "The Hierophant",
    "The Lovers",
    "The Chariot",
    "Strength",
    "The Hermit",
    "Wheel of Fortune",
    "Justice",
    "Hanged Man",
    "Death",
    "Temperance",
    "The Devil",
    "The Tower",
    "The Star",
    "The Moon",
    "The Sun",
    "Judgement",
    "The World",
  ];
  void getResponse(prompt) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $API_KEY'
      },
      body: jsonEncode(
        {
          "model": "text-davinci-003",
          "prompt": prompt,
          "max_tokens": 1000,
          "temperature": 0,
          "top_p": 1,
        },
      ),
    );
    setState(() {
      _responseText =
          "🌿🌕🌟" + jsonDecode(response.body)['choices'][0]['text'] + "🌙🔮🍂";
    });
    loading = false;
  }

  void _getCard() {
    setState(() {
      if (!loading) {
        if (_numCardsChosen == 3) {
          currentCards = [];
          _numCardsChosen = 0;
          textCardList = "";
        }
        _responseText = "👀 I'm Watching...";
        int min = 0;
        int max = listImages.length - 1;
        int r = min + rnd.nextInt(max - min);
        while (chosenNumber.contains(r)) {
          r = min + rnd.nextInt(max - min);
        }
        currentCards.add(Image.asset(listImages[r], fit: BoxFit.fill));
        chosenNumber.add(r);
        _numCardsChosen++;
        if (_numCardsChosen == 3) {
          textCardList += listCardNames[r] + ". ";
        } else {
          textCardList += listCardNames[r] + ", ";
        }
        if (_numCardsChosen >= 3) {
          chosenNumber = [];
          loading = true;
          _responseText = "Loading...";
          String prompt =
              "Pretend to be a spooky spirit  and give me a 3-card spread tarot reading from the major arcana with the cards " +
                  textCardList +
                  "\n\nWhat could they mean together? Give me a short numbered summary of each card and an overall summary of what it could mean.";
          getResponse(prompt);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 0, 75),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Realm of the Major Arcana",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                  "🔮 Welcome! Select 3 cards for our spooky spirit reader AI.\n",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.secondary),
                      alignment: Alignment.center,
                      width: (MediaQuery.of(context).size.width / 2) - 100,
                      height: MediaQuery.of(context).size.height - 350,
                      child: SingleChildScrollView(child: Text(_responseText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 28, 0, 75))))),
                  Container(
                    alignment: Alignment.centerRight,
                    width: (MediaQuery.of(context).size.width / 2) - 100,
                    height: MediaQuery.of(context).size.height - 436,
                    child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (var item in currentCards)
                            SizedBox(
                              width: 200,
                              child: item,
                            )
                        ])),
                  ),
                ],
              ),
              Image.asset("ghost.gif", alignment: Alignment.center, width: 50),
              TextButton(
                onPressed: _getCard,
                style: const ButtonStyle(
                  shadowColor: MaterialStatePropertyAll(Colors.black),
                  backgroundColor: MaterialStatePropertyAll(Colors.purple),
                ),
                child: const Text("Get Card",
                    style: TextStyle(color: Colors.white)),
              ),
              const Text(
                  "Asset Credits:\nhttps://n30hrtgdv.itch.io/ai-generated-tarot-deck\nhttps://master-blazter.itch.io/ghostspritepack\nMade using ChatGPT."),
            ],
          ),
        ),
      )),
    );
  }
}
