extends StaticBody3D
class_name Product


var is_mouse_hover = false
var is_selected = false

var is_active : bool = false#ActiveBuildableObject
var objects : Array
var is_spawned : bool = false

#product info
var product_info : ProductInfo = ProductInfo.new()

var product_category
@export var product_name = "Lorem ipsum"
var product_id = 0
#@export var product_description = "Lorem ipsum"
var product_description = {
	"Description": 0,
	"Size" : Vector3.ONE,
	"Weight": 1
}

var prodcut_position
var product_location = {
	"Piso": 0,
	"Estantería" : 0,
	"Estante": 0
}

var default_material = preload("res://Art/white.tres")
var located_material = preload("res://Art/green.tres")
var is_saved := false

func _ready():
	#print(name + str($Label3D.visible))
	#$MeshInstance3D.set_surface_override_material(0, default_material)
	pass


func set_disable(disabled : bool):
	$CollisionShape3D.disabled = disabled

func set_info(info:Dictionary):
	product_name = info["Name"]
	product_description = info["Description"]

func located():
	print("Localted")
	$MeshInstance3D.set_surface_override_material(0, located_material)


func _process(delta):
	if is_mouse_hover:
		$Label3D.visible = true
		$Label3D.text = product_name + " > " +str(product_id) + get_parent().name
	else:
		$Label3D.visible = false


func _on_area_3d_area_entered(area):
	if is_active:
		objects.append(area)
		#BuildManager.able_to_build = false


func _on_area_3d_area_exited(area):
	if is_active:
		objects.erase(objects.find(area))
		if objects.size() <= 0:
			BuildManager.able_to_build = true


func _on_area_3d_mouse_entered():
	is_mouse_hover = true

func _on_area_3d_mouse_exited():
	is_mouse_hover = false


"""
		"product_info" : product_info.product_category,
		"product_name" : product_info.product_name,
		"product_id" : product_info.product_id
"""
func save():
	
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"obj_name": name,
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"pos_z" : position.z
	}
	
	var is_saved = true
	print("saving... " + str(is_saved) + " " + product_name)
	return save_dict
