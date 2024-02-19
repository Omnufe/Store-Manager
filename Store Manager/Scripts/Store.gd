extends Node3D
class_name Store

@export var plants =[]
#@onready var navigation_region_3d = $NavigationRegion3D

var selected_plant :Plant
var index = 0

@onready var info_label = $Control/InfoLabel

var is_saved := false

func _ready():
	initilize()
	BuildManager.build_info.connect(update_info)


func initilize():
	
	plants.clear()
	for child in get_children():
		if child is Plant:
			plants.append(child)
	
	index = 0
	selected_plant = plants[index]
	BuildManager.build_info.emit("Planta: " + str(selected_plant.plant_id))
	print("Store initialized")


func add_plant(new_plant):
	add_child(new_plant)
	plants.append(new_plant)


func _input(event):
	return
	# Receives key input
	if event is InputEventKey:
		match event.keycode:
			KEY_0:
				index = 0
			KEY_1:
				index = 1
			KEY_2:
				index = 2
			KEY_3:
				index = 3
			KEY_4:
				index = 4
			KEY_5:
				index = 5
	
		if index <= plants.size() -1:
			selected_plant = plants[index]


func update_info(new_info):
	info_label.text = new_info

