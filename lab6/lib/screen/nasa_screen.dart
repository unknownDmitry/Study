import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:lab6/screen/cubit/nasa_cubit.dart';
import 'package:lab6/screen/cubit/nasa_state.dart';

class NasaScreen extends StatelessWidget {
  const NasaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Савин Д.Н. Curiosity Rover - Sol 130')),
      body: BlocBuilder<NasaCubit, NasaState>(
        builder: (context, state) {
          // Состояние загрузки
          if (state is NasaLoadingState) {
            // Вызываем метод loadData() и показываем индикатор загрузки
            BlocProvider.of<NasaCubit>(context).loadData();
            return Center(child: CircularProgressIndicator());
          }
          // Состояние ошибки
          else if (state is NasaErrorState) {
            // Показываем сообщение об ошибке
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Произошла ошибка",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // При нажатии кнопки перезагружаем данные
                      BlocProvider.of<NasaCubit>(context).loadData();
                    },
                    child: Text("Попробовать снова"),
                  ),
                ],
              ),
            );
          }
          // Состояние успешной загрузки данных
          else if (state is NasaLoadedState) {
            // Отображаем список изображений с детальной информацией
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.data.photos!.length,
                    itemBuilder: (context, index) {
                      final photo = state.data.photos![index];

                      // Заменяем http на https
                      final imageUrl = photo.imgSrc!.replaceAll(
                        'http://',
                        'https://',
                      );

                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: imageUrl,
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Text(
                                      'Failed to load image: $error\nURL: $imageUrl',
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                              placeholderErrorBuilder:
                                  (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      color: Colors.grey[200],
                                      child: Center(
                                        child: Text(
                                          'Failed to load placeholder: $error',
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Photo ID: ${photo.id}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Sol: ${photo.sol}'),
                                  Text('Earth Date: ${photo.earthDate}'),
                                  Text(
                                    'Camera: ${photo.camera?.fullName ?? 'Unknown'}',
                                  ),
                                  Text(
                                    'Rover: ${photo.rover?.name ?? 'Unknown'} (Status: ${photo.rover?.status ?? 'Unknown'})',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Пагинация (пока не реализована в текущей функциональности)
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed:
                            null, // Пока отключено, так как пагинация не реализована
                        child: Text('Previous'),
                      ),
                      Text('Page 1'),
                      ElevatedButton(
                        onPressed:
                            null, // Пока отключено, так как пагинация не реализована
                        child: Text('Next'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          // По умолчанию показываем пустой экран
          else {
            return Center(child: Text("Неизвестное состояние"));
          }
        },
      ),
    );
  }
}
