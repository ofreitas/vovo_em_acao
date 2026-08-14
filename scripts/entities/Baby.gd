extends CharacterBody2D

@export var thais_crying_texture: Texture2D
@export var thais_happy_texture: Texture2D
@export var terezinha_crying_texture: Texture2D
@export var terezinha_happy_texture: Texture2D

var crying_texture: Texture2D
var happy_texture: Texture2D

var current_state: String = "HAPPY"
var crying_sound: AudioStreamPlayer
var happy_sound: AudioStreamPlayer
var game_manager

func _ready() -> void:
    game_manager = get_node("/root/GameManager")
    if game_manager.current_grandma and game_manager.current_grandma.id == "terezinha":
        crying_texture = terezinha_crying_texture
        happy_texture = terezinha_happy_texture
    else:
        crying_texture = thais_crying_texture
        happy_texture = thais_happy_texture

    $Sprite2D.texture = happy_texture

    var crying_path := "res://assets/sounds/baby_crying.mp3"
    var happy_path := "res://assets/sounds/baby_happy.mp3"
    if game_manager.current_grandma and game_manager.current_grandma.id == "terezinha":
        crying_path = "res://assets/sounds/baby-crying-2.mp3"
        happy_path = "res://assets/sounds/baby-giggle-2.mp3"

    crying_sound = AudioStreamPlayer.new()
    crying_sound.stream = load(crying_path)
    crying_sound.volume_db = 0.0
    add_child(crying_sound)

    happy_sound = AudioStreamPlayer.new()
    happy_sound.stream = load(happy_path)
    happy_sound.volume_db = 0.0
    add_child(happy_sound)

func set_state(state: String) -> void:
    current_state = state
    if current_state == "HAPPY":
        $Sprite2D.texture = happy_texture
        crying_sound.stop()
        happy_sound.play()
    elif current_state == "CRYING":
        $Sprite2D.texture = crying_texture
        happy_sound.stop()
        crying_sound.play()
