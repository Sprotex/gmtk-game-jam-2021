extends Node2D

export (Resource) var nameplate

onready var nameplateSprite = $Nameplate

func _ready():
	nameplateSprite.texture = nameplate
