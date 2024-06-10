extends Node

signal item_picked_up(item_res: Item)
signal item_dropped()

signal request_items
signal receive_items(items: Array[Item])

