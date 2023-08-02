import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/constants.dart';
import '../../../player_management_feature/data/models/player_class.dart';
import '../../../player_management_feature/presentation/bloc/player_bloc.dart';

class PointsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GoldColor,
        title: Text('Player Points'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.restore,
              size: 30,
            ),
            onPressed: () {
              context.read<PlayersBloc>().resetAllPlayerPoints();
            },
          ),
        ],
      ),
      body: BlocBuilder<PlayersBloc, List<PlayersInfo>>(
        builder: (context, playersList) {
          if (playersList.isEmpty) {
            return Center(
              child: Text('No players available'),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView.builder(
              itemCount: playersList.length,
              itemBuilder: (context, index) {
                final player = playersList[index];
                return ListTile(
                  title: Card(
                    color: GoldColor.withOpacity(0.6),
                    elevation: 4,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              player.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Points: ${player.points}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
