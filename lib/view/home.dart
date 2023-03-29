import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/utils/colors.dart';
import 'package:weather/utils/dimens.dart';
import 'package:weather/view/widgets/background_widget.dart';
import 'package:weather/view_model/weather_view_model.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const BackgroundWidget(),
          Consumer<WeatherViewModel>(
            builder: (context, weatherViewModel, child) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(paddingX24),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Search weather by city.",
                          style: TextStyle(
                            color: whiteFontColor,
                            fontSize: fontBodyTextLarge
                          ),
                        ),
                        SizedBox(height: marginX8),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _searchController,
                                validator: (value) => validateTextField(value),
                                style: const TextStyle(color: Colors.black),
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  isDense: true,
                                  hintText: "City name",
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                ),
                              ),
                              SizedBox(height: marginX16),
                              weatherViewModel.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : SizedBox(
                                height: 45,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(accentColor)
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      bool response = await weatherViewModel.getCityLatLon(_searchController.text);
                                      if (!response) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(weatherViewModel.errorMsg),
                                            )
                                          );
                                        }
                                      }
                                    }
                                  },
                                  child: const Text("Search"),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: marginX16),
                        (weatherViewModel.weatherForecast?.list ?? []).isNotEmpty
                          ? Column(
                              children: <Widget>[
                                Text(
                                  "5 days Forecast at ${weatherViewModel.city} in different time intervals.",
                                  style: TextStyle(
                                      color: whiteFontColor,
                                      fontSize: fontBodyTextLarge
                                  ),
                                ),
                                SizedBox(height: marginX16),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    children: List.generate(weatherViewModel.weatherForecast?.list?.length ?? 0,
                                            (index) => Container(
                                          color: Colors.white10,
                                          padding: EdgeInsets.all(paddingX8),
                                          margin: EdgeInsets.only(right: marginX8),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                DateFormat('yyyy-MM-dd – kk:mm').format(weatherViewModel.weatherForecast?.list?[index].dtTxt ?? DateTime.now()),
                                                style: TextStyle(color: whiteFontColor),
                                              ),
                                              SizedBox(height: marginX8),
                                              Text(
                                                "${((weatherViewModel.weatherForecast?.list?[index].main?.temp ?? 0) - 273.15).toStringAsFixed(2)}°C",
                                                style: TextStyle(
                                                    color: whiteFontColor,
                                                    fontSize: fontHeadingSubTitle
                                                ),
                                              ),
                                              SizedBox(height: marginX8),
                                              Text(
                                                "${(weatherViewModel.weatherForecast?.list?[index].weather?[0].main)}",
                                                style: TextStyle(
                                                    color: whiteFontColor,
                                                    fontSize: fontHeadingSubTitle
                                                ),
                                              ),
                                              SizedBox(height: marginX8),
                                              Image.network(
                                                "https://openweathermap.org/img/wn/${weatherViewModel.weatherForecast?.list?[index].weather?[0].icon}@2x.png"
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                )
                              ],
                          ) : Container()
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  validateTextField(String? value) {
    if (value == null) {
      return "Please enter city name.";
    } else if (value.length < 4) {
      return "City name must be at least 4 characters.";
    }
    return null;
  }
}
