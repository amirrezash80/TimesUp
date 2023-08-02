import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scattegories/features/5_secend_rules/player_management_feature/presentation/widgets/player_card.dart';

import '../../data/models/player_class.dart';
import '../bloc/player_bloc.dart';

class PlayersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayersBloc, List<PlayersInfo>>(
      builder: (context, playersList) {
        return ListView.builder(
          itemCount: playersList.length + 1,
          itemBuilder: (context, index) {
            if (index < playersList.length) {
              final player = playersList[index];
              return PlayerCard(
                player: player,
                playerIndex: index, // Pass the player index
                onNameChanged: (newName) {
                  context.read<PlayersBloc>().updatePlayerName(index, newName);
                },
                onDeletePlayer: (playerIndex) {
                  context.read<PlayersBloc>().removePlayer(playerIndex , context);
                },
              );
            } else {
              return Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<PlayersBloc>().addPlayer();
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add new player"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
