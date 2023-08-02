import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scattegories/core/utils/constants.dart';

import '../../data/models/player_class.dart';
import '../bloc/player_bloc.dart';

class PlayerCard extends StatefulWidget {
  final PlayersInfo player;
  final int playerIndex; // Added playerIndex parameter
  final Function(String) onNameChanged;
  final Function(int) onDeletePlayer;

  PlayerCard({
    required this.player,
    required this.playerIndex,
    required this.onNameChanged,
    required this.onDeletePlayer,
  });

  @override
  _PlayerCardState createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.player.name;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GoldColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              onChanged: (newName) {
                widget.onNameChanged(newName);
              },
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration.collapsed(hintText: 'Player Name'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: _textEditingController.text.isNotEmpty ? Colors.red : Colors.grey[400],
            onPressed: _textEditingController.text.isNotEmpty
                ? () {
              widget.onDeletePlayer(widget.playerIndex);
            }
                : null,
          ),
        ],
      ),
    );
  }
}
