extends Node

const _softnoice = preload("softnoise.gd")
const _TerrainElement = preload("TerrainElement.gd")

var SimplexForHighmap
var SimplexForVegetation

var Terrain = []
var TerrainElementCount = 8

func _init(parent):
	SimplexForHighmap 		= _softnoice.SoftNoise.new(555)
	SimplexForVegetation 	= _softnoice.SoftNoise.new(20)
	for x in range(TerrainElementCount):
		for y in range(TerrainElementCount):
			Terrain.append(_TerrainElement.TerrainElement.new(SimplexForHighmap,SimplexForVegetation,x+1,y+1,parent))