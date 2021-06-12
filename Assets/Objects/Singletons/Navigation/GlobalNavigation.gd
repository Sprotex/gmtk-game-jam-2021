extends Node

# Floor nodes for transfer, ordered 0 - 0.5 - 1
# Injected by PathNodes script
var _nodes = []
var ongoing_requests = {}

func navigate(pos: Vector2, target: Vector2, speed: Vector2) -> Vector2:
	return pos
