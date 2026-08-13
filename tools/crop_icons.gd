@tool
extends SceneTree

func _init():
    var img = Image.load_from_file("res://assets/sprites/action_icons.png")
    
    var w = 1920 / 3
    var h = 1920 / 2
    
    # Mamadeira
    var img1 = img.get_region(Rect2i(0, 0, w, h))
    img1.save_png("res://assets/sprites/icon_mamadeira.png")
    
    # Brinquedo
    var img2 = img.get_region(Rect2i(w, 0, w, h))
    img2.save_png("res://assets/sprites/icon_brinquedo.png")
    
    # Ninar
    var img3 = img.get_region(Rect2i(w*2, 0, w, h))
    img3.save_png("res://assets/sprites/icon_ninar.png")
    
    # Fralda
    var img4 = img.get_region(Rect2i(0, h, 1920/2, h))
    img4.save_png("res://assets/sprites/icon_fralda.png")
    
    # Cantar
    var img5 = img.get_region(Rect2i(1920/2, h, 1920/2, h))
    img5.save_png("res://assets/sprites/icon_cantar.png")
    
    # Dar chupeta (reuse Brinquedo for now if there is none)
    img2.save_png("res://assets/sprites/icon_chupeta.png")
    
    print("Cropped successfully!")
    quit()
