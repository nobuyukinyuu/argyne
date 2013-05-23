'This is where the ParticleFactory interface goes.  Particle factories are used by emitters
'to spawn the particles needed by ParticleEmitters.

'TODO:  use particleValues to define ranges?  Initial range start/end, final range start/end.
'      challenge:  how to make end rely on start values so they're always x+n?

Import argyne

Interface ParticleFactory
	'Summary:  Spawns a single Particle.
	Method Spawn:Particle()	
End Interface

'Summary:  An attempt to create a factory to build other factories out of.  Don't emit these directly!  WIP!
Class BaseParticleFactory Implements ParticleFactory
	Field prototype:BaseParticle   'A retrievable prototype of the last particle spawned.
	Field pvp:= New ParticleValues()

	'The following fields define initial ranges that the spawned particle can be in.  When creating
	'the prototype, these values are used for the range that pvp specifies to the initial values.
	'The offset values specify how much the final values can stray from the initial values.
	Field ttl_lo:Int = 500, ttl_hi:Int = 750  'ttl range
	
	Field x_lo:Float, y_lo:Float          'Location
	Field x_hi:Float, y_hi:Float
	Field x_os:Float, y_os:Float

	Field dx_lo:Float, dy_lo:Float        'Delta position values
	Field dx_hi:Float, dy_hi:Float
	Field dx_os:Float, dy_os:Float
	
	Field gravX_lo:Float, gravY_lo:Float  'Directional gravity
	Field gravX_hi:Float, gravY_hi:Float
	Field gravX_os:Float, gravY_os:Float
		
	Field scl_lo:Float = 1                'Current scale value
	Field scl_hi:Float = 1, scl_os:Float
	
	Field alpha_lo:Float = 1              'Alpha value.
	Field alpha_hi:Float = 1
	Field alpha_os:Float

	Field angle_lo:Float                  'Angle
	Field angle_hi:Float, angle_os:Float

	Field spin_lo:Float                   'Amount of delta rotational spin
	Field spin_hi:Float, spin_os:Float
	
	Method New()
		
	End Method
	
	'Summary:  Spawns a BaseParticle using this class. Mainly only useful for extender classes as-is. Call Reroll instead.
	Method Spawn:Particle()
		Reroll()
		Return prototype.Clone()
	End Method
	
	'Summary:  Updates prototype and pvp to new base values.  Child classes should call this in Spawn first.
	Method Reroll:Void()
		'Set the initial values
		pvp.x = Rnd(x_lo, x_hi); pvp.y = Rnd(y_lo, y_hi)
		pvp.dx = Rnd(dx_lo, dx_hi); pvp.dy = Rnd(dy_lo, dy_hi)
		pvp.gravX = Rnd(gravX_lo, gravX_hi); pvp.gravY = Rnd(gravY_lo, gravY_hi)

		pvp.scl = Rnd(scl_lo, scl_hi)		
		pvp.alpha = Rnd(alpha_lo, alpha_hi)

		pvp.angle = Rnd(angle_lo, angle_hi)
		pvp.spin = Rnd(spin_lo, spin_hi)
		
		'Set the prototype's initial components
		prototype = New BaseParticle(Rnd(ttl_lo, ttl_hi))
		prototype.initial = pvp.Clone()
		prototype.current = pvp.Clone()
		prototype.last = pvp.Clone()
		
		'Set the final values to offsets of the initial values
		prototype.last.x += Rnd(x_os); prototype.last.y += Rnd(y_os)
		prototype.last.dx += Rnd(dx_os); prototype.last.dy = Rnd(dy_os)
		prototype.last.gravX += Rnd(gravX_os); prototype.last.gravY += Rnd(gravY_os)
		
		prototype.last.scl += Rnd(scl_os)
		prototype.last.alpha += Rnd(alpha_os)

		prototype.last.angle += Rnd(angle_os)
		prototype.last.spin += Rnd(spin_os)
				
	End Method
End Class