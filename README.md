# rParticle
Super light weight and highly customizable 2D particle system for Roblox.

## Documentation
Below is the basic docs needed to use rParticle.

### Installation
Import the Roblox Module into Replicatedstorage:
  1. Right click **ReplicatedStorage** (or where ever you want to install the module).
  2. Click **Insert from File**.
  3. Select the module (which can be downloaded [here](https://github.com/JoelDesante/rParticle/releases))
  
### Usage
rParticle is very unintrusive. The idea behind the module is to give the developer as much control as possible on how the particles act.

In order to achive this, there are a few properties that are exposed to the user.

**Particle Emitter** *Object* This object handles the spawning, tracking, and destruction of Particles
```
  ParticleEmitter.particles:
    default = Array
    Even though this property is considered a public property. It should be considered as a READ ONLY
    property. Modifying this array directly could lead to unexpected results.
  
  ParticleEmitter.hook:
    default: Set by constructor.
    The parent property that particles will spawn out of. Typically this object is a Frame.
  
  ParticleEmitter.rate: 
    default = 5
    How many particles will be spawned per second.

  ParticleEmitter.onUpdate(particle, deltaTime):
    This function is called when a particle is updated. Particle manipulation should be done here.
  
  ParticleEmitter.onSpawn(particle)
    This function is called when a particle is spawned. Particle manipulation should be done here.

  ParticleEmitter.__elapsedTime:
    Private Property
    This property tracks the ammount of elapsed time has occured since the last particle has spawned. 
    This properies values are fairly unpredictable. Changing the value will cause problems with spawning.
    Using this property is NOT recomended as it is for internal use only.
    
```


**Particle** *Object* This object represents a Particle.
```
  Particle.element: GUIElement
    Represents the GUIElement which makes up the particle.
    
	Particle.position: Vector2
    default: Vector2.new(0,0)
    
	Particle.velocity: Vector2
    default Vector2.new(0,0)
    
	Particle.age: Number
    READ ONLY
    This represents the time in seconds that the particle has been alive for.
    It is not recommended that this property is overriden or changed.
  
	Particle.ticks: Number
    READ ONLY
    This represents the number of updates that have elapsed during the tme the particle has been alive.
  
	Particle.maxAge: Number
    default: 1
    The max amount of time in seconds the particle will exist. Once age equals or surpasses this value the
    particle will be flagged as DEAD.
  
	Particle.isDead: Boolean
    default: false
    The flg that determines if the particle is ALIVE or DEAD. If this value is true, the update loop 
    will call the destroy function.
    
```
