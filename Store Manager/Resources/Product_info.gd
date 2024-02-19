extends Resource
class_name ProductInfo

#product info
var product_category = "Category"
var product_name = "Lorem"
var product_id = 0
#@export var product_description = "Lorem ipsum"
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
