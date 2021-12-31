import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/helpers/debouncer.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {

  final String _apiKey = 'acff518fe288d6e9c32cb7f3955eb2ce';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-Es';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));
  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>>get suggestionStream => _suggestionStreamController.stream;


  MoviesProvider(){

    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData( String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint,
        {
          'api_key' : _apiKey,
          'language': _language,
          'page': '$page'
        });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingRes= NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingRes.results;

    notifyListeners();

  }

  getPopularMovies () async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage );
    final popularRes = PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularRes.results];

    notifyListeners();

  }

  Future<List<Cast>> getMovieCast(int movieId ) async {
    //Todo: revisar el mapa
    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsRes = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsRes.cast;

    return creditsRes.cast;
  }

  Future<List<Movie>> searchMovie(String query ) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {
          'api_key' : _apiKey,
          'language': _language,
          'query': query,
        });
    final response = await http.get(url);
    final searchRes = SearchResponse.fromJson(response.body);

    return searchRes.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final results = await searchMovie(value);
      _suggestionStreamController.add(results);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) { 
      debouncer.value = searchTerm; 
    }); 
    
    Future.delayed(const Duration(milliseconds: 301)).then(( _ )=> timer.cancel());
  }
}

