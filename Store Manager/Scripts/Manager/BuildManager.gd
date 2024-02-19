extends Node3D

enum State{
	Play,
	Buildling,
	Destroying
}

signal build_info(info_1 :String)

var CurrentState = State.Play
var spawnReady := true

var plant : PackedScene = ResourceLoader.load("res://Scenes/plant.tscn")
#var shelving : PackedScene = ResourceLoader.load("res://Scenes/shelving.tscn")
#var shelf : PackedScene = ResourceLoader.load("res://Scenes/shelf.tscn")
var product : PackedScene = ResourceLoader.load("res://Scenes/product.tscn")

var able_to_build : bool = true #AbleToBuild
var CurrentSpawnable : Product




func _ready():
	build_info.emit("Test 1")


func _process(delta):
	#process_spawn()
	if able_to_build == false:
		print(str(able_to_build))
	
	if CurrentState == State.Buildling:
		var space_state = get_world_3d().direct_space_state
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(get_viewport().get_mouse_position())
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
		
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)
		
		var cursorPos =  result.position if result else Vector3.ZERO #Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
		if not cursorPos:
			return
		
		if not CurrentSpawnable:
			return
		
		CurrentSpawnable.position = Vector3(round(cursorPos.x), cursorPos.y, round(cursorPos.z))
		CurrentSpawnable.is_active = true
		if able_to_build && canAfford(CurrentSpawnable):
			if Input.is_action_just_released("left_mouse"):
				var obj := CurrentSpawnable.duplicate()
				#var navMesh = get_tree().get_nodes_in_group("NavMesh")[0]
				var my_store : Store = get_tree().get_nodes_in_group("Store")[0]
				#my_store.initialize()
				var my_plant :Plant = my_store.selected_plant
				
				build_info.emit("Producto: " + CurrentSpawnable.product_name)
				my_plant.add_child(obj)
				obj.is_active = false
				obj.is_spawned = true
				#chargeObject(obj)
				obj.set_disable(false)
				obj.position = CurrentSpawnable.position
				#navMesh.bake_navigation_mesh(true)
				#build_ok.emit("test 1", "test 2")
				await get_tree().create_timer(0.1).timeout
				able_to_build = true
	
		if Input.is_action_just_released("right_mouse"):
			CurrentSpawnable.queue_free()
			CurrentSpawnable = null
			CurrentState = State.Play
		
		if Input.is_action_just_released("middle_mouse"):
			CurrentSpawnable.rotation_degrees += Vector3(0,90,0)
		
	if CurrentState == State.Destroying:
		if is_instance_valid(CurrentSpawnable):
			CurrentSpawnable.queue_free()
			CurrentSpawnable = null
		if Input.is_action_just_released("LeftMouseDown"):
			ep()


func process_spawn():
	if  spawnReady:
		spawnReady = false
		await get_tree().create_timer(3.0).timeout
		spawnReady = true
	elif spawnReady:
		spawnReady = false
		await get_tree().create_timer(3.0).timeout
		spawnReady = true

func ep():
	var camera = get_viewport().get_camera()
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
	if raycast_result.collider.is_in_group("building"):
		raycast_result.collider.runDespawn()


func canAfford(obj) -> bool:
	return true

func chargeObject(obj):
	#save to inventory file
	pass
	"""GameManager.Wood -= obj.WoodCost
	GameManager.Iron -= obj.IronCost
	GameManager.Stone -= obj.StoneCost
	GameManager.Gold -= obj.GoldCost
"""

func spawn_plant(size):
	#var navMesh = get_tree().get_nodes_in_group("NavMesh")[0]
	var my_store = get_tree().get_nodes_in_group("Store")[0]
	print("Número de plantas " + str(my_store.plants.size()))
	
	if CurrentSpawnable != null:
		CurrentSpawnable.queue_free()
	
	var plant_id = my_store.plants.size()
	
	var current_spawnable :Plant = plant.instantiate()
	current_spawnable.position = Vector3(0, -plant_id *5, 0)
	#current_Spawnable.set_disable(true)
	
	current_spawnable.set_info(plant_id)
	build_info.emit("Número de plantas: " + str(plant_id))
	#build_info.emit("Planta: " + CurrentSpawnable.product_name)
	
	my_store.add_plant(current_spawnable)
	CurrentState = State.Buildling


"""
func spawn_shelving():
	var s_info
	SpawnObj(shelving, s_info)


func spawn_shelf():
	var s_info
	SpawnObj(shelf, s_info)
"""

func spawn_product(product_info:Dictionary):
	SpawnObj(product, product_info)


func SpawnObj(obj, obj_info):
	if CurrentSpawnable != null:
		CurrentSpawnable.queue_free()
	
	CurrentSpawnable = obj.instantiate()
	CurrentSpawnable.set_disable(true)
	CurrentSpawnable.set_info(obj_info)
	get_tree().root.add_child(CurrentSpawnable)
	CurrentState = State.Buildling


#==============
func _on_button_pressed():
	print($Control/TextEdit.text)


func _on_search_button_down():
	var p = $Control/Panel/TextEdit.text
	if p == "":
		print("Error: producto desconocido")
	else:
		print("Buscar ", p)
		search_product(p)



func search_product(product_name):
	var found = false
	
	#var navMesh = get_tree().get_nodes_in_group("NavMesh")[0]
	var my_store = get_tree().get_nodes_in_group("Store")[0]
	var my_plant :Node3D= my_store.selected_plant
	
	for child in my_plant.get_children():
		if child is Product:
			var p = child
			if p.product_name == product_name:
				print("Producto encontrado")
				build_info.emit(product_name + " Encontrado")
				p.located()
				found = true
				#locate.emit(shelving.global_position)
				break
	
	for child in my_plant.get_children():
		if child is Shelving:
			var s = child
			for g_child in s.get_children():
				if g_child is Product:
					var p = child
					if p.product_name == product_name:
						print("Producto encontrado en el estantería:") #, shelving.shelving_name)
						build_info.emit(product_name + " Encontrado")
						found = true
						#locate.emit(shelving.global_position)
						break
	
		if found:
			break
	
	if not found:
		print("Producto no encontrado en ningún estante")
		build_info.emit(product_name + " Producto no encotrado")


#=====================Save/Load
var save_dir = "user://saves/"
# Ruta del archivo donde se guardará la información de la escena
var save_file_path = "user://scene_data.save"#"user://scene_data.save"

func save_game():
	var save_game = FileAccess.open(save_file_path, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.save()#node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(json_string)

func load_game():
	if not FileAccess.file_exists(save_file_path):
		print("Error! We don't have a save to load")
		return 

	# We need to revert the game state so we're not cloning objects during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		print("Saved? " + i.name + str(i.is_saved))
		#if not i.is_saved:
		i.queue_free()

	await get_tree().create_timer(0.1).timeout
	# Load the file line by line and process that dictionary to restore the object it represents.
	var save_game = FileAccess.open(save_file_path, FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		
		# Creates the helper class to interact with JSON
		var json = JSON.new()
		
		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		# Get the data from the JSON object
		var node_data = json.get_data()
		
		# Firstly, we need to create the object and add it to the tree and set its position.
		print("Loading... " + node_data["filename"])
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.name = node_data["obj_name"]
		if new_object is Plant:
			new_object.position = Vector3(node_data["pos_x"], node_data["pos_y"], node_data["pos_z"])
		elif new_object is Product:
			#new_object.set_disable(false)
			new_object.position = Vector3(node_data["pos_x"], node_data["pos_y"], node_data["pos_z"])
		
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "pos_z":
				continue
			new_object.set(i, node_data[i])
		
		await get_tree().create_timer(0.1).timeout
	
	var my_store = get_tree().get_nodes_in_group("Store")[0]
	my_store.initilize()
	#var my_plant :Node3D= my_store.selected_plant
