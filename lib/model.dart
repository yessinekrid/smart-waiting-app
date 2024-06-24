class queue1 {
  final int? queue1_Position;

  const queue1({
    required this.queue1_Position,
  });

  const queue1.empty({
    this.queue1_Position = 0,
  });

  factory queue1.fromJson(Map<String, dynamic> json) => queue1(
        queue1_Position: json['Queue1_Position'],
      );

  Map<String, dynamic> toJson() => {
        "Queue1_Position": queue1_Position,
      };
}
