class Person {
  Person({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.address,
    required this.createdat,
  });
  late final int id;
  late final String firstname;
  late final String lastname;
  late final String phone;
  late final String address;
  late final String createdat;

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    address = json['address'];
    createdat = json['createdat'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['firstname'] = firstname;
    _data['lastname'] = lastname;
    _data['phone'] = phone;
    _data['address'] = address;
    _data['createdat'] = createdat;
    return _data;
  }
}
