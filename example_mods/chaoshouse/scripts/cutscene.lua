local seenStickC = false

function onStartCountdown()

    if songName == 'stick' and not seenStickC then
        seenStickC = true

        startVideo('StickCutscene')

        return Function_Stop
    end
end

function onEndSong()
    seenStickC = false;
end