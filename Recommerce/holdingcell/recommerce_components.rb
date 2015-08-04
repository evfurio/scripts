Object.send(:remove_const, :GameStopRecomConditionPanelPOS) if Object.const_defined?(:GameStopRecomConditionPanelPOS)
Object.send(:remove_const, :GameStopRecomConditionPanelTab) if Object.const_defined?(:GameStopRecomConditionPanelTab)
Object.send(:remove_const, :GameStopRecomConditionCheckBoxList) if Object.const_defined?(:GameStopRecomConditionCheckBoxList)
Object.send(:remove_const, :GameStopRecomConditionCheckBoxItem) if Object.const_defined?(:GameStopRecomConditionCheckBoxItem)


# == Overview
# This class houses and provides finders for the valuation condition panel on Recommerce device valuation page (POS browser)

##-----------------------------------------------------------------------------
class GameStopRecomConditionPanelPOS < CommonComponent

    # Initializes variables.
    # === Parameters:
    # _tag_:: ToolTag of current tag
    def initialize(tag, browser)
        super(tag, browser)
        @item_h = create_hash(tag)
    end

    # Returns the condition at the specified index from the list
    # === Parameters:
    # _index_:: zero-based index of the product to be retrieved from the list.
    def at(index)
        $tracer.trace("\tAction: #{__method__}(#{index})")
        # NOTE: ToolTag is returned, no specific item class necessary.
        return GameStopRecomConditionPanelTab.new(ToolTag.new(@tag.find.td.className(create_ats_regex_string("ats-rcm-tab")).at(index), format_method(__method__), @browser))
    end

    # Returns the item seached for, given a particular key, ie. inner text of item -- must be exact.
    # NOTE: a ToolTag is returned.
    # === Parameters:
    # _key_:: inner text of item to be searched for - must be exact
    def find(key)
        $tracer.trace("\tAction: #{__method__}(\"#{key}\")")
        if @item_h.has_key?(key)
            return GameStopRecomConditionPanelTab.new(ToolTag.new(@tag.find.td.className(create_ats_regex_string("ats-rcm-tab")).at(@item_h[key].to_i), format_method(__method__), @browser))
        else
            raise Exception.new("key, #{key} not found in menu list")
        end
    end

    # Returns the number of items in the list.
    def length()
        # If there are no items, return 0 for the length.
        if(!@tag.find.td.exists)
            return 0
        end

        return @tag.find.td.length
    end

    private

    # Returns a hash list with the key being the menu item name.
    # === Parameters:
    # _tag_:: tag used to determine hash table
    def create_hash(tag)
        hash = {}
        menu_list = tag.find.td.className(create_ats_regex_string("ats-rcm-tab"))
        menu_length = menu_list.length
        for i in 0 .. menu_length - 1
          hash[menu_list[i].innerText.strip] = i
        end
        
      return hash
    end

end

class GameStopRecomConditionPanelTab < CommonComponent

	def initialize(tag)
		super(tag)
	end
	
	def check_all_that_apply_label
		$tracer.trace(format_method(__method__))
		return ToolTag.new(@tag.parent("table").tbody.div.className(create_ats_regex_string("ats-rcmvalexclbl")), format_method(__method__))
	end
	
	def check_all_that_apply_list
		$tracer.trace(format_method(__method__))
		return GameStopRecomConditionCheckBoxList.new(ToolTag.new(@tag.parent("table").tbody.div.className(create_ats_regex_string("ats-rcmvalexcllst")), format_method(__method__)))
	end
	
	def items_included_label
		$tracer.trace(format_method(__method__))
		return ToolTag.new(@tag.parent("table").tbody.div.className(create_ats_regex_string("ats-rcmvalinclbl")), format_method(__method__))
	end
	
	def items_included_list
		$tracer.trace(format_method(__method__))
		return GameStopRecomConditionCheckBoxList.new(ToolTag.new(@tag.parent("table").tbody.div.className(create_ats_regex_string("ats-rcmvalincllst")), format_method(__method__)))
	end

end

class GameStopRecomConditionCheckBoxList < CommonComponent
    # Initializes variables.
    # === Parameters:
    # _tag_:: ToolTag of current tag
    def initialize(tag)
        super(tag)
        @item_h = create_hash(tag)
    end

    # Returns the condition tab of the specified index from the list. 
    # === Parameters:
    # _index_:: zero-based index of the condition to be retrieved from the list.
    def at(index)
        $tracer.trace("\tAction: #{__method__}(#{index})")
        # NOTE: ToolTag is returned, no specific item class necessary.
        return GameStopRecomConditionCheckBoxItem.new(ToolTag.new(@tag.at(index).input, format_method(__method__)))
    end

    # Returns the condition seached for, given a particular key, ie. inner text of item -- must be exact.
    # NOTE: a ToolTag is returned.
    # === Parameters:
    # _key_:: inner text of condition to be searched for - must be exact
    def find(key)
        $tracer.trace("\tAction: #{__method__}(\"#{key}\")")
        if @item_h.has_key?(key)
            return GameStopRecomConditionCheckBoxItem.new(ToolTag.new(@tag.at(@item_h[key].to_i).input, format_method(__method__)))
        else
            raise Exception.new("key, #{key} not found in menu list")
        end
    end

    # Returns the number of items in the list.
    def length()
        # If there are no items, return 0 for the length.
        if(!@tag.find.td.exists)
            return 0
        end

        return @tag.find.td.length
    end

    private

    # Returns a hash list with the key being the menu item name.
    # === Parameters:
    # _tag_:: tag used to determine hash table
    def create_hash(tag)
        hash = {}
        menu_list = tag
        menu_length = menu_list.length
        for i in 0 .. menu_length - 1
          hash[menu_list[i].innerText.strip] = i
        end
        
      return hash
    end
end

class GameStopRecomConditionCheckBoxItem < CommonComponent
	def initialize(tag)
		super(tag)
	end
	
	def innerText
		return ToolTag.new(@tag.parent("div"), nil).innerText
	end
		
end


