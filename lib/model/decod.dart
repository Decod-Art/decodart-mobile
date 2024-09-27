import 'package:decodart/model/abstract_item.dart' show AbstractItem, UnnamedAbstractItem;
import 'package:decodart/model/artwork.dart' show ArtworkForeignKey;
import 'package:decodart/model/image.dart' show AbstractImage, ImageWithPath;

import 'dart:math';


enum DecodQuestionType {
  image,
  text,
  boundingbox
}

class DecodQuestionListItem extends AbstractItem {
  final AbstractImage image;
  const DecodQuestionListItem({
    super.uid,
    required super.name,
    required this.image
  });

  factory DecodQuestionListItem.fromJson(Map<String, dynamic> json) {
    return DecodQuestionListItem(
      uid: json['uid'],
      name: json['name'],
      image: ImageWithPath.fromJson(json['image']));
  }
  @override
  Map<String, dynamic> toJson(){
    return {
      ...super.toJson(),
      'image': image.toJson()
    };
  }
}

class DecodQuestion extends DecodQuestionListItem {
  final String question;
  final DecodQuestionType questionType;
  final List<DecodAnswer> answers;
  final bool showImage;
  final ArtworkForeignKey? artwork;
  const DecodQuestion({
    super.uid,
    required super.name,
    required super.image,
    required this.question,
    required this.questionType,
    required this.answers,
    required this.showImage,
    this.artwork
  });

  factory DecodQuestion.fromJson(Map<String, dynamic>json) {
    return DecodQuestion(
      uid: json['uid'],
      name: json['name'],
      image: ImageWithPath.fromJson(json['image']),
      question: json['question'],
      questionType: DecodQuestionType.values.firstWhere((e) => e.toString().split('.').last == json['question_type']),
      answers: (json['answers'] as List).map((item)=>DecodAnswer.fromJson(item)).toList(),
      showImage: json['showimage'],
      artwork: json['artwork']!=null?ArtworkForeignKey.fromJson(json['artwork']):null
    );
  }

  DecodAnswer? get correctAnswer {
    DecodAnswer? answer;
    int i = 0;
    while (i< answers.length && answer == null) {
      if (answers[i].isCorrect){
        answer = answers[i];
      }
      i++;
    }
    return answer;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'question': question,
      'question_type': questionType.toString().split('.').last,
      'answers': answers.map((item) => item.toJson()).toList(),
      'showimage': showImage,
      if (artwork != null)
        'artwork': artwork!.toJson()
    };
  }

  DecodQuestion shuffleAnswers() {
    List<DecodAnswer> shuffledAnswers = List.from(answers);
    shuffledAnswers.shuffle(Random());
    return DecodQuestion(
      uid: uid,
      name: name,
      image: image,
      question: question,
      questionType: questionType,
      answers: shuffledAnswers,
      showImage: showImage,
      artwork: artwork,
    );
  }
}

class DecodAnswer extends UnnamedAbstractItem {
  final AbstractImage? image;
  final String? text;
  final bool isCorrect;
  const DecodAnswer({
    super.uid,
    this.image,
    this.text,
    this.isCorrect = true
  });
  factory DecodAnswer.fromJson(Map<String, dynamic>json) {
    return DecodAnswer(
      uid: json['uid'],
      image: json['image']!=null?ImageWithPath.fromJson(json['image']):null,
      text: json['text'],
      isCorrect: json['iscorrect']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      if (image != null)
        'image': image!.toJson(),
      if (text != null)
        'text': text,
      'iscorrect': isCorrect
    };
  }
}

class DecodTag extends UnnamedAbstractItem {
  final String name;
  const DecodTag({
    super.uid,
    required this.name,
  });

  factory DecodTag.fromJson(Map<String, dynamic> json) {
    return DecodTag(
      uid: json['uid'],
      name: json['name']
    );
  }


}