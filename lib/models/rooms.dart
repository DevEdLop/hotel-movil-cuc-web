class Room {
  final String roomId;
  final String roomNumber;
  final String imageRoom;
  final String descriptionRoom;
  final String typeRoom;
  final String capacityRoom;
  final String priceRoom;
  // Agrega más campos según tu modelo Django

  Room({
    required this.roomId,
    required this.roomNumber,
    required this.imageRoom,
    required this.descriptionRoom,
    required this.typeRoom,
    required this.capacityRoom,
    required this.priceRoom,
    // Incluye más campos aquí
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['id'].toString(),
      roomNumber: json['room_number'],
      typeRoom: json['room_type'],
      descriptionRoom: json['room_description'],
      capacityRoom: json['capacity'].toString(),
      priceRoom: json['price'],
      imageRoom:
          'https://st3.idealista.com/news/archivos/styles/fullwidth_xl/public/2018-08/suite-princesse-grace-3.jpg?VersionId=4GORgqRZX0hbzXsr3j7zn8Dn580DRqLn&itok=hoDo8M8x',
      // Incluye más campos aquí según tu modelo Django
    );
  }
}