extends Node2D


remote func update_player(lobby_id, transform, animation):
	for i in Server.data[lobby_id]["players"]:
		rpc_unreliable_id(i, "update_remote_player", transform, animation)
