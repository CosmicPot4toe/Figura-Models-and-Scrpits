--for key, value in pairs(vanilla_model) do
--    value.setEnabled(false)
--end

function render(delta)
    model.NO_PARENT_Train.setPos(vectors.worldToPart(player.getPos(delta)))  
end