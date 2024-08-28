import 'package:decodart/model/decod.dart' show DecodQuestion;
import 'package:flutter/cupertino.dart';

typedef OnQuestionOver = void Function(double);

abstract class AbstractQuestionWidget extends StatefulWidget {
  final OnQuestionOver submitPoints;//add the number of points gained
  final DecodQuestion question;

  const AbstractQuestionWidget({
    super.key,
    required this.submitPoints,
    required this.question
    });
}