--[[
    This module aims to solve the issues invloved with handling particle movement. 
    Originally, the user was expected to do most of the grunt work in terms of particle
    physics. However, it seems that the particle emitter should really have a standard way
    of dealing with the movement of its particles, this way the user can focus more on the
    look and feel of the particles.
]]

local ParticlePhysicsEngine = {}

function ParticlePhysicsEngine.new(emitter)
    local self = {}
    self.elementPosition = UDim2.new(0,0,0,0);
    self.particleSpawnPoint = emitter.hook.Position;
    self.particlePosition = Vector2.new(0, 0);
    self.particleVelocity = Vector2.new(0, 0);

    return setmetatable(self, {__index = ParticlePhysicsEngine});
end

function ParticlePhysicsEngine:Update(delta)

    self.particlePosition += self.particleVelocity;

    local relativeLocation = UDim2.new(
		UDim.new(0, self.particlePosition.X),
		UDim.new(0, self.particlePosition.Y)
	);

    -- Apply the forces
	self.elementPosition = self.particleSpawnPoint + relativeLocation; 
end

return ParticlePhysicsEngine