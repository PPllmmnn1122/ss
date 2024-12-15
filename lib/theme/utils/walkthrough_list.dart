import 'package:nb_utils/nb_utils.dart';

List<WalkThroughModelClass> walkThroughList() {
  List<WalkThroughModelClass> tempList = [];
  tempList.add(
    WalkThroughModelClass(
      title: 'مرحبًا بك في ConnectAble!',
      subTitle: 'تمكين التواصل للجميع، في كل مكان.',
      image: 'images/walkthrough_images/walkthrough_intro.png', // تأكد من إضافة صورة مناسبة في موارد التطبيق
    ),
  );
  tempList.add(
    WalkThroughModelClass(
      title: 'التواصل أصبح أسهل',
      subTitle: 'استكشف الأدوات المصممة خصيصًا لمجتمعات الصم والبكم والمكفوفين.',
      image: 'images/walkthrough_images/walkthrough_features.png', // تأكد من إضافة صورة مناسبة في موارد التطبيق
    ),
  );
  tempList.add(
    WalkThroughModelClass(
      title: 'انضم إلى مجتمعنا',
      subTitle: 'تواصل مع أشخاص يفهمونك ويشاركونك تجاربك.',
      image: 'images/walkthrough_images/walkthrough_community.png', // تأكد من إضافة صورة مناسبة في موارد التطبيق
    ),
  );
  return tempList;
}
