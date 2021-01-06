class Database {
  final items = [
    StoreItem(
        id: 1,
        name: 'Lettuce',
        image:
            'https://www.vegetables.co.nz/assets/vegetables/_resampled/FillWyI0MDAiLCIzMDAiXQ/lettuce.png',
        price: 0.89),
    StoreItem(
        id: 2,
        name: 'Tomatoes',
        image:
            'https://www.vegetables.co.nz/assets/vegetables/_resampled/FillWyI0MDAiLCIzMDAiXQ/tomatoes.png',
        price: 2.5),
    StoreItem(
        id: 3,
        name: 'Spring onions',
        image:
            'https://www.vegetables.co.nz/assets/vegetables/_resampled/FillWyI0MDAiLCIzMDAiXQ/spring-onions.png',
        price: 1.0),
    StoreItem(
        id: 4,
        name: 'Potatoes',
        image:
            'https://www.vegetables.co.nz/assets/vegetables/_resampled/FillWyI0MDAiLCIzMDAiXQ/potatoes.png',
        price: 0.99),
    StoreItem(
        id: 5,
        name: 'Cauliflower',
        image:
            'https://www.vegetables.co.nz/assets/vegetables/_resampled/FillWyI0MDAiLCIzMDAiXQ/cauliflower.png',
        price: 0.2),
    StoreItem(
        id: 6,
        name: 'Peas',
        image:
            'https://www.vegetables.co.nz/assets/vegetables/_resampled/FillWyI0MDAiLCIzMDAiXQ/peas.png',
        price: 0.5),
    StoreItem(
        id: 7,
        name: 'Sweet corn',
        image:
            'https://www.vegetables.co.nz/assets/vegetables/_resampled/FillWyI0MDAiLCIzMDAiXQ/sweet-corn.png',
        price: 0.7),
    StoreItem(
        id: 8,
        name: 'Broccoli',
        image:
            'https://www.vegetables.co.nz/assets/vegetables/_resampled/FillWyI0MDAiLCIzMDAiXQ/broccoli.png',
        price: 0.44),
    StoreItem(
        id: 9,
        name: 'Capsicums',
        image:
            'https://www.vegetables.co.nz/assets/vegetables/_resampled/FillWyI0MDAiLCIzMDAiXQ/capsicums.png',
        price: 1.2),
    StoreItem(
        id: 10,
        name: 'Eggplant',
        image:
            'https://www.vegetables.co.nz/assets/vegetables/_resampled/FillWyI0MDAiLCIzMDAiXQ/eggplant.png',
        price: 2.1),
  ];
  final orders = [
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
  Order({this.id, this.from, this.createdAt, this.items});
}

class OrderItem {
  int itemId;
  int count;
  StoreItem item;
  OrderItem({this.itemId, this.count});
}

class StoreItem {
  int id;
  String name;
  String image;
  double price;
  StoreItem({this.id, this.name, this.image, this.price});
}
