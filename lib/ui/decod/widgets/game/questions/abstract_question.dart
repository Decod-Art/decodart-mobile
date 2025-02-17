import 'package:decodart/data/model/decod.dart' show DecodQuestion;
import 'package:flutter/cupertino.dart';

/// A typedef for a callback function that is called when a question is over.
/// The callback receives a [double] representing the points gained.
typedef OnQuestionOver = void Function(double);

/// An abstract class that represents a question widget in the Decod game.
/// 
/// The `AbstractQuestionWidget` is a stateful widget that serves as a base class for different types of question widgets.
/// It contains the common properties and methods required for handling questions in the game.
/// 
/// Attributes:
/// 
/// - `submitPoints` (required): An [OnQuestionOver] callback that is called when the question is over, with the number of points gained.
/// - `question` (required): A [DecodQuestion] object representing the question details.
abstract class AbstractQuestionWidget extends StatefulWidget {
  final OnQuestionOver submitPoints; // Callback to submit the number of points gained
  final DecodQuestion question; // The question details

  const AbstractQuestionWidget({super.key, required this.submitPoints, required this.question});
}