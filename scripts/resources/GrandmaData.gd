extends Resource
class_name GrandmaData

@export var id: String = ""
@export var grandma_name: String = ""
@export var description: String = ""
@export var texture: Texture2D
@export var speed: float = 100.0
@export var wisdom: float = 0.0 # Bônus para tempo ou dicas
@export var patience: int = 3 # Quantidade de erros que pode cometer
@export var unlocked: bool = false
