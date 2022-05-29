function onCreate()
	if boyfriendName == "bfAndGF" then
		setPropertyFromClass('GameOverSubstate', 'characterName', 'bfHoldingGF-DEAD');
	end
end

function opponentNoteHit()
	if dadName == "TrickyPhase1.5" then
		triggerEvent('Screen Shake', '0.25,0.006')
	end

	health = getProperty('health')
	if getProperty('health') > 0.4 then
		setProperty('health', health - 0.017);
	end
end
