import 'package:flutter/material.dart';

void main() {
  runApp(const CocktailApp());
}

class CocktailApp extends StatelessWidget {
  const CocktailApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktail Paradise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Raleway',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
          titleLarge: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black54),
        ),
      ),
      home: const CocktailHomePage(),
    );
  }
}

class CocktailHomePage extends StatelessWidget {
  const CocktailHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Cocktail Paradise',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              background: Image.network(
                'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Beliebte Cocktails',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return CocktailCard(
                      cocktail:
                          sampleCocktails[index % sampleCocktails.length]);
                },
                childCount: sampleCocktails.length,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24.0),
                  Text('Cocktail des Tages',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16.0),
                  FeaturedCocktailCard(cocktail: sampleCocktails[0]),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Suche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoriten',
          ),
        ],
      ),
    );
  }
}

class Cocktail {
  final String name;
  final String imageUrl;
  final String description;
  final List<String> ingredients;
  final String preparation;
  final double rating;

  Cocktail({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.preparation,
    required this.rating,
  });
}

class CocktailCard extends StatelessWidget {
  final Cocktail cocktail;

  const CocktailCard({Key? key, required this.cocktail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CocktailDetailPage(cocktail: cocktail),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Hero(
                tag: 'cocktail-image-${cocktail.name}',
                child: Image.network(
                  cocktail.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cocktail.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < cocktail.rating.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      cocktail.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedCocktailCard extends StatelessWidget {
  final Cocktail cocktail;

  const FeaturedCocktailCard({Key? key, required this.cocktail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CocktailDetailPage(cocktail: cocktail),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'featured-${cocktail.name}',
                    child: Image.network(
                      cocktail.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cocktail.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < cocktail.rating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beschreibung',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    cocktail.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Probier ihn noch heute!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CocktailDetailPage extends StatelessWidget {
  final Cocktail cocktail;

  const CocktailDetailPage({Key? key, required this.cocktail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                cocktail.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              background: Hero(
                tag: 'cocktail-image-${cocktail.name}',
                child: Image.network(
                  cocktail.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < cocktail.rating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '${cocktail.rating}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Beschreibung',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      cocktail.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'Zutaten',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8.0),
                    ...cocktail.ingredients.map((ingredient) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.fiber_manual_record,
                                size: 12.0, color: Colors.amber),
                            const SizedBox(width: 8.0),
                            Text(
                              ingredient,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 24.0),
                    Text(
                      'Zubereitung',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      cocktail.preparation,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.amber,
        child: const Icon(Icons.favorite_border),
      ),
    );
  }
}

// Beispiel-Cocktails
final List<Cocktail> sampleCocktails = [
  Cocktail(
    name: 'Mojito',
    imageUrl:
        'https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg',
    description:
        'Ein erfrischender kubanischer Cocktail mit Minze, Limette und Rum.',
    ingredients: [
      '60ml weißer Rum',
      '30ml frischer Limettensaft',
      '2 TL Zucker',
      '6-8 Minzblätter',
      'Sodawasser',
      'Limettenscheiben und Minze zur Garnierung'
    ],
    preparation:
        'Die Minzblätter leicht andrücken und in ein Glas geben. Limettensaft und Zucker hinzufügen und umrühren, bis der Zucker gelöst ist. Das Glas mit Eis füllen, Rum hinzufügen und mit Sodawasser auffüllen. Mit Limettenscheiben und Minze garnieren.',
    rating: 4.8,
  ),
  Cocktail(
    name: 'Margarita',
    imageUrl:
        'https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg',
    description:
        'Ein klassischer mexikanischer Cocktail mit Tequila, Limette und Triple Sec.',
    ingredients: [
      '50ml Tequila',
      '25ml Triple Sec',
      '25ml frischer Limettensaft',
      'Salzrand (optional)',
      'Limettenscheibe zur Garnierung'
    ],
    preparation:
        'Falls gewünscht, den Rand des Glases mit Salz versehen. Alle Zutaten mit Eis in einen Shaker geben und gut schütteln. In ein mit Eis gefülltes Glas abseihen. Mit einer Limettenscheibe garnieren.',
    rating: 4.5,
  ),
  Cocktail(
    name: 'Piña Colada',
    imageUrl:
        'https://www.thecocktaildb.com/images/media/drink/cpf4j51504371346.jpg',
    description:
        'Ein cremiger Cocktail aus Puerto Rico mit Rum, Kokosnusscreme und Ananas.',
    ingredients: [
      '60ml weißer Rum',
      '90ml Ananassaft',
      '30ml Kokosnusscreme',
      'Ananasscheibe zur Garnierung'
    ],
    preparation:
        'Alle Zutaten mit Eis in einen Mixer geben und cremig mixen. In ein Glas gießen und mit einer Ananasscheibe garnieren.',
    rating: 4.6,
  ),
  Cocktail(
    name: 'Old Fashioned',
    imageUrl:
        'https://www.thecocktaildb.com/images/media/drink/vrwquq1478252802.jpg',
    description: 'Ein klassischer Whiskey-Cocktail mit Bitter und Zucker.',
    ingredients: [
      '60ml Bourbon oder Rye Whiskey',
      '1 Zuckerwürfel oder 1 TL Zucker',
      '2-3 Spritzer Angostura Bitter',
      'Orangenschale',
      'Maraschino-Kirsche (optional)'
    ],
    preparation:
        'Den Zuckerwürfel in ein Glas geben und mit Bitter tränken. Ein paar Tropfen Wasser hinzufügen und umrühren, bis der Zucker gelöst ist. Eis ins Glas geben, Whiskey hinzufügen und umrühren. Mit Orangenschale und optional einer Kirsche garnieren.',
    rating: 4.7,
  ),
  Cocktail(
    name: 'Cosmopolitan',
    imageUrl:
        'https://www.thecocktaildb.com/images/media/drink/kpsajh1504368362.jpg',
    description: 'Ein eleganter Cocktail mit Wodka, Cranberrysaft und Limette.',
    ingredients: [
      '45ml Zitronenwodka',
      '15ml Triple Sec',
      '15ml frischer Limettensaft',
      '30ml Cranberrysaft',
      'Limettenscheibe zur Garnierung'
    ],
    preparation:
        'Alle Zutaten mit Eis in einen Shaker geben und gut schütteln. In ein Martiniglas abseihen. Mit einer Limettenscheibe garnieren.',
    rating: 4.4,
  ),
  Cocktail(
    name: 'Daiquiri',
    imageUrl:
        'https://www.thecocktaildb.com/images/media/drink/mrz9091589574515.jpg',
    description:
        'Ein einfacher, aber eleganter kubanischer Cocktail mit Rum und Limette.',
    ingredients: [
      '60ml weißer Rum',
      '30ml frischer Limettensaft',
      '2 TL Zucker',
      'Limettenscheibe zur Garnierung'
    ],
    preparation:
        'Alle Zutaten mit Eis in einen Shaker geben und gut schütteln. In ein gekühltes Cocktailglas abseihen. Mit einer Limettenscheibe garnieren.',
    rating: 4.3,
  ),
];
