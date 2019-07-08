extends Node2D

export (float) var CAMERA_ZOOM = .4

# Called when the node enters the scene tree for the first time.
func _ready():
	print("initializing map...")
	$TestLevelMap.initialize()
	
	print("setting up cameras")
	
	#only one cam
	print("setting up MainCam")
	ready_camera($Player/MainCam, $TestLevelMap)
	$Player/MainCam.current = true
	print("done with MainCam")
	
	print("done setting up cameras")

func ready_camera(camera, map):
	#camera zoom
	set_zoom(camera)
	
	#limits of movement
	#returns an array of two vectors, in the form of [(x min, x max), (y min, y max)]
	var limits = determine_camera_limits(map)
	set_camera_limits(camera, limits[0].x, limits[0].y, limits[1].x, limits[1].y)
	
	
func set_camera_limits(camera, left, right, top, bottom):
	camera.limit_left = left
	camera.limit_right = right
	camera.limit_top = top
	camera.limit_bottom = bottom
	
	print("camera limits are...\nleft:{0} \nright:{1} \ntop:{2} \nbottom:{3}".format([str(left),str(right),str(top),str(bottom)]))

	
func set_zoom(camera):
	camera.zoom = Vector2(CAMERA_ZOOM,CAMERA_ZOOM)
	print("zoom level is " + str(CAMERA_ZOOM))
	
func determine_camera_limits(map):
	
	#limits are based off of the map size and cell size
	var maximum = Vector2(0,0)
	maximum.x = map.cells.x * map.cell_size.x
	maximum.y = map.cells.y * map.cell_size.y
	print("camera maximum position is " + str(maximum))
	
	#minimum limit is based off of the origin of the partial map
	var map_position = map.get_position()
	print("camera minimum position is " + str(map_position))
	
	#finally, determine the camera limits and return them
	var x_limits = Vector2(map_position.x, maximum.x)
	var y_limits = Vector2(map_position.y, maximum.y)
	return [x_limits, y_limits]
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
