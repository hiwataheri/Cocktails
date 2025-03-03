import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

class CocktailHomePage extends StatefulWidget {
  const CocktailHomePage({Key? key}) : super(key: key);

  @override
  State<CocktailHomePage> createState() => _CocktailHomePageState();
}

class _CocktailHomePageState extends State<CocktailHomePage> {
  List<Cocktail> popularCocktails = [];
  Cocktail? featuredCocktail;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCocktails();
  }

  Future<void> fetchCocktails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Lade beliebte Cocktails (alphabetisch geordnet)
      final popularResponse = await http.get(
        Uri.parse(
            'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail'),
      );

      if (popularResponse.statusCode != 200) {
        throw Exception(
            'Fehler beim Laden der Cocktails: ${popularResponse.statusCode}');
      }

      final popularData = json.decode(popularResponse.body);
      final cocktailList = popularData['drinks'] as List;

      // Lade Details für jeden Cocktail
      List<Cocktail> fullCocktails = [];

      // Begrenze auf maximal 10 Cocktails für bessere Performance
      final limitedList = cocktailList.take(10).toList();

      for (var item in limitedList) {
        final detailResponse = await http.get(
          Uri.parse(
              'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${item['idDrink']}'),
        );

        if (detailResponse.statusCode == 200) {
          final detailData = json.decode(detailResponse.body);
          final drinkData = detailData['drinks'][0];

          fullCocktails.add(Cocktail.fromJson(drinkData));
        }
      }

      // Lade einen zufälligen Cocktail als "Cocktail des Tages"
      final randomResponse = await http.get(
        Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'),
      );

      if (randomResponse.statusCode == 200) {
        final randomData = json.decode(randomResponse.body);
        final featuredData = randomData['drinks'][0];

        setState(() {
          popularCocktails = fullCocktails;
          featuredCocktail = Cocktail.fromJson(featuredData);
          isLoading = false;
        });
      } else {
        throw Exception('Fehler beim Laden des Cocktail des Tages');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Fehler beim Laden der Daten: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : errorMessage != null
              ? Center(
                  child: Text(errorMessage!,
                      style: Theme.of(context).textTheme.titleLarge))
              : RefreshIndicator(
                  onRefresh: fetchCocktails,
                  color: Colors.amber,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 200.0,
                        floating: false,
                        pinned: true,
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: fetchCocktails,
                          ),
                        ],
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 0.75,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return CocktailCard(
                                  cocktail: popularCocktails[index]);
                            },
                            childCount: popularCocktails.length,
                          ),
                        ),
                      ),
                      if (featuredCocktail != null)
                        SliverPadding(
                          padding: const EdgeInsets.all(16.0),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24.0),
                                Text('Cocktail des Tages',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                const SizedBox(height: 16.0),
                                FeaturedCocktailCard(
                                    cocktail: featuredCocktail!),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
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
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final List<String> ingredients;
  final String preparation;
  final double rating;
  final String category;
  final String alcoholic;
  final String glassType;

  Cocktail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.preparation,
    required this.rating,
    required this.category,
    required this.alcoholic,
    required this.glassType,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    // Sammle alle Zutaten (nicht null)
    List<String> ingredientsList = [];
    for (int i = 1; i <= 15; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        if (measure != null && measure.toString().trim().isNotEmpty) {
          ingredientsList.add('$measure $ingredient');
        } else {
          ingredientsList.add(ingredient);
        }
      }
    }

    // Erzeuge eine zufällige Bewertung zwischen 3.8 und 5.0
    final rating =
        3.8 + (1.2 * (DateTime.now().millisecondsSinceEpoch % 100) / 100);

    return Cocktail(
      id: json['idDrink'] ?? '',
      name: json['strDrink'] ?? 'Unbekannter Cocktail',
      imageUrl: json['strDrinkThumb'] ??
          'https://www.thecocktaildb.com/images/media/drink/vrwquq1478252802.jpg',
      description: json['strInstructions'] ??
          json['strInstructionsDE'] ??
          'Keine Beschreibung verfügbar.',
      ingredients: ingredientsList,
      preparation: json['strInstructions'] ??
          json['strInstructionsDE'] ??
          'Keine Zubereitungsanleitung verfügbar.',
      rating: rating,
      category: json['strCategory'] ?? 'Cocktail',
      alcoholic: json['strAlcoholic'] ?? 'Unbekannt',
      glassType: json['strGlass'] ?? 'Cocktailglas',
    );
  }
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
                tag: 'cocktail-image-${cocktail.id}',
                child: Image.network(
                  cocktail.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.error, color: Colors.red),
                    );
                  },
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
                      cocktail.category,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      cocktail.alcoholic,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
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
                    tag: 'featured-${cocktail.id}',
                    child: Image.network(
                      cocktail.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.error, color: Colors.red),
                        );
                      },
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
                    'Kategorie: ${cocktail.category}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    cocktail.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CocktailDetailPage(cocktail: cocktail),
                        ),
                      );
                    },
                    icon: const Icon(Icons.local_bar),
                    label: const Text('Probier ihn noch heute!'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                    ),
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
                tag: 'cocktail-image-${cocktail.id}',
                child: Image.network(
                  cocktail.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child:
                          const Icon(Icons.error, color: Colors.red, size: 50),
                    );
                  },
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
                    // Kategorie und Info
                    Wrap(
                      spacing: 8.0,
                      children: [
                        Chip(
                          label: Text(cocktail.category),
                          backgroundColor: Colors.amber.shade100,
                          avatar:
                              const Icon(Icons.category, color: Colors.amber),
                        ),
                        Chip(
                          label: Text(cocktail.alcoholic),
                          backgroundColor: Colors.amber.shade100,
                          avatar:
                              const Icon(Icons.local_bar, color: Colors.amber),
                        ),
                        Chip(
                          label: Text(cocktail.glassType),
                          backgroundColor: Colors.amber.shade100,
                          avatar:
                              const Icon(Icons.wine_bar, color: Colors.amber),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),

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
                          '${cocktail.rating.toStringAsFixed(1)}',
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
                            Expanded(
                              child: Text(
                                ingredient,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
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
