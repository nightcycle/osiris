--!strict
-- Services
-- Packages
local Osiris = require(game.ReplicatedStorage.Packages.package)
-- Modules
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
return function(frame: Frame)
	Osiris.Init(frame, nil, true)
	local cleanUp: () -> ()
	task.spawn(function()
		cleanUp = Osiris:Connect(function()
			local isOpenState = Osiris.State(true)
			Osiris.Widget.Window({
				Arguments = {
					Title = "Abc123",
				},
				States = {
					isOpened = isOpenState,
				},
			}, function(_)
				Osiris.Widget.Text({
					Arguments = {
						Text = "Hello!",
					},
				})
			end)
		end)
	end)

	return function()
		cleanUp()
	end
end
