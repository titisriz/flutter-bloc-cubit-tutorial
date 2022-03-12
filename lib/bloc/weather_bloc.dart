import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cubit_bloc_tutorial/data/weather_repository.dart';

import 'package:flutter_cubit_bloc_tutorial/data/model/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherBloc(this._weatherRepository) : super(WeatherInitial()) {
    //solution on bloc 8
    on<GetWeather>((event, emit) async {
      try {
        emit(WeatherLoading());
        final weather = await _weatherRepository.fetchWeather(event.cityName);
        emit(WeatherLoaded(weather));
      } on NetworkException {
        emit(WeatherError("Couldnt fetch weather"));
      }
    });
  }

  @override
  void onEvent(WeatherEvent event) {
    // TODO: implement onEvent
    super.onEvent(event);
  }

  @override
  //deprecated in bloc 8
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is GetWeather) {
      print(event);
      try {
        yield (WeatherLoading());
        final weather = await _weatherRepository.fetchWeather(event.cityName);
        yield (WeatherLoaded(weather));
      } on NetworkException {
        yield (WeatherError("Couldnt fetch weather"));
      }
    }
  }
}
