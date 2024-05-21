import 'package:flutter/material.dart';

class ContainerWidgets extends StatelessWidget {
  const ContainerWidgets({required this.textOutSide, super.key});
  final String textOutSide;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ), //BorderRadius.all
        color: const Color.fromARGB(255, 63, 63, 74),
      ),
      child: SizedBox(
        width: 350,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 35,
            right: 35,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  textOutSide.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
