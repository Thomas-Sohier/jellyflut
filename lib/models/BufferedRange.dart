class BufferedRange {
  BufferedRange({
    this.start,
    this.end,
  });

  int start;
  int end;

  factory BufferedRange.fromJson(Map<String, dynamic> json) => BufferedRange(
        start: json['start'],
        end: json['end'],
      );

  Map<String, dynamic> toJson() => {
        'start': start,
        'end': end,
      };
}
