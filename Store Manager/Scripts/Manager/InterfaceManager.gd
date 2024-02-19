extends Control
class_name  InputManager

@onready var products_panel = $Panel
@onready var products_buttons = $Panel/Buttons

@onready var product_name = $Panel/Name
@onready var text_edit_name = $Panel/Name/TextEdit
@onready var description = $Panel/Description
@onready var text_edit_desc = $Panel/Description/TextEdit
@onready var id = $Panel/Id
@onready var text_edit_id = $Panel/Id/TextEdit

func _ready():
	pass # Replace with function body.


func _process(delta):
	#$Control/VBoxContainer/Wood/WoodValue.text = str(GameManager.Wood)
	#$Control/VBoxContainer/Stone/StoneValue.text = str(GameManager.Stone)
	#$Control/VBoxContainer/Iron/IronValue.text = str(GameManager.Iron)
	#$Control/VBoxContainer/Food/FoodValue.text = str(GameManager.Food)
	#$Control/VBoxContainer/Gold/GoldValue.text = str(GameManager.Gold)
	#$Control/VBoxContainer2/Pop/PopValue.text = str(GameManager.AlvPopulation) + " / " + str(GameManager.MaxPopulation)
	#$Control/VBoxContainer2/Hap/HapValue.text = str(GameManager.Happiness)
	#$TabContainer/Economy/Control/TaxRate.text = str(GameManager.TaxRate) + " %"
	#$Panel/Label2.text = str(GameManager.State)
	#$Panel/Label2.text = str(GameManager.CurrentState)
	pass


func _on_DestroyMode_button_down():
	#GameManager.CurrentState = GameManager.State.Destroying
	pass # Replace with function body.




func _on_area_2d_area_entered(area):
	BuildManager.AbleToBuild = false


func _on_area_2d_area_exited(area):
	BuildManager.AbleToBuild = true


#========
"""
func _on_planta_button_down():
	BuildManager.spawn_plant()

func _on_estantería_button_down():
	BuildManager.spawn_shelving()
"""







#=================Products
func _on_add_button_down():
	#var product_category
	var product_name = text_edit_name.text
	var product_id = text_edit_id.text
	#var plant = $Panel/Productos/VBoxContainer/HBoxContainer/Planta_N
	var product_description = {
		"Description": "Lorem ipsum",
		"Size" : Vector3.ONE,
		"Weight": 1
	}
	
	var prodcut_position
	var product_location = {
		"Piso": 0,
		"Estantería" : 0,
		"Estante": 0
	}
	
	var p_dict = {
		"Name": product_name,
		"Id": product_id,
		"Description": product_description
	}
	
	if product_name == "" or product_name == "Nombre":
		BuildManager.build_info.emit("Nombre incorrecto")
		return
	print(p_dict)
	BuildManager.spawn_product(p_dict)


func _on_search_button_down():
	var product_name = text_edit_name.text
	if product_name == "" or product_name == "Nombre":
		BuildManager.build_info.emit("Nombre incorrecto")
		return
	
	BuildManager.search_product(product_name)


func _on_edit_button_down():
	pass # Replace with function body.

#====================Plants
func _on_add_plant_button_down():
	var plant_size = Vector3(10, 0.1, 10)
	BuildManager.spawn_plant(plant_size)


func _on_search_plant_button_down():
	pass # Replace with function body.


func _on_edit_plant_button_down():
	pass # Replace with function body.

#Save load
func _on_save_button_down():
	BuildManager.save_game()


func _on_load_button_down():
	BuildManager.load_game()
