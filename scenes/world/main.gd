extends Node

@export var initial_world: PackedScene

func _ready():
	WorldManager.setup(self)
	WorldManager.change_world(initial_world, "InitialSpawn")
