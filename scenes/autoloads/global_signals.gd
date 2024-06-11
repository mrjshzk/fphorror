extends Node

signal item_picked_up(item: Item) ## called when item picked up TODO
signal item_swapped(current_item: Item) ## calls with the item that was swapped to
signal item_unloaded(unloaded_item: Item) ## calls when an item is being unloaded
signal item_dropped(dropped_item: Item) ## calls before dropping item

signal request_items ## call this to request the inventory
signal receive_items(items: Array[Item]) ## this will send the inventory 

