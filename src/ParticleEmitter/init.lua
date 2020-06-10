local Particle = require(script.Particle);
local ParticleEmitter = {};

local function spawnParticle(hook, onSpawn)
	local particle = Particle.new(game.ReplicatedStorage.Particle:Clone());
	particle.element.Parent = hook;
	onSpawn(particle);
	return particle;
end

function ParticleEmitter.new(hook)
	local self = {};
	self.particles = {};
	self.hook = hook;
	self.rate = 5;

	self.onUpdate = function(p, d) end
	self.onSpawn = function(p) end

	-- Internal Values
	self.__elapsedTime = 0;

	game:GetService("RunService").RenderStepped:Connect(function(delta)
		self.__elapsedTime = self.__elapsedTime + delta;	
		for index, particle in ipairs(self.particles) do
			if particle.isDead then 
				table.remove(self.particles, index);
			else
				particle:Update(delta, self.onUpdate);
			end
		end
		
		--[[
			This loop will time the particle spawns so that the
			given rate can be achieved.
		]]
		while self.__elapsedTime >= (1/self.rate) do
			table.insert(self.particles, spawnParticle(self.hook, self.onSpawn));
			self.__elapsedTime = self.__elapsedTime - (1/self.rate);
		end
	end)

	return setmetatable(self, {__index = ParticleEmitter});
end

return ParticleEmitter;
