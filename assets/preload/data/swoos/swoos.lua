function opponentNoteHit()
    health = getProperty('health')
    if getProperty('health') > 0.05 then
        setProperty('health', health- 0.007);
    end
end