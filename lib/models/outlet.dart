class Outlet {
  final String id;
  final String name;
  final String address;
  final String image;
  final int outletSells;
  final String createdAt;

  Outlet({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.outletSells,
    required this.createdAt,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      image: json['image'],
      outletSells: json['outlet_sells'],
      createdAt: json['created_at'],
    );
  }
}
