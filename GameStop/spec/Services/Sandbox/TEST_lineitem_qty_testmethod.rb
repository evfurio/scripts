class TestLineItems

	def lineitem_qty_list
		sku1 = "270434"
		sku2 = "980797"
		sku3 = "696b741"
		sku4 = "2a4ad27"
		lineitemsarray = [sku1, sku2, sku3, sku4]
		qty = 1
		increaseby = 4
		lineitems = Hash[lineitemsarray.map { |x| [x, qty]}]
		numoflineitems = lineitems.size
		
		if numoflineitems > 1
			lineitemtwo = lineitemsarray[1] 
			lineitems[lineitemtwo] = qty + increaseby
			puts lineitems
		end
	end	
end

m = TestLineItems.new
m.lineitem_qty_list

