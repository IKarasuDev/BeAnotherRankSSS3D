extends Area3D

@export var target_world: PackedScene
@export var target_spawn: String

func _on_body_entered(body):
	if body.is_in_group("Auren"):
		WorldManager.change_world(target_world, target_spawn)
