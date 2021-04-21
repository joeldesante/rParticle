local ParticlePhysicsEngine = require(script.ParticlePhysicsEngine)
local Particle = {};

function Particle.new(element, emitter)
	local self = {};
	self.element = element;
	self.physics = ParticlePhysicsEngine.new(emitter);
	self.age = 0;
	self.ticks = 0;
	self.maxAge = 1;
	self.isDead = false;

	return setmetatable(self, {__index = Particle});
end

function Particle:Update(delta, onUpdate)
	
	if self.age >= self.maxAge then 
		self:Destroy()
		return;
	end;

	-- Update some properties
	self.ticks = self.ticks + 1;
	self.age = self.age + delta;	-- Make it a little older

	-- Callback
	onUpdate(self, delta)
	
	self.physics:Update(delta);
	self.element.Position = self.physics.elementPosition; 

end

function Particle:Destroy()
	self.isDead = true;
	self.element:Destroy();
end

return Particle;
