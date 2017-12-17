extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)
	pass

func _input(event):
	var oCamPos = self.get_translation()
	var oCamRot = self.get_rotation()
	var fFactor = -5.0
	if event.type == InputEvent.MOUSE_MOTION:
		#toLog("Device id" + str(event.device) + " ID: " + str(event.ID) + "X: " + str(event.x) + "Relative X" + str(event.relative_x))
		#var oCam = self.get_node("Camera")		
		#toLog("Vor: " + str(oCamPos.x))
		rotate_x(deg2rad(event.relative_y))
		rotate_y(deg2rad(event.relative_x))
		#oCamRot.x = rad2deg(oCamRot.x) + event.relative_x
		#oCamRot.y = rad2deg(oCamRot.y) + event.relative_y 
		#self.set_rotation(Vector3(deg2rad(oCamRot.x),0 , 0))
		#self.set_rotation(Vector3(0, deg2rad(oCamRot.y) , 0))
		#toLog("Nach: " + str(oCamPos.x))
	if event.type == InputEvent.KEY:
		if event.scancode == 68:#d
			oCamPos.x = oCamPos.x - 0.25
		if event.scancode == 65:#a
			oCamPos.x = oCamPos.x + 0.25
		if event.scancode == 87:#w
			oCamPos.z = oCamPos.z - 0.25
		if event.scancode == 83:#s
			oCamPos.z = oCamPos.z + 0.25
		if event.scancode == 70:#f
			oCamPos.y = oCamPos.y - 0.25
		if event.scancode == 82:#r
			oCamPos.y = oCamPos.y + 0.25
		#print(event.scancode )
	self.set_translation(oCamPos)