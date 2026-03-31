enum TripType {
  roundTrip('round-trip', 'Round Trip'),
  oneWay('one-way', 'One Way'),
  multiCity('multi', 'Multi-City');

  final String apiValue;
  final String label;
  const TripType(this.apiValue, this.label);
}
