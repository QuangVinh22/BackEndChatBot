import 'package:chatbot/Screen/welcomescreen3.dart';
import 'package:chatbot/Widgets/containerwidget.dart';
import 'package:flutter/material.dart';

class WelcomeScreen2 extends StatelessWidget {
  const WelcomeScreen2({super.key});
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
            Icons.local_fire_department_rounded,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          const Text(
            "Capabilities",
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
                textOutSide: "Allow user to provide follow-up corrections",
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
                    "Remembers what user said earlier in the conversation",
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
                textOutSide: "Trained to decline inappropriate requests ",
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
                  color: const Color.fromARGB(255, 22, 156, 132),
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
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen3()),
                );
              },
              child: const Text(
                "Next",
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
