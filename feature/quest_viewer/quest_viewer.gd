class_name QuestsDisplay
extends  Control


func open():
	if self.visible:
		close()
		return
	
	self.show()


func close():
	self.hide()
