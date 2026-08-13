@tool
extends SceneTree

func _init():
	var img = Image.load_from_file("res://assets/sprites/action_icons.png")
	
	# We want to find bounding boxes around the 3 items in the top half (y: 0 to 960)
	var get_bbox = func(start_x, end_x):
		var min_x = 9999
		var max_x = -1
		var min_y = 9999
		var max_y = -1
		
		for y in range(0, 960):
			for x in range(start_x, end_x):
				if img.get_pixel(x, y).a > 0.1:
					if x < min_x: min_x = x
					if x > max_x: max_x = x
					if y < min_y: min_y = y
					if y > max_y: max_y = y
		return Rect2(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)
	
	# Roughly slice into 3 parts and find tight bounding boxes
	var bbox1 = get_bbox.call(0, 640)
	var bbox2 = get_bbox.call(640, 1250) # Extend a bit if they overlap
	var bbox3 = get_bbox.call(1250, 1920)
	
	print("Mamadeira BBox: ", bbox1)
	print("Bear BBox: ", bbox2)
	print("Cradle BBox: ", bbox3)
	
	quit()
