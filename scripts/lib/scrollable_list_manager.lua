---@class ScrollableListManager
local List = {}
List.__index = List

function List.new (count, visible_items)
    return setmetatable({
        cursor = 1,
        count = count,
        visible_items = visible_items,
        cursor_position = math.ceil(visible_items / 2)
    }, List)
end

function List:move_cursor_up ()
    if self.cursor > 1 then
        self.cursor = self.cursor - 1
    else
        self.cursor = self.count
    end
end

function List:move_cursor_down ()
    if self.cursor < self.count then
        self.cursor = self.cursor + 1
    else
        self.cursor = 1
    end
end

function List:get_first_visible_index ()
    local last_index = self.count

    -- If there aren't enough items to fill the screen, we start at 1.
    if last_index <= self.visible_items then return 1 end

    -- If the cursor hasn't reached the center, we start at one.
    if self.cursor < self.cursor_position then return 1 end

    -- If there aren't enough items to fill the lower part, the highest item
    -- that allows seeing the end of the List.
    if self.cursor > last_index - (self.visible_items - self.cursor_position) then
        return (last_index - self.visible_items) + 1
    end

    -- The cursor minus the amount of items visible above it.
    return self.cursor - (self.cursor_position - 1)
end

function List:get_cursor_screen_position ()
    local last_index = self.count

    -- All items fit on the screen, so the visual matches its logical position.
    if last_index <= self.visible_items then return self.cursor end

    -- The cursor is above the center, so visual matches logical position.
    if self.cursor < self.cursor_position then return self.cursor end

    -- There aren't enough items at the tail to place the selected one in the
    -- center. When selecting the last item, the cursor is at the last position.
    if self.cursor > last_index - (self.visible_items - self.cursor_position) then
        return self.visible_items - (last_index - self.cursor)
    end

    -- The cursor is in the center of the screen
    return self.cursor_position
end

return List
