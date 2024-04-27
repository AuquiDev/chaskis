import 'package:flutter/material.dart';
import 'package:chaskis/provider_cache/current_page.dart';
import 'package:chaskis/pages/lista.dart';
import 'package:chaskis/utils/custom_text.dart';
import 'package:provider/provider.dart';

class CardVertical extends StatefulWidget {
  const CardVertical({
    super.key,
  });

  @override
  State<CardVertical> createState() => _CardVerticalState();
}

class _CardVerticalState extends State<CardVertical> {
  final controller = ScrollController();
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentIndex = (controller.offset / 200).round();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 150,
          child: ListView.builder(
            padding: const EdgeInsets.only(right: 200),
            scrollDirection: Axis.horizontal,
            controller: controller,
            itemCount: cardList.length,
            itemBuilder: (BuildContext context, int index) {
              final e = cardList[index];
              return CardEncuesta(e: e);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            cardList.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? const Color(0xFF033C05)
                      : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CardEncuesta extends StatelessWidget {
  const CardEncuesta({
    super.key,
    required this.e,
  });

  final Card3D e;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            final layoutmodel =
                Provider.of<LayoutModel>(context, listen: false);
            layoutmodel.currentPage = e.page;
          },
          child: Container(
            width: 170,
            height: 130,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFB1E6B3).withOpacity(.3),
                  const Color(0xFF3E524F).withOpacity(.5),
                  const Color(0xFF48675E).withOpacity(.2),
                  // const Color(0xFF5B5D3A),
                ],
              ),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Image.asset(
                        e.pathImage,
                      ),
                    ),
                    const Flexible(
                      flex: 1,
                      child: SizedBox(),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        H2Text(
                          text: e.title.toUpperCase(),
                          maxLines: 2,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF033C05),
                          textAlign: TextAlign.end,
                        ),
                        H2Text(
                          text: e.description,
                          fontSize: 12,
                          color: const Color(0xFF121B4A),
                          maxLines: 20,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
