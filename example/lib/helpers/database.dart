class Database {
  static bool canChildNavigate = true;
  static final items = [
    StoreItem(
        id: 1,
        name: 'Lettuce',
        image: 'assets/images/lettuce.png',
        price: 0.89),
    StoreItem(
        id: 2,
        name: 'Tomatoes',
        image: 'assets/images/tomatoes.png',
        price: 2.5),
    StoreItem(
        id: 3,
        name: 'Spring onions',
        image: 'assets/images/spring-onions.png',
        price: 1.0),
    StoreItem(
        id: 4,
        name: 'Potatoes',
        image: 'assets/images/potatoes.png',
        price: 0.99),
    StoreItem(
        id: 5,
        name: 'Cauliflower',
        image: 'assets/images/cauliflower.png',
        price: 0.2),
    StoreItem(id: 6, name: 'Peas', image: 'assets/images/peas.png', price: 0.5),
    StoreItem(
        id: 7,
        name: 'Sweet corn',
        image: 'assets/images/sweet-corn.png',
        price: 0.7),
    StoreItem(
        id: 8,
        name: 'Broccoli',
        image: 'assets/images/broccoli.png',
        price: 0.44),
    StoreItem(
        id: 9,
        name: 'Capsicums',
        image: 'assets/images/capsicums.png',
        price: 1.2),
    StoreItem(
        id: 10,
        name: 'Eggplant',
        image: 'assets/images/eggplant.png',
        price: 2.1),
  ];
  static final orders = [
    Order(id: 1, from: 'USA', createdAt: DateTime(2020, 5, 14), items: [
      OrderItem(itemId: 1, count: 3),
      OrderItem(itemId: 2, count: 6),
      OrderItem(itemId: 6, count: 7),
    ]),
    Order(id: 2, from: 'France', createdAt: DateTime(2020, 2, 16), items: [
      OrderItem(itemId: 7, count: 6),
      OrderItem(itemId: 3, count: 1),
      OrderItem(itemId: 8, count: 4),
      OrderItem(itemId: 1, count: 3),
    ]),
    Order(id: 3, from: 'Germany', createdAt: DateTime(2020, 4, 24), items: [
      OrderItem(itemId: 1, count: 3),
      OrderItem(itemId: 10, count: 8),
    ]),
    Order(id: 4, from: 'Home', createdAt: DateTime(2020, 8, 2), items: [
      OrderItem(itemId: 2, count: 2),
      OrderItem(itemId: 4, count: 1),
      OrderItem(itemId: 5, count: 1),
      OrderItem(itemId: 6, count: 1),
      OrderItem(itemId: 7, count: 7),
      OrderItem(itemId: 3, count: 5),
      OrderItem(itemId: 10, count: 4),
    ]),
    Order(id: 5, from: 'You', createdAt: DateTime(2020, 11, 6), items: [
      OrderItem(itemId: 3, count: 2),
      OrderItem(itemId: 1, count: 4),
      OrderItem(itemId: 3, count: 6),
      OrderItem(itemId: 6, count: 7),
      OrderItem(itemId: 5, count: 1),
    ]),
  ];

  Database() {
    fillOrdersItems();
  }

  void fillOrdersItems() {
    for (var order in orders) {
      for (var item in order.items) {
        item.item = items.firstWhere((element) => element.id == item.itemId);
      }
    }
  }
}

class Order {
  int id;
  String from;
  DateTime createdAt;
  List<OrderItem> items;
  Order({
    required this.id,
    required this.from,
    required this.createdAt,
    required this.items,
  });
}

class OrderItem {
  int itemId;
  int count;
  StoreItem? item;
  OrderItem({
    required this.itemId,
    required this.count,
  });
}

class StoreItem {
  int id;
  String name;
  String image;
  double price;
  StoreItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });
}
