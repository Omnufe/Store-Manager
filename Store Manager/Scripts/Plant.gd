extends StaticBody3D
class_name Plant

@onready var mesh_instance = $MeshInstance3D
@onready var collision_shape = $CollisionShape3D


#pPlant info
var plant_name = "Lorem"
var plant_id = 0
var plant_description = {
	"Description": 0,
	"Size" : Vector3(10, 0.1, 10)
}

var prodcuts
var is_saved := false

func _ready():
	var mesh = mesh_instance.get_mesh()
	mesh.size = plant_description["Size"]
	
	var shape = collision_shape.get_shape()#BoxShape3D.new()
	shape.size = plant_description["Size"]

func set_info(id):
	#plant_name = info["Name"]
	plant_id = id

func set_size(size : Vector3):
	var mesh = mesh_instance.get_mesh()
	mesh.size = size
	
	var shape = collision_shape.get_shape()#BoxShape3D.new()
	shape.size = size

func _process(delta):
	$Label3D.text = str(plant_id)

"""
		"plant_name" : plant_name,
		"plant_id" : plant_id,
		"plant_description" : plant_description["Description"],
		"size_x": plant_description["Size"].x
"""
func save():
	print("saving... " + plant_name)
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"obj_name": name,
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"pos_z" : position.z
	}
	
	is_saved = true
	return save_dict
