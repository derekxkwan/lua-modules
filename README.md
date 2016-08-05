# lua-modules
modules for use with lua (5.2) - released under gpl v2.0

##heap.lua
min (or max) heap
* heap.dump() - print indices and values of heap
* heap.search(element) - returns index of first instance of element
* heap.push(element) - push element onto heap
* heap.pop() - delete top element from heap and return
* heap.delidx(index) - delete element by index
* heap.delelt(element) - delete element by value
* heap.heapify(table, "min" or "max") - heapify table with given type
* heap.settype("min" or "max") - set type 
* heap.gettype() - returns type
* heap.getsize() - returns size of heap
* heap.reset() - deletes all elements from heap
* heap.merge(heap2) - adds heap2's elements with current heap
