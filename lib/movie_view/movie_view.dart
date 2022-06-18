import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/movie_details_view/screens.dart';
import 'controller.dart';
import 'model.dart';

class  MoviesScreen extends StatelessWidget {
  MoviesScreen({Key? key}) : super(key: key);

  // final controller = MoviesController();
  String initialValueText = "Action";
  int genre = 28;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesController(),
      child: Builder(builder: (context) {
        final controller = MoviesController.getObject(context);
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                FutureBuilder(
                  future: controller.getGeneresData(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const CircularProgressIndicator();
                    }
                    var model = snapshot.data as MovieGenres;
                    return DropdownButton<String>(
                        value: initialValueText,
                        items: List.generate(
                            model.genres.length,
                                (index) => DropdownMenuItem(
                              value: model.genres[index].name,
                              onTap: () {
                                genre = model.genres[index].id;
                                // setState(() {});
                              },
                              child: Text(model.genres[index].name),
                            )),
                        onChanged: (val) {
                          initialValueText = val!;
                          // setState(() {});
                        });
                  },
                ),
                // Image.network CachedImageNetwork
                // NetworkImage
                Expanded(
                  child: FutureBuilder(
                    future: controller.getData(genre: genre),
                    builder: (context, snap) {
                      if (snap.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        var model = snap.data as MyMoviesDetails;
                        return ListView.builder(
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              print(model.results[index].id.toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailsScreen(
                                        id: model.results[index].id),
                                  ));
                            },
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              height: 250,
                              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                // color: Colors.black
                              ),
                              child: Stack(
                                children: [
                                  InteractiveViewer(
                                    onInteractionEnd: (c) {},
                                    child: CachedNetworkImage(
                                      imageUrl: "https://image.tmdb.org/t/p/original" + model.results[index].backdropPath,
                                      height: 250,
                                      fit: BoxFit.fill,
                                      progressIndicatorBuilder: (context,url,progress){
                                        if(progress.progress!=null)
                                        {
                                          //  double present = progress.progress!*100;
                                          return Center(child: LinearProgressIndicator(value: progress.progress!,));
                                        }else
                                        {
                                          return const Center(child:  Text("Image Loaded"));
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black.withOpacity(.8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          model.results[index].voteAverage
                                              .toString(),
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Align(
                                  //   alignment: Alignment.topRight,
                                  //   child: Container(
                                  //     color: Colors.black,
                                  //       margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  //       child: Text(
                                  //     "Popularity  ${model.results[index].popularity}",
                                  //     style: TextStyle(
                                  //         color: Colors.white, fontSize: 20),
                                  //   )),
                                  // ),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                          padding: const EdgeInsets.all(8),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(.8),
                                          ),
                                          child: Text(
                                            model.results[index].title.length > 20
                                                ? model.results[index].title
                                                .substring(0, 20)
                                                : model.results[index].title,
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 25),
                                            textAlign: TextAlign.center,
                                          ))),
                                ],
                              ),
                            ),
                          ),
                          itemCount: model.results.length,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}