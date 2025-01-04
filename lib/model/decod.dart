import 'package:decodart/model/abstract_item.dart' show AbstractItem, UnnamedAbstractItem;
import 'package:decodart/model/artwork.dart' show ArtworkForeignKey;
import 'package:decodart/model/image.dart' show ImageOnline;

import 'dart:math';


enum DecodQuestionType {
  image,
  text,
  boundingbox
}

// DecodQuestion are handled differently for ListItems elements
// Thus, it does not implements AbstractListItem as it does not
// contain a subtitle getter/attribute
class DecodQuestionListItem extends AbstractItem {
  final ImageOnline image;
  const DecodQuestionListItem({
    super.uid,
    required super.name,
    required this.image
  });

  factory DecodQuestionListItem.fromJson(Map<String, dynamic> json) => DecodQuestionListItem(
    uid: json['uid'],
    name: json['name'],
    image: ImageOnline.fromJson(json['image'])
  );

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'image': image.toJson()};
}

class DecodQuestion extends DecodQuestionListItem {
  final String question;
  final DecodQuestionType questionType;
  final List<DecodAnswer> answers;
  final bool showImage;
  final ArtworkForeignKey? artwork;
  final List<DecodTag> tags;
  const DecodQuestion({
    super.uid,
    required super.name,
    required super.image,
    required this.question,
    required this.questionType,
    required this.answers,
    required this.showImage,
    this.artwork,
    required this.tags
  });

  factory DecodQuestion.fromJson(Map<String, dynamic>json) => DecodQuestion(
    uid: json['uid'],
    name: json['name'],
    image: ImageOnline.fromJson(json['image']),
    question: json['question'],
    questionType: DecodQuestionType.values.firstWhere((e) => e.toString().split('.').last == json['question_type']),
    answers: (json['answers'] as List).map((item)=>DecodAnswer.fromJson(item)).toList(),
    showImage: json['showimage'],
    artwork: json['artwork']!=null?ArtworkForeignKey.fromJson(json['artwork']):null,
    tags: (json['tags'] as List).map((item) => DecodTag.fromJson(item)).toList()
  );

  DecodAnswer? get correctAnswer {
    DecodAnswer? answer;
    for (int i = 0 ; i < answers.length && answer == null ; i++) {
      if (answers[i].isCorrect){
        answer = answers[i];
      }
    }
    return answer;
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'question': question,
    'question_type': questionType.toString().split('.').last,
    'answers': answers.map((item) => item.toJson()).toList(),
    'showimage': showImage,
    if (artwork != null) 'artwork': artwork!.toJson(),
    'tags': tags.map((item) => item.toJson()).toList()
  };

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
      tags: tags
    );
  }
}

class DecodAnswer extends UnnamedAbstractItem {
  final ImageOnline? image;
  final String? text;
  final bool isCorrect;
  const DecodAnswer({
    super.uid,
    this.image,
    this.text,
    this.isCorrect = true
  });
  factory DecodAnswer.fromJson(Map<String, dynamic>json) => DecodAnswer(
    uid: json['uid'],
    image: json['image']!=null?ImageOnline.fromJson(json['image']):null,
    text: json['text'],
    isCorrect: json['iscorrect']
  );

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    if (image != null) 'image': image!.toJson(),
    if (text != null) 'text': text,
    'iscorrect': isCorrect
  };
}

class DecodTag extends UnnamedAbstractItem {
  final String name;
  const DecodTag({super.uid, required this.name});

  factory DecodTag.fromJson(Map<String, dynamic> json) => DecodTag(
    uid: json['uid'],
    name: json['name']
  );
}
