import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/search/search_delegate.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);

    return  Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Movies'),
        ),
        actions:  [
         IconButton(
             onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
             icon: const Icon(Icons.search)
         )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.onDisplayMovies,),
             MoviesSlider( movies: moviesProvider.popularMovies, title: 'Popular', onNextPage: () => moviesProvider.getPopularMovies()),
          ],
        ),
      )
    );

  }

}