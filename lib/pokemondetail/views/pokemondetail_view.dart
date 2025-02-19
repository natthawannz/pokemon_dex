import 'package:flutter/material.dart';
import 'package:pokemondex/pokemonlist/models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemondetailView extends StatefulWidget {
  final PokemonListItem pokemonListItem;
  const PokemondetailView({Key? key, required this.pokemonListItem}) : super(key: key);

  @override
  State<PokemondetailView> createState() => _PokemondetailViewState();
}

class _PokemondetailViewState extends State<PokemondetailView> {
  Map<String, dynamic>? _pokemonData;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final id = widget.pokemonListItem.url.split('/')[6];
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id/'));
    if (response.statusCode == 200) {
      setState(() {
        _pokemonData = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemonListItem.name),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: _pokemonData == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(_pokemonData!['sprites']['other']['official-artwork']['front_default'], height: 350),
                    Text(widget.pokemonListItem.name, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Type: ${_pokemonData!['types'].map((t) => t['type']['name']).join(', ')}', style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 10),
                    Text('HP: ${_pokemonData!['stats'][0]['base_stat']}', style: const TextStyle(fontSize: 28)),
                    Text('Attack: ${_pokemonData!['stats'][1]['base_stat']}', style: const TextStyle(fontSize: 28)),
                    Text('Defense: ${_pokemonData!['stats'][2]['base_stat']}', style: const TextStyle(fontSize: 28)),
                  ],
                ),
              ),
            ),
    );
  }
}
