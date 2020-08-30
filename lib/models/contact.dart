class Contact {
  static const tblContact = 'contacts';
  static const colId = 'id';
  static const colName = 'name';
  static const colMobile = 'mobile';

  Contact({this.id, this.name, this.mobile});

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    mobile = map[colMobile];
  }

  int id;
  String name;
  String mobile;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'name': name, 'mobile': mobile};
    if (id != null) map[colId] = id;
    return map;
  }
}
