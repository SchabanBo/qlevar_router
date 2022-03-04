class StorageService {
  final stores = <Store>[
    Store(
      name: 'The Serene Quest',
      products: [
        "chair",
        "stool",
        "table",
        "mug",
        "cup",
        "desk lamp",
        "floor lamp",
        " desk",
        "vase",
        "dog bed",
        "bird house",
        "action figure",
        "basket",
        "pillow",
        "rug",
        "wall tile",
        "road bike",
        "bike seat",
        "handlebars"
      ],
    ),
    Store(
      name: 'The Frozen Kite',
      products: [
        "lamp shade",
        "cutting board",
        "dresser",
        "shoe rack",
        "rocking chair",
        "usb key",
        "8 ball",
        "frying pan",
        "house numbers",
        "spice rack",
        "suitcase",
        "button",
        "ring",
        "baking tray",
        "tape dispenser",
        "flower pot",
        "canoe",
      ],
    ),
    Store(
      name: 'The Busy Peanut',
      products: [
        "wine holder",
        "skateboard",
        "calculator",
        "salt & pepper shaker",
        "coasters",
        "piggy bank",
        "headphones",
        "sculpture",
        "telephone",
        "flashlight",
        "mail sorter",
        "espresso cup",
        "glasses",
        "fork",
        "spoon",
        "knife",
        "serving tray",
        "toy train",
      ],
    ),
    Store(
      name: 'The Quiet Pot',
      products: [
        "shelf",
        "sofa",
        "tea cup",
        "tea pot",
        "cutlery",
        "chess set",
        "lounge",
        " alarm clock",
        "phone dock",
        "keyboard",
        "side table",
        "wallet",
      ],
    ),
    Store(
      name: 'The Eager Knife Dry Cleaner',
      products: [
        "playing cards",
        "fan",
        "jewelry box",
        "mouse",
        "lantern",
        "walking cane",
        "sword",
        "wall clock",
        "mirror",
        "bed",
        "crib",
        "hammock",
        "plate",
        "bowl",
        "coffee mug",
      ],
    ),
    Store(
      name: ' Pizza My Heart',
      products: [
        "drawer handle",
        "doorknob",
        "cable organizer",
        "planter pot",
        "coat hanger",
        "bottle opener",
        "can opener",
        "coasters",
        "pocket knife",
        "surfboard",
        "shoes",
        "book",
        "calendar",
      ],
    ),
  ];

  List<String> get products =>
      stores.map((store) => store.products).expand((x) => x).toList();

  bool canNavigateToChild = true;
}

class Store {
  final String name;
  final List<String> products;

  Store({
    required this.name,
    required this.products,
  });
}
