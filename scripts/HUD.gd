extends CanvasLayer

signal action_selected(action: ActionData)

@onready var score_label: Label = $ScoreLabel
@onready var patience_label: Label = $PatienceLabel
@onready var hint_label: Label = $HintLabel
@onready var action_buttons_container: GridContainer = $ActionButtons
@onready var game_manager = get_node("/root/GameManager")

func _ready() -> void:
    setup_action_buttons()

func setup_action_buttons() -> void:
    for child in action_buttons_container.get_children():
        child.queue_free()

    for action in game_manager.available_actions:
        var item := VBoxContainer.new()
        item.custom_minimum_size = Vector2(225, 170)
        item.add_theme_constant_override("separation", 4)

        var image_button := TextureButton.new()
        image_button.custom_minimum_size = Vector2(225, 135)
        image_button.ignore_texture_size = true
        image_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
        image_button.texture_normal = action.texture
        image_button.tooltip_text = action.action_name
        image_button.pressed.connect(func() -> void: action_selected.emit(action))
        item.add_child(image_button)

        var label := Label.new()
        label.text = action.action_name
        label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        label.add_theme_font_size_override("font_size", 16)
        label.add_theme_color_override("font_color", Color("#3b3040"))
        item.add_child(label)
        action_buttons_container.add_child(item)

func update_score(score: int) -> void:
    score_label.text = "Pontos: " + str(score)

func update_patience(patience: int) -> void:
    patience_label.text = "Paciência: " + str(patience)

func show_needed_action_hint(action: ActionData) -> void:
    hint_label.text = "O bebê quer: " + action.action_name
    hint_label.show()
    await get_tree().create_timer(2.0).timeout
    if is_instance_valid(hint_label):
        hint_label.hide()
