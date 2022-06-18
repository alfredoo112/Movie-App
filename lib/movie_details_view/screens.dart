import 'package:flutter/material.dart';

import 'controllers.dart';
import 'model_data.dart';


class MovieDetailsScreen extends StatelessWidget {
  final int id;

  MovieDetailsScreen({Key? key, required this.id}) : super(key: key);

  final controller = MovieDetailsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: controller.getData(id: id),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const CircularProgressIndicator();
            }
            var model = snapshot.data as MovieDetailsModel;
            return Column(
              children: [
                Image.network("https://image.tmdb.org/t/p/original" +
                    model.posterPath),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(model.overview,textAlign: TextAlign.center,),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}