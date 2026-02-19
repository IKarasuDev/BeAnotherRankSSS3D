extends Node

var root: Node
var current_world: Node = null

func setup(main_root: Node):
	root = main_root


func change_world(world_scene: PackedScene, spawn_name: String):

	if current_world:
		current_world.queue_free()
		await get_tree().process_frame  # 🔥 ESPERAR a que realmente desaparezca

	current_world = world_scene.instantiate()
	root.add_child(current_world)

	await get_tree().process_frame

	if spawn_name != "":
		await move_player_to_spawn(spawn_name)

	activate_world_camera()
	print_active_camera()



func activate_world_camera():

	# Desactivar TODAS las cámaras del árbol
	var all_cameras = get_tree().get_nodes_in_group("Camera3D")

	for cam in all_cameras:
		cam.current = false

	# Buscar cámaras del mundo actual
	var world_cameras = current_world.find_children("*", "Camera3D", true, false)

	if world_cameras.size() > 0:
		world_cameras[0].current = true
		
	print("Viewport size:", get_viewport().get_visible_rect().size)



func print_active_camera():

	var cameras = current_world.find_children("*", "Camera3D", true, false)

	for cam in cameras:
		if cam.current:
			print("CamaraName:", cam.name, "Pos:", cam.global_position)
			print("FOV:", cam.fov)
			print("Projection:", cam.projection)
			return

	print("No hay cámara activa en este mundo")


func move_player_to_spawn(spawn_name: String):

	var spawn = current_world.find_child(spawn_name, true, false)
	var player = current_world.find_child("Auren", true, false)

	if not spawn:
		push_error("Spawn no encontrado: " + spawn_name)
		return

	if not player:
		push_error("Player no encontrado en el mundo nuevo")
		return

	player.set_physics_process(false)
	player.global_position = spawn.global_position
	await get_tree().process_frame
	player.set_physics_process(true)
	
	await get_tree().process_frame

	# Resetear tracking de la cámara
	var cameras = current_world.find_children("*", "Camera3D", true, false)

	for cam in cameras:
		if cam.has_method("reset_tracking"):
			cam.reset_tracking()
			
	print("Player scale:", player.scale)
