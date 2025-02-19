import 'package:flutter/material.dart';
import 'package:pokemondex/pokemondetail/views/pokemondetail_view.dart';
import 'package:pokemondex/pokemonlist/models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  List<PokemonListItem> _pokemonList = [];
  String? _nextPageUrl = 'https://pokeapi.co/api/v2/pokemon';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (_isLoading || _nextPageUrl == null) return;
    setState(() => _isLoading = true);
    
    final response = await http.get(Uri.parse(_nextPageUrl!));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final data = PokemonListResponse.fromJson(jsonData);
      setState(() {
        _pokemonList.addAll(data.results);
        _nextPageUrl = data.next;
      });
    }
    setState(() => _isLoading = false);
  }

  String getPokemonImageUrl(String url) {
    final id = url.split('/')[url.split('/').length - 2];
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: _pokemonList.length + 1,
        itemBuilder: (context, index) {
          if (index == _pokemonList.length) {
            return _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: loadData,
                    child: const Text('Load More'));
          }
          final pokemon = _pokemonList[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokemondetailView(pokemonListItem: pokemon),
              ),
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(getPokemonImageUrl(pokemon.url), height: 200),
                  Text(pokemon.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
