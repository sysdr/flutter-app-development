final class DiscoveryDestination{
  const DiscoveryDestination({required this.id,required this.city,required this.country,required this.iataCode,required this.tagline,required this.priceFromInr,required this.category,required this.skyColorTop,required this.skyColorBottom,this.trendingRank});
  final String id,city,country,iataCode,tagline,category;final double priceFromInr;final int skyColorTop,skyColorBottom;final int? trendingRank;
  String get formattedPrice=>'from ₹${priceFromInr.toStringAsFixed(0)}';bool get isTrending=>trendingRank!=null;
  String get accessibilityLabel=>'$city, $country. $tagline. $formattedPrice.';
  static const List<DiscoveryDestination> samples=[
    DiscoveryDestination(id:'dxb',city:'Dubai',country:'UAE',iataCode:'DXB',tagline:'City of gold',priceFromInr:18500,category:'flights',skyColorTop:0xFF1A237E,skyColorBottom:0xFFE65100,trendingRank:1),
    DiscoveryDestination(id:'sin',city:'Singapore',country:'Singapore',iataCode:'SIN',tagline:'The garden city',priceFromInr:22000,category:'both',skyColorTop:0xFF00695C,skyColorBottom:0xFF1B5E20,trendingRank:2),
    DiscoveryDestination(id:'nrt',city:'Tokyo',country:'Japan',iataCode:'NRT',tagline:'Neon and tradition',priceFromInr:38000,category:'both',skyColorTop:0xFF880E4F,skyColorBottom:0xFF4A148C,trendingRank:3),
    DiscoveryDestination(id:'bkk',city:'Bangkok',country:'Thailand',iataCode:'BKK',tagline:'Temples and flavour',priceFromInr:14500,category:'hotels',skyColorTop:0xFFE65100,skyColorBottom:0xFFBF360C),
    DiscoveryDestination(id:'cdg',city:'Paris',country:'France',iataCode:'CDG',tagline:'La ville lumière',priceFromInr:48000,category:'flights',skyColorTop:0xFF283593,skyColorBottom:0xFF1A237E),
    DiscoveryDestination(id:'lhr',city:'London',country:'UK',iataCode:'LHR',tagline:'History meets future',priceFromInr:42000,category:'flights',skyColorTop:0xFF1565C0,skyColorBottom:0xFF546E7A),
  ];
}
enum DiscoveryFilter{all,flights,hotels}
