extends Node3D

@onready var anim = $AnimatedSprite3D

func _ready() -> void:
	anim.play("default")
