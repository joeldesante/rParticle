local Particle = require(script.Particle);
local ParticleEmitter = {};

local function spawnParticle(emitter, particleElement, onSpawn)

	assert("The emitter element is invalid.", emitter);
	assert("The emitter hook is invalid.", emitter.hook);
	assert("The particle element is invalid.", particleElement);
	assert("The particle folder is invalid.", emitter.particleFolder:IsA("Folder"));

	local particle = Particle.new(particleElement:Clone(), emitter);
	particle.element.Parent = emitter.particleFolder;
	onSpawn(particle);
	return particle;
end

--[[
	Creates a new particle emitter.
	hook - This is the UI element which the particle emitter will latch on to.
	particleElement - This is the UI element which will be used as the particle.
]]
function ParticleEmitter.new(hook, particleElement)
	local self = {};
	self.particles = {};
	self.particleElement = particleElement;
	self.hook = hook;
	self.domain = Instance.new("Frame");
	self.particleFolder = Instance.new("Folder");
	self.rate = 5;

	self.onUpdate = function(p, d) end
	self.onSpawn = function(p) end

	-- Setup
	self.domain.Name = "_particleDomain";
	self.domain.BackgroundTransparency = 1;
	self.domain.Size = UDim2.new(1, 0, 1, 0);
	self.domain.Parent = self.hook.Parent;
	self.hook.Parent = self.domain;
	self.particleFolder.Name = "_particles";
	self.particleFolder.Parent = self.domain;

	-- Internal Values
	self.__dead = false;	-- True when the emitter is destroyed
	self.__elapsedTime = 0;
	self.__runServiceConnection = game:GetService("RunService").Heartbeat:Connect(function(delta)
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
		if self.rate > 0 and (self.__dead == false) then	-- Note: 1/0 results as `inf` in lua.
			while self.__elapsedTime >= (1/self.rate) do
				table.insert(self.particles, spawnParticle(self, self.particleElement, self.onSpawn));
				self.__elapsedTime = self.__elapsedTime - (1/self.rate);
			end
		end
	end)

	return setmetatable(self, {__index = ParticleEmitter});
end

--[[
	Destroys the particle emitter.
]]
function ParticleEmitter:Destroy()

	if self.__dead then
		error('Cannot destroy dead particle emitter.');
		return;
	end

	self.__dead = true;
	for _,particle in ipairs(self.particles) do
		if particle then
			particle:Destroy();	-- Flags all the particles for removal.
		end
	end

	-- Make disconnections
	if self.__runServiceConnection then
		self.__runServiceConnection:Disconnect();
	end
end

return ParticleEmitter;
