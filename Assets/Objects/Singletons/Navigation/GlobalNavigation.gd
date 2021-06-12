extends Node

# Floor nodes for transfer, ordered 0 - 0.5 - 1
# Injected by PathNodes script
var _nodes = []
var ongoing_requests = {}

class NavigationRequest:
	var id: int
	var nodes: Array
	func init(id: int, nodes: Array):
		self.id = id
		self.nodes = nodes
		return self
		

func navigate(obj: Node2D, target: Vector2, speed: float, delta: float):
	var id = obj.get_instance_id()
	
	var request
	if ongoing_requests.has(id):
		request = ongoing_requests[id]
	else:
		request = NavigationRequest.new().init(id, _find_path(obj.position, target))
		ongoing_requests[id] = request
		
	var next_target = request.nodes[0]
	obj.global_position = obj.global_position.move_toward(next_target, speed * delta)
	
	if obj.global_position.distance_squared_to(next_target) < 0.001:
		request.nodes.pop_front()
		if len(request.nodes) == 0:
			ongoing_requests.erase(id)


func _find_path(pos: Vector2, target: Vector2) -> Array:
	var my_floor = _select_floor(pos)
	var target_floor = _select_floor(target)
	
	if my_floor == target_floor:
		return [target]
	
	var path = [_nodes[my_floor]]
	var f = my_floor
	while f != target_floor:
		f += 1 if target_floor > my_floor else -1
		path.push_back(_nodes[f])

	return path
	
	

func _select_floor(pos: Vector2) -> int:
	var best_dist = 9999.0
	var floor_index = -1
	for i in _nodes.size():
		var node = _nodes[i]
		var dist = abs(pos.y - node.y)
		if dist < best_dist:
			floor_index = i
			best_dist = dist
	return floor_index
	
