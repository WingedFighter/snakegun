@tool
extends Control

var menu_bar: MenuBar
var add_menu: PopupMenu
var context_menu: PopupMenu
var delete_button: Button
var save_button: Button
var graph_data: GraphData
var graph_save_location: String
var last_left_click: Vector2

#TODO: Add update link when actively connected and an edit is made

var add_types: Dictionary = {}:
    set(value):
        if value != {}:
            add_types = value
            if is_instance_valid(menu_bar):
                menu_bar.queue_free()
            if is_instance_valid(add_menu):
                add_menu.queue_free()
            if is_instance_valid(delete_button):
                delete_button.queue_free()
            if is_instance_valid(save_button):
                save_button.queue_free()
            add_index = []
            for type in add_types:
                add_index.append(type)
            make_popups()

var add_index: Array = []

var selected_nodes: Dictionary = {}

func _enter_tree() -> void:
    var graph = $TalkGraph
    graph.node_selected.connect(on_node_selected)
    graph.node_deselected.connect(on_node_deselected)
    graph.connection_request.connect(on_connection_request)
    graph.delete_nodes_request.connect(delete_captured)
    graph.popup_request.connect(show_context_menu)
    make_popups()

func _exit_tree() -> void:
    save_graph()

func show_context_menu(p_position: Vector2) -> void:
    if !context_menu:
        context_menu = make_add_menu($TalkGraph)
        context_menu.index_pressed.connect(on_add_index_pressed.bind(true))
    last_left_click = p_position
    context_menu.position = global_position + p_position
    context_menu.show()

func make_add_menu(parent: Node) -> PopupMenu:
    var temp_menu = PopupMenu.new()
    parent.add_child(temp_menu)
    temp_menu.name = "Add"
    var index = 0
    for type in add_types:
        temp_menu.add_item(type)
    return temp_menu

func make_popups() -> void:
    var graph  = $TalkGraph
    if !menu_bar:
        menu_bar = MenuBar.new()
        graph.get_menu_hbox().add_child(menu_bar)
    if !add_menu:
        add_menu = make_add_menu(menu_bar)
        add_menu.index_pressed.connect(on_add_index_pressed)
    if !delete_button:
        delete_button = Button.new()
        graph.get_menu_hbox().add_child(delete_button)
        delete_button.text = "Delete"
        delete_button.pressed.connect(on_delete_pressed)
    if !save_button:
        save_button = Button.new()
        graph.get_menu_hbox().add_child(save_button)
        save_button.text = "Save"
        save_button.pressed.connect(on_save_pressed)

func get_graph_element_from_name(p_name: StringName) -> GraphNode:
    var graph = $TalkGraph
    for child in graph.get_children():
        if child.name == p_name:
            return child
    return

func get_graph_element_from_id(p_id: String) -> GraphNode:
    var graph = $TalkGraph
    for child in graph.get_children():
        if child is TalkBasic:
            if child.id == p_id:
                return child
    return

func on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
    var graph = $TalkGraph
    var from_child = get_graph_element_from_name(from_node)
    var to_child = get_graph_element_from_name(to_node)
    var from_type = get_graph_element_type_as_string(from_child)
    var to_type = get_graph_element_type_as_string(to_child)
    for connection in graph.get_connection_list():
        if connection.to_node == to_node and connection.to_port == to_port:
            if to_type == "TalkBasic" || to_type == "TalkChoice" || to_type == "TalkBranch" || to_type == "TalkSetFlag" || to_type == "TalkEnd":
                if from_type == "TalkBasic":
                    if from_child.next_id != "-1":
                        return
                if from_type == "TalkChoice":
                    if from_child.check_choice_set(from_port):
                        return
                if from_type == "TalkBranch":
                    if from_port == 0:
                        if from_child.true_next_id != "-1":
                            return
                    if from_port == 1:
                        if from_child.false_next_id != "-1":
                            return
                if from_type == "TalkSetFlag":
                    if from_child.next_id != "-1":
                        return
            else:
                return
        if connection.from_node == from_node && connection.from_port == from_port:
            return
    graph.connect_node(from_node, from_port, to_node, to_port)
    match(from_type):
        "TalkBasic":
            if to_type == "TalkBasic" || to_type == "TalkChoice" || to_type == "TalkBranch" || to_type == "TalkSetFlag" || to_type == "TalkEnd":
                from_child.set_next_id(to_child.id)
        "TalkMessage":
            if to_type == "TalkBasic":
                to_child.set_message(from_child.id, to_port)
        "TalkChoice":
            if to_type == "TalkBasic" || to_type == "TalkChoice" || to_type == "TalkBranch" || to_type == "TalkSetFlag" || to_type == "TalkEnd":
                from_child.set_next_id(to_child.id, from_port)
        "TalkBranch":
            if to_type == "TalkBasic" || to_type == "TalkChoice" || to_type == "TalkBranch" || to_type == "TalkSetFlag" || to_type == "TalkEnd":
                from_child.set_next_id(to_child.id, from_port)
        "TalkSetFlag":
            if to_type == "TalkBasic" || to_type == "TalkChoice" || to_type == "TalkBranch" || to_type == "TalkSetFlag" || to_type == "TalkEnd":
                from_child.set_next_id(to_child.id)
        "TalkStart":
            if to_type == "TalkBasic" || to_type == "TalkChoice" || to_type == "TalkBranch" || to_type == "TalkSetFlag" || to_type == "TalkEnd":
                from_child.set_next_id(to_child.id)

func on_add_index_pressed(index: int, p_offset: bool = false) -> void:
    add_new_graph_node(add_index[index], p_offset)

func delete_captured(nodes: Array[StringName]) -> void:
    for node in nodes:
        delete_node(get_graph_element_from_name(node))

func on_delete_pressed() -> void:
    for node in selected_nodes:
        if selected_nodes[node] && is_instance_valid(node):
            delete_node(node)
    selected_nodes = {}

func on_save_pressed() -> void:
    save_graph()

func delete_node(node: GraphNode) -> void:
    if is_instance_valid(node):
        for connection in $TalkGraph.get_connection_list():
            if connection.from_node == node.name || connection.to_node == node.name:
                $TalkGraph.disconnect_node(connection.from_node, connection.from_port, connection.to_node, connection.to_port)
                var from_child = get_graph_element_from_name(connection.from_node)
                var to_child = get_graph_element_from_name(connection.to_node)
                var from_type = get_graph_element_type_as_string(from_child)
                var to_type = get_graph_element_type_as_string(to_child)
                match(from_type):
                    "TalkBasic":
                        if to_type == "TalkBasic" || to_type == "TalkChoice" || to_type == "TalkBranch" || to_type == "TalkSetFlag" || to_type == "TalkEnd":
                            from_child.set_next_id("-1")
                    "TalkMessage":
                        if to_type == "TalkBasic":
                            to_child.delete_message(from_child.id)
                    "TalkChoice":
                        if to_type == "TalkBasic" || to_type == "TalkChoice" || to_type == "TalkBranch" || to_type == "TalkSetFlag" || to_type == "TalkEnd":
                            from_child.set_next_id("-1", connection.from_port)
                    "TalkBranch":
                        if to_type == "TalkBasic" || to_type == "TalkChoice" || to_type == "TalkBranch" || to_type == "TalkSetFlag" || to_type == "TalkEnd":
                            from_child.set_next_id("-1", connection.from_port)
                    "TalkSetFlag":
                        if to_type == "TalkBasic" || to_type == "TalkChoice" || to_type == "TalkBranch" || to_type == "TalkSetFlag" || to_type == "TalkEnd":
                            from_child.set_next_id("-1")
                    "TalkStart":
                        if to_type == "TalkBasic" || to_type == "TalkChoice" || to_type == "TalkBranch" || to_type == "TalkSetFlag" || to_type == "TalkEnd":
                            from_child.set_next_id("-1")
        node.free()

func add_new_graph_node(type: String, p_offset: bool = false) -> void:
    var node: GraphNode = add_types[type].instantiate()
    var graph = $TalkGraph
    graph.add_child(node, true)
    if !p_offset:
        node.position_offset.x = graph.scroll_offset.x + (size.x / 2) - (node.size.x / 2)
        node.position_offset.y = graph.scroll_offset.y + (size.y / 2) - (node.size.y / 2)
    else:
        node.position_offset.x = graph.scroll_offset.x + last_left_click.x
        node.position_offset.y = graph.scroll_offset.y + last_left_click.y
    node.delete_request.connect(delete_node.bind(node))
    if node is TalkChoice:
        node.line_list_resource = TalkListResource.new()
    if node is TalkMessage:
        node.line_resource = TalkLinesResource.new()

func on_node_selected(node: Node) -> void:
    if node is TalkMessage:
        EditorInterface.edit_resource(node.line_resource)
    if node is TalkChoice:
        EditorInterface.edit_resource(node.line_list_resource)
    selected_nodes[node] = true

func on_node_deselected(node: Node) -> void:
    selected_nodes[node] = false

func load_talk_manager(manager: TalkManager) -> void:
    if !manager:
        return
    graph_save_location = manager.graph_data_save_location
    load_graph_data()
    init_graph(graph_data)
    save_graph()

func init_graph(graph_data: GraphData) -> void:
    clear_graph()
    for node in graph_data.nodes:
        var g_node = add_types[node.type].instantiate()
        g_node.position_offset = node.position_offset
        g_node.name = node.name
        g_node.id = node.data.id
        match(node.type):
            "TalkBasic":
                for message in node.data.message_list:
                    g_node.add_new_message(message)
            "TalkMessage":
                g_node.set_line_id(node.data.line_id)
                g_node.set_character_id(node.data.character_id)
                g_node.set_expression(node.data.expression)
                g_node.line_resource = TalkLinesResource.new()
                g_node.set_lines(node.data.lines)
            "TalkChoice":
                for choice in node.data.choice_list:
                    g_node.add_new_choice(choice)
                g_node.line_list_resource = TalkListResource.new()
                g_node.line_list_resource.lines_list = node.data.line_list
            "TalkBranch":
                g_node.set_flag_name(node.data.flag_name)
            "TalkSetFlag":
                g_node.set_flag_name(node.data.flag_name)
                g_node.set_flag_value(node.data.flag_value)
        $TalkGraph.add_child(g_node, true)
    for node in graph_data.nodes:
        var g_node = get_graph_element_from_name(node.name)
        match(node.type):
            "TalkBasic":
                g_node.set_next_id(node.data.next_id)
            "TalkChoice":
                var index = 0
                for n_id in node.data.next_id_list:
                    g_node.set_next_id(node.data.next_id_list[n_id], index)
                    index += 1
            "TalkBranch":
                g_node.set_next_id(node.data.true_next_id, 0)
                g_node.set_next_id(node.data.false_next_id, 1)
            "TalkSetFlag":
                g_node.set_next_id(node.data.next_id)
            "TalkStart":
                g_node.set_next_id(node.data.next_id)
    for connection in graph_data.connections:
        $TalkGraph.connect_node(connection.from_node, connection.from_port, connection.to_node, connection.to_port)

func clear_graph() -> void:
    var graph = $TalkGraph
    graph.clear_connections()
    for node in graph.get_children():
        if node is GraphNode:
            delete_node(node)

func save_graph() -> void:
    save_graph_data($TalkGraph.get_children(), $TalkGraph.get_connection_list())

func save_graph_data(nodes: Array, connections: Array) -> void:
    var n_graph_data = GraphData.new()
    n_graph_data.connections = connections
    for node in nodes:
        if node is GraphNode:
            var node_data = NodeData.new()
            node_data.name = node.name
            node_data.type = get_graph_element_type_as_string(node)
            match(node_data.type):
                "TalkBasic":
                    node_data.data.id = node.id
                    node_data.data.next_id = node.next_id
                    node_data.data.message_list = node.message_list
                "TalkMessage":
                    node_data.data.id = node.id
                    node_data.data.line_id = node.line_id
                    node_data.data.character_id = node.character_id
                    node_data.data.expression = node.expression
                    node_data.data.lines = node.line_resource.lines
                "TalkChoice":
                    node_data.data.id = node.id
                    node_data.data.choice_list = node.choice_list
                    node_data.data.next_id_list = node.next_id_list
                    node_data.data.line_list =  node.line_list_resource.lines_list
                "TalkBranch":
                    node_data.data.id = node.id
                    node_data.data.flag_name = node.flag_name
                    node_data.data.true_next_id = node.true_next_id
                    node_data.data.false_next_id = node.false_next_id
                "TalkSetFlag":
                    node_data.data.id = node.id
                    node_data.data.next_id = node.next_id
                    node_data.data.flag_name = node.flag_name
                    node_data.data.flag_value = node.flag_value
                "TalkStart":
                    node_data.data.id = node.id
                    node_data.data.next_id = node.next_id
                "TalkEnd":
                    node_data.data.id = node.id
            node_data.position_offset = node.position_offset
            # node data
            n_graph_data.nodes.append(node_data)
    if ResourceSaver.save(n_graph_data, graph_save_location) == OK:
        graph_data = graph_data
    else:
        print ("Error saving data")

func load_graph_data() -> void:
    if ResourceLoader.exists(graph_save_location):
        var g_data = ResourceLoader.load(graph_save_location)
        if g_data is GraphData:
            graph_data = g_data
        else:
            graph_data = GraphData.new()
    else:
        graph_data = GraphData.new()

func get_graph_element_type_as_string(node: GraphNode) -> String:
    if !node:
        return ""
    if node is TalkBranch:
        return "TalkBranch"
    elif node is TalkBasic:
        return "TalkBasic"
    elif node is TalkMessage:
        return "TalkMessage"
    elif node is TalkChoice:
        return "TalkChoice"
    elif node is TalkSetFlag:
        return "TalkSetFlag"
    elif node is TalkStart:
        return "TalkStart"
    elif node is TalkEnd:
        return "TalkEnd"
    return ""