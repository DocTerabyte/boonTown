
extends TextureButton

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	pass
	# Initialization here

func _on_TextureButton_pressed():
	get_node("/root/MainScript").setScene("res://scene/Scene01.scn")
