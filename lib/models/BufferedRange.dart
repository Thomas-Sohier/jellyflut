class BufferedRange {
  BufferedRange({
    this.start,
    this.end,
  });

  int start;
  int end;

  factory BufferedRange.fromJson(Map<String, dynamic> json) => BufferedRange(
        start: json['start'] == null ? null : json['start'],
        end: json['end'] == null ? null : json['end'],
      );

  Map<String, dynamic> toJson() => {
        'start': start == null ? null : start,
        'end': end == null ? null : end,
      };
}
