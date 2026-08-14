extends Node

var current_score: int = 0
var high_score: int = 0
var current_grandma: GrandmaData
var available_grandmas: Array[GrandmaData] = []
var available_actions: Array[ActionData] = []
const FALLBACK_GRANDMAS := [
    "res://data/grandmas/grandma_thais.tres",
    "res://data/grandmas/grandma_terezinha.tres"
]
const FALLBACK_ACTIONS := [
    "res://data/actions/action_brinquedo.tres",
    "res://data/actions/action_cantar_musica.tres",
    "res://data/actions/action_fralda.tres",
    "res://data/actions/action_mamadeira.tres",
    "res://data/actions/action_ninar.tres",
    "res://data/actions/action_dar_chupeta.tres"
]

func _ready():
    load_grandmas()
    load_actions()

func load_grandmas():
    available_grandmas.clear()
    _load_resources_from_dir("res://data/grandmas/", available_grandmas)
    _load_resources_fallback(FALLBACK_GRANDMAS, available_grandmas)
    print("Loaded grandmas: ", available_grandmas.size())

func load_actions():
    available_actions.clear()
    _load_resources_from_dir("res://data/actions/", available_actions)
    _load_resources_fallback(FALLBACK_ACTIONS, available_actions)
    print("Loaded actions: ", available_actions.size())

func _load_resources_from_dir(path: String, destination: Array):
    var dir = DirAccess.open(path)
    if not dir:
        print("Could not open directory: ", path)
        return
    dir.list_dir_begin()
    var file_name = dir.get_next()
    while file_name != "":
        if file_name.ends_with(".tres") and not file_name.begins_with("."):
            var resource = load(path + file_name)
            if resource and not destination.has(resource):
                destination.append(resource)
        file_name = dir.get_next()

func _load_resources_fallback(paths: Array, destination: Array):
    for path in paths:
        var resource = load(path)
        if resource and not destination.has(resource):
            destination.append(resource)

func start_game(grandma: GrandmaData):
    current_grandma = grandma
    current_score = 0
    get_tree().change_scene_to_file("res://scenes/game_level/GameScene.tscn")

func end_game():
    if current_score > high_score:
        high_score = current_score
    get_tree().change_scene_to_file("res://scenes/main_menu/MainMenu.tscn")

func unlock_grandma(grandma_id: String):
    for grandma in available_grandmas:
        if grandma.id == grandma_id:
            grandma.unlocked = true
            break
