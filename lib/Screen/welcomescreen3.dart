import 'package:chatbot/Screen/dashboard.dart';
import 'package:chatbot/Widgets/containerwidget.dart';
import 'package:flutter/material.dart';

class WelcomeScreen3 extends StatelessWidget {
  const WelcomeScreen3({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 53, 65),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 100,
                child: Image.asset(
                  "assets/cc3.png",
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Text(
            "Welcome to ",
            style: TextStyle(
                fontSize: 28, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const Text(
            "ChatGPT",
            style: TextStyle(
                fontSize: 28, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Ask anything, get your answer",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 40),
          const Icon(
            Icons.warning_amber_outlined,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          const Text(
            "Limitations",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 30,
          ),
          const Row(
            children: [
              SizedBox(
                width: 20,
              ),
              ContainerWidgets(
                textOutSide: "May occasionally generate incorrect infomation",
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            children: [
              SizedBox(
                width: 20,
              ),
              ContainerWidgets(
                textOutSide: "Limited knowledge of world and event after 2022",
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            children: [
              SizedBox(
                width: 20,
              ),
              ContainerWidgets(
                textOutSide:
                    "May occasionally produce harmful instructions or biased content",
              ),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: const Color.fromARGB(255, 63, 63, 74),
                ),
                child: const SizedBox(
                  width: 30,
                  height: 5,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: const Color.fromARGB(255, 63, 63, 74),
                ),
                child: const SizedBox(
                  width: 30,
                  height: 5,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: const Color.fromARGB(255, 22, 156, 132),
                ),
                child: const SizedBox(
                  width: 30,
                  height: 5,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 50,
            width: 350,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 22, 156, 132),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashBoard()),
                );
              },
              child: const Text(
                "Let's Chat",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}
