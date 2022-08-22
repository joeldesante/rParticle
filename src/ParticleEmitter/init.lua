local Particle = require(script.Particle);
local ParticleEmitter = {};

local function spawnParticle(hook, particleElement, onSpawn)
	local particle = Particle.new(particleElement:Clone());
	particle.element.Parent = hook;
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
	self.rate = 5;

	self.onUpdate = function(p, d) end
	self.onSpawn = function(p) end

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
				self:Emit(1)
				self.__elapsedTime = self.__elapsedTime - (1/self.rate);
			end
		end
	end)

	return setmetatable(self, {__index = ParticleEmitter});
end

--[[
	Emits particle(s) given a count
]]
function ParticleEmitter:Emit(count)
	if count < 1 then return {} end
	for _=count,1,-1 do
		table.insert(self.particles, spawnParticle(self.hook, self.particleElement, self.onSpawn));
	end
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
