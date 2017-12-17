class TerrainElement extends Node:
	var textureStone = preload("res://image/texture/texChunc.png")
	var TerrainModell
	
	var TheSizeOfThisElement = 20
	var TheHighValues = []
	
	var TheXPosition
	var TheYPosition
	#This mean how many Chungs would be used this element
	var ZoomFactorForSimplex = 1
	
	var ZoomFactorForTheMesh = 0.5
	var rootNode
	func _init(SimplexForHighmap,SimplexForVegetation,xPos,yPos,parent):
		rootNode = parent
		TheXPosition = xPos
		TheYPosition = yPos
		
		calculateTheHighmap(SimplexForHighmap)
		createTheMesh()
	
	func calculateTheHighmap(SimplexForHighmap):
		for x in range(TheSizeOfThisElement+1):
			TheHighValues.append([])
			for z in range(TheSizeOfThisElement+1):
				var xValueForSimplex = float(TheXPosition) * ZoomFactorForSimplex +  (1.0 * ZoomFactorForSimplex) / float(TheSizeOfThisElement) * (float(x))
				var yValueForSimplex = float(TheYPosition) * ZoomFactorForSimplex +  (1.0 * ZoomFactorForSimplex) / float(TheSizeOfThisElement) * (float(z))
				#print(TheXPosition," :: ",TheYPosition," Round: ",x," :: ",z," Values: " ,xValueForSimplex," :: ",yValueForSimplex)
				TheHighValues[x].append(5 * SimplexForHighmap.openSimplex2D(xValueForSimplex,yValueForSimplex))
				#TheHighValues[x].append(5 * SimplexForHighmap.perlin_noise2d(xValueForSimplex,yValueForSimplex))
	
	func createTheMesh():
		TerrainModell=MeshInstance.new()
		rootNode.add_child(TerrainModell)
		var terrainMesh=Mesh.new()
		TerrainModell.set_mesh(terrainMesh)
		var surf=SurfaceTool.new()
		surf.begin(Mesh.PRIMITIVE_TRIANGLES)
		
		
		var xStructurForTheUV = 1.0 / (TheSizeOfThisElement+1.0)
		var yStructurForTheUV = 1.0 / (TheSizeOfThisElement+1.0)
		for x in range(TheSizeOfThisElement):
			for y in range(TheSizeOfThisElement):
				var xZoomed = ZoomFactorForTheMesh * x 
				var yZoomed = ZoomFactorForTheMesh * y 
				
				surf.add_color(Color(1,1,1))
				surf.add_uv(Vector2( xStructurForTheUV*(x+1),yStructurForTheUV*(y+1)))
				surf.add_vertex(Vector3(xZoomed,TheHighValues[x][y],yZoomed))
				
				surf.add_color(Color(1,1,1))
				surf.add_uv(Vector2( xStructurForTheUV*(x+2),yStructurForTheUV*(y+1)))
				surf.add_vertex(Vector3(xZoomed+ZoomFactorForTheMesh,TheHighValues[x+1][y],yZoomed))
				
				surf.add_color(Color(1,1,1))
				surf.add_uv(Vector2( xStructurForTheUV*(x+1),yStructurForTheUV*(y+2)))
				surf.add_vertex(Vector3(xZoomed,TheHighValues[x][y+1],yZoomed+ZoomFactorForTheMesh))
				
				surf.add_color(Color(1,1,1))
				surf.add_uv(Vector2( xStructurForTheUV*(x+1),yStructurForTheUV*(y+2)))
				surf.add_vertex(Vector3(xZoomed,TheHighValues[x][y+1],yZoomed+ZoomFactorForTheMesh))
				
				surf.add_color(Color(1,1,1))
				surf.add_uv(Vector2(xStructurForTheUV*(x+2),yStructurForTheUV*(y+1)))
				surf.add_vertex(Vector3(xZoomed+ZoomFactorForTheMesh,TheHighValues[x+1][y],yZoomed))
				
				surf.add_color(Color(1,1,1))
				surf.add_uv(Vector2(xStructurForTheUV*(x+2),yStructurForTheUV*(y+2)))
				surf.add_vertex(Vector3(xZoomed+ZoomFactorForTheMesh,TheHighValues[x+1][y+1],yZoomed+ZoomFactorForTheMesh))
		
		surf.generate_normals()
		var thisMaterial = FixedMaterial.new()
		thisMaterial.set_texture(FixedMaterial.PARAM_DIFFUSE, textureStone)
		thisMaterial.set_light_shader(FixedMaterial.LIGHT_SHADER_LAMBERT)
		surf.set_material(thisMaterial)
		surf.commit(terrainMesh)
		
		TerrainModell.set_name("Element"+ str(TheXPosition) + ":" + str(TheYPosition))
		TerrainModell.set_translation(Vector3((TheXPosition-1)*ZoomFactorForTheMesh*(TheSizeOfThisElement),0,TheYPosition*ZoomFactorForTheMesh*TheSizeOfThisElement))
		TerrainModell.create_trimesh_collision()
