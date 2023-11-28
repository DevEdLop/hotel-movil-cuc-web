class Booking {
  final String ID;
  final String CUSTOMER;
  final String ROOM;
  final String BOOKING_NUMBER;
  final String CHECK_IN_DATE;
  final String CHECK_OUT_DATE;
  final String NUMBER_OF_NIGHTS;
  final String TOTAL_PRICE;

  Booking({
    required this.ID,
    required this.CUSTOMER,
    required this.ROOM,
    required this.BOOKING_NUMBER,
    required this.CHECK_IN_DATE,
    required this.CHECK_OUT_DATE,
    required this.NUMBER_OF_NIGHTS,
    required this.TOTAL_PRICE,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      ID: json['id'].toString(),
      CUSTOMER: json['customer'].toString(),
      ROOM: json['room'].toString(),
      BOOKING_NUMBER: json['booking_number'],
      CHECK_IN_DATE: json['check_in_date'],
      CHECK_OUT_DATE: json['check_out_date'],
      NUMBER_OF_NIGHTS: json['number_of_nights'].toString(),
      TOTAL_PRICE: json['total_price'].toString(),
    );
  }
}
