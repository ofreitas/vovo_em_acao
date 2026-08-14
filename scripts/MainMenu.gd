extends Control

@onready var grandma_list: VBoxContainer = $GrandmaList
@onready var high_score_label: Label = $HighScoreLabel
@onready var game_manager = get_node("/root/GameManager")

func _ready() -> void:
    high_score_label.text = "Recorde: " + str(game_manager.high_score)
    setup_grandma_selection()

func setup_grandma_selection() -> void:
    for child in grandma_list.get_children():
        child.queue_free()

    for grandma in game_manager.available_grandmas:
        grandma.unlocked = true
        grandma_list.add_child(_create_grandma_card(grandma))

func _create_grandma_card(grandma: GrandmaData) -> PanelContainer:
    var card := PanelContainer.new()
    card.custom_minimum_size = Vector2(640, 285)

    var row := HBoxContainer.new()
    row.add_theme_constant_override("separation", 22)
    card.add_child(row)

    var portrait := TextureRect.new()
    portrait.custom_minimum_size = Vector2(250, 255)
    portrait.texture = grandma.texture
    portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    row.add_child(portrait)

    var details := VBoxContainer.new()
    details.add_theme_constant_override("separation", 10)
    details.alignment = BoxContainer.ALIGNMENT_CENTER
    row.add_child(details)

    var name_label := Label.new()
    name_label.text = grandma.grandma_name
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.add_theme_font_size_override("font_size", 34)
    name_label.add_theme_color_override("font_color", Color("#4a2545"))
    details.add_child(name_label)

    var description := Label.new()
    description.text = grandma.description
    description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    description.custom_minimum_size = Vector2(330, 62)
    description.add_theme_font_size_override("font_size", 20)
    description.add_theme_color_override("font_color", Color("#5d4a5a"))
    details.add_child(description)

    var play_button := Button.new()
    play_button.text = "Jogar com " + grandma.grandma_name.replace("Vovó ", "")
    play_button.custom_minimum_size = Vector2(330, 64)
    play_button.add_theme_font_size_override("font_size", 21)
    play_button.pressed.connect(func() -> void: game_manager.start_game(grandma))
    details.add_child(play_button)

    return card
