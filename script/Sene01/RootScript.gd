extends Node

const _MightyFloorController = preload("MightyFloorController.gd")
var MightyFloorController
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _init():
	#the fuc&(#9 Constructor
	#Dont be affraid. 
	MightyFloorController = _MightyFloorController.new(self)
	pass

func _ready():
	pass