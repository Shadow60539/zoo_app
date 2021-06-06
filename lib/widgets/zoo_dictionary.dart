class ZooDictionary {
  final String name;
  final String description;
  final String height;
  final String weight;
  final String lifeSpan;

  const ZooDictionary(
      {this.name, this.description, this.height, this.weight, this.lifeSpan});
}

Map<String, ZooDictionary> zooDictionaryMap = {
  'panda': const ZooDictionary(
      name: 'Giant Panda 🐼',
      description:
          'Giant panda, (Ailuropoda melanoleuca), also called panda bear, bearlike mammal inhabiting bamboo forests in the mountains of central China.',
      height: '60 – 90 cm',
      weight: '70 – 120 kg',
      lifeSpan: '20 years'),
  'sloth': const ZooDictionary(
      name: 'Sloth 🦥',
      description:
          'Sloths are a group of arboreal Neotropical xenarthran mammals, constituting the suborder Folivora. Noted for their slowness of movement, they spend most of their lives hanging upside down in the trees of the tropical rainforests of South America and Central America.',
      height: '60 - 80 cm',
      weight: '3.6 - 7.7 kg',
      lifeSpan: '20 years'),
  'elephant': const ZooDictionary(
      name: 'Elephant 🐘',
      description:
          'Elephants are the largest existing land animals. Three species are currently recognised: the African bush elephant, the African forest elephant, and the Asian elephant.',
      height: '304 – 336 cm',
      weight: '1,800 and 6,300 kg',
      lifeSpan: '48 years'),
  'fox': const ZooDictionary(
      name: 'Fox 🦊',
      description:
          'Foxes are small to medium-sized, omnivorous mammals belonging to several genera of the family Canidae. They have a flattened skull, upright triangular ears, a pointed, slightly upturned snout, and a long bushy tail.',
      height: '35 – 50 cm',
      weight: '2.2 - 14 kg',
      lifeSpan: '2 – 6 years'),
  'reindeer': const ZooDictionary(
      name: 'Reindeer 🦌',
      description:
          'The reindeer, also known as caribou in North America, is a species of deer with circumpolar distribution, native to Arctic.',
      height: '85 – 150 cm',
      weight: '160 - 180 kg',
      lifeSpan: '15 – 20 years'),
  'dolphin': const ZooDictionary(
      name: 'Dolphin 🐬',
      description:
          'Dolphin is the common name of aquatic mammals within the infraorder Cetacea. The term dolphin usually refers to the extant families Delphinidae, Platanistidae, named Iniidae, and Pontoporiidae, and the extinct Lipotidae',
      height: '64 - 89 cm',
      weight: '150 - 200 kg',
      lifeSpan: '10 – 45 years'),
  'tortoise': const ZooDictionary(
      name: 'Tortoise 🐢',
      description:
          'Tortoises are reptile species of the family Testudinidae of the order Testudines. They are particularly distinguished from other turtles by being exclusively land-dwelling, while many other turtle species are at least partly aquatic.',
      height: '69 - 91 cm',
      weight: '9 - 11 pounds',
      lifeSpan: '10 – 200 years'),
  'cat': const ZooDictionary(
      name: 'Cat 😸',
      description:
          'The cat is a domestic species of small carnivorous mammal. It is the only domesticated species in the family Felidae and is often referred to as the domestic cat to distinguish it from the wild members of the family.',
      height: '23 – 25 cm',
      weight: '3.6 – 4.5 kg',
      lifeSpan: '2 – 16 years'),
};

Map<int, String> animalsEmojiMapper = {
  1: '🐼',
  2: '🦥',
  3: '😸',
  4: '🐢',
  5: '🐘',
  6: '🦊',
  7: '🐬',
  8: '🦌',
};
