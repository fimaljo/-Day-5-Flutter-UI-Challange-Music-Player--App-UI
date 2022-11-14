class Card3D {
  const Card3D(
      {required this.author, required this.title, required this.image});
  final String title;
  final String author;
  final String image;
}

const _path = 'assets/3D_card_animation';
final cardList = [
  Card3D(author: 'Troye Sivan', title: "Manavalan thug", image: '$_path/1.png'),
  Card3D(author: 'Gopi Sunder', title: "Amma Song", image: '$_path/2.png'),
  Card3D(author: 'Anirudh', title: "Vip", image: '$_path/3.png'),
  Card3D(author: 'vasi', title: "Oh My Kadavule", image: '$_path/4.png'),
  Card3D(author: 'Sivan', title: "O Sathi", image: '$_path/5.png')
];
