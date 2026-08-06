enum SegmentedControlItem {
  all('home.filters.all'),
  signed('home.filters.signed'),
  unsigned('home.filters.unsigned');

  const SegmentedControlItem(this.localizationKey);

  final String localizationKey;
}
