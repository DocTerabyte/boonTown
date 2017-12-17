class TerrainElement extends Node:
	var textureWood = preload("res://image/texture/GrasBoden.png")
	var textureGrass = preload("res://image/texture/WaldBoden.png")
	var floorImage = Image(128,128,false,Image.FORMAT_RGBA)
	
	var TerrainModell
	
	var TheSizeOfThisElement = 20
	var TheHighValues = []
	var TheVegitationValues = []
	
	var TheXPosition
	var TheYPosition
	#This mean how many Chungs would be used this element
	var ZoomFactorForSimplex = 1
	var ZoomFactorForVegitationSimplex = 0.5
	
	var ZoomFactorForTheMesh = 0.5
	var rootNode
	func _init(SimplexForHighmap,SimplexForVegetation,xPos,yPos,parent):
		rootNode = parent
		TheXPosition = xPos
		TheYPosition = yPos
		
		calculateTheHighmap(SimplexForHighmap,SimplexForVegetation)
		createTexture(SimplexForVegetation)
		createTheMesh()
		doVegitaton()
		addToGlobal()
	
	func calculateTheHighmap(SimplexForHighmap,SimplexForVegetation):
		for x in range(TheSizeOfThisElement+1):
			TheHighValues.append([])
			TheVegitationValues.append([])
			var xValueForSimplex = float(TheXPosition) * ZoomFactorForSimplex +  (1.0 * ZoomFactorForSimplex) / float(TheSizeOfThisElement) * (float(x))
			var xValueForSimplexVegitation = float(TheXPosition) * ZoomFactorForVegitationSimplex +  (1.0 * ZoomFactorForVegitationSimplex) / float(TheSizeOfThisElement) * (float(x))
			for z in range(TheSizeOfThisElement+1):
				var yValueForSimplex = float(TheYPosition) * ZoomFactorForSimplex +  (1.0 * ZoomFactorForSimplex) / float(TheSizeOfThisElement) * (float(z))
				var yValueForSimplexVegitation = float(TheYPosition) * ZoomFactorForVegitationSimplex +  (1.0 * ZoomFactorForVegitationSimplex) / float(TheSizeOfThisElement) * (float(z))
				#print(TheXPosition," :: ",TheYPosition," Round: ",x," :: ",z," Values: " ,xValueForSimplex," :: ",yValueForSimplex)
				TheHighValues[x].append(5 * SimplexForHighmap.openSimplex2D(xValueForSimplex,yValueForSimplex))
				TheVegitationValues[x].append(SimplexForVegetation.openSimplex2D(xValueForSimplexVegitation,yValueForSimplexVegitation))
				#TheHighValues[x].append(5 * SimplexForHighmap.perlin_noise2d(xValueForSimplex,yValueForSimplex))
	
	func createTexture(SimplexForVegetation):
		print("Start Image at Pos: ", TheXPosition,":" ,TheYPosition)
		var ImageGrass = textureGrass.get_data()
		var ImageWood = textureWood.get_data()
		for x in range(floorImage.get_width()):
			var xValueForSimplex = float(TheXPosition) * ZoomFactorForVegitationSimplex +  (1.0 * ZoomFactorForVegitationSimplex) / floorImage.get_width() * (float(x))
			for y in range(floorImage.get_height()):
				var yValueForSimplex = float(TheYPosition) * ZoomFactorForVegitationSimplex +  (1.0 * ZoomFactorForVegitationSimplex) / floorImage.get_height() * (float(y))
				if(SimplexForVegetation.openSimplex2D(xValueForSimplex,yValueForSimplex) > 0.2):
					floorImage.put_pixel(x,y,ImageGrass.get_pixel(x,y))
				else:
					floorImage.put_pixel(x,y,ImageWood.get_pixel(x,y))
		print("--End Image at Pos: ", TheXPosition,":" ,TheYPosition)
	
	func addToGlobal():
		TerrainModell.set_translation(Vector3((TheXPosition-1)*ZoomFactorForTheMesh*(TheSizeOfThisElement),0,TheYPosition*ZoomFactorForTheMesh*TheSizeOfThisElement))
		rootNode.add_child(TerrainModell)
	
	func createTheMesh():
		TerrainModell=MeshInstance.new()
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
		var thisImageTexture = ImageTexture.new()
		thisImageTexture.create_from_image(floorImage,7)
		thisMaterial.set_texture(FixedMaterial.PARAM_DIFFUSE, thisImageTexture)
		thisMaterial.set_light_shader(FixedMaterial.LIGHT_SHADER_LAMBERT)
		surf.set_material(thisMaterial)
		surf.commit(terrainMesh)
		TerrainModell.set_name("Element"+ str(TheXPosition) + ":" + str(TheYPosition))
		TerrainModell.create_trimesh_collision()	
		
	func doVegitaton():
		var Tree1 = preload("res://model/Tree01.msh")
		for x in range(TheVegitationValues.size()):
			for y in range(TheVegitationValues[x].size()):
				if TheVegitationValues[x][y] >  0.2:
					var addTree = MeshInstance.new()
					addTree.set_mesh(Tree1)
					TerrainModell.add_child(addTree)
					addTree.set_translation(Vector3(x*ZoomFactorForTheMesh,TheHighValues[x][y],y*ZoomFactorForTheMesh))