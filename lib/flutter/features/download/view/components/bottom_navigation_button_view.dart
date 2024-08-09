import 'package:flutter/material.dart';
import 'package:perfect_corp_homework/flutter/features/image_presentation/view/pages/history_view.dart';

class BottomNavigationButtonView extends StatelessWidget {
  const BottomNavigationButtonView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, HistoryView.id);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
        width: double.infinity,
        color: Colors.black,
        child: const Center(
            child: Text(
          'Go to History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}
