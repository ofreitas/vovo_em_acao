extends Node2D

@onready var baby = $Baby
@onready var hud = $HUD
@onready var action_timer = $ActionTimer
@onready var game_manager = get_node("/root/GameManager")

var needed_action: ActionData
var current_patience: int
var game_active: bool = false
var round_duration: float = 5.0

func _ready() -> void:
    setup_game()

func setup_game() -> void:
    var grandma: GrandmaData = game_manager.current_grandma
    current_patience = grandma.patience if grandma else 3
    round_duration = _get_round_duration()
    hud.update_patience(current_patience)
    hud.update_score(0)
    start_round()

func _get_round_duration() -> float:
    var score_factor := minf(float(game_manager.current_score) * 0.08, 2.5)
    var duration := 5.0 - score_factor
    if game_manager.current_grandma and game_manager.current_grandma.id == "terezinha":
        duration *= 0.72
    return maxf(duration, 1.5)

func start_round() -> void:
    game_active = true
    baby.set_state("CRYING")
    var actions: Array[ActionData] = game_manager.available_actions
    if actions.size() > 0:
        needed_action = actions[randi() % actions.size()]
        hud.show_needed_action_hint(needed_action)
    action_timer.start(_get_round_duration())

func _on_action_timer_timeout() -> void:
    if game_active:
        handle_fail()

func handle_action_selected(action: ActionData) -> void:
    if not game_active:
        return
    if action.id == needed_action.id:
        handle_success()
    else:
        handle_fail()

func handle_success() -> void:
    action_timer.stop()
    game_manager.current_score += 10
    hud.update_score(game_manager.current_score)
    baby.set_state("HAPPY")
    game_active = false
    await get_tree().create_timer(1.5).timeout
    start_round()

func handle_fail() -> void:
    action_timer.stop()
    current_patience -= 1
    hud.update_patience(current_patience)
    if current_patience <= 0:
        game_over()
    else:
        baby.set_state("HAPPY")
        game_active = false
        await get_tree().create_timer(1.0).timeout
        start_round()

func game_over() -> void:
    game_active = false
    game_manager.end_game()
