import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tigas_application/gmaps/location_service.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/providers/station_provider.dart';
import 'package:provider/provider.dart';
import 'package:tigas_application/styles/styles.dart';
import 'package:tigas_application/widgets/station_info.dart';

class CustomWindow extends StatelessWidget {
  const CustomWindow({Key? key, required this.info}) : super(key: key);
  final Station info;

  @override
  Widget build(BuildContext context) {
    return Consumer<StationProvider>(
      builder: (context, stationProvider, _) {
        double? distance = stationProvider.getDistanceToStation(info);

        return GestureDetector(
          onTap: () {
            _showModalBottomSheet(context, info);
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.4),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            decoration: getGradientDecoration(),
                            width: MediaQuery.of(context).size.width * 0.12,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (distance != null)
                                  Flexible(
                                    child: FutureBuilder<double>(
                                      future: LocationService()
                                          .calculateDistanceToStation(info),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<double> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            '--',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(color: Colors.white),
                                          );
                                        } else {
                                          return Text(
                                            '${snapshot.data?.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                Text('km',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(4),
                              child: Image.asset(
                                '${info.imagePath}',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.black),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showModalBottomSheet(BuildContext context, Station station) {
    final size = MediaQuery.of(context).size;
    final unitHeightValue = size.height * 0.01;
    final unitWidthValue = size.width * 0.01;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2 * unitHeightValue),
            topRight: Radius.circular(2 * unitHeightValue),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: 100 * unitWidthValue,
            child: StationInfo(
              station: station,
              gasTypeInfo: station.gasTypeInfo ?? {},
              gasTypes: station.gasTypes ?? [],
              services: station.services ?? [],
            ),
          ),
        );
      },
    );
  }
}
