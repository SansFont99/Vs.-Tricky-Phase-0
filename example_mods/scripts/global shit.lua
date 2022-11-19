function onCreate()
	if boyfriendName == "bf-holding-gf" then
		setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-holding-gf-dead');
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
