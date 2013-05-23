'This is where the ParticleEmitter resides.  It is a type of Particle which uses ParticleFactories
'to emit bursts of particles.    -nobu

Import argyne

'Summary:  An emitter of Particles.  Can also be a Particle itself.
Class ParticleEmitter Extends BaseParticle
	Field Particles:= New Stack<Particle>    'Particles currently emitting.
	Field f:ParticleFactory                  'Factory.  Creates Particle prototypes to choose from when emitting.

	Field LockToEmitter:Bool  'If True, all particles emitted are always rendered relative to this emitter's position.
	Field emitInterval:Int  'How long should the emitter wait before adding to the stack?
	Field lastEmission:Int  'When was the last time particle emission occurred?
	
	Field minBurst_i:Int = 1, maxBurst_i:Int = 1  'Number of particles generated per emission interval, initial
	Field minBurst_l:Int = 1, maxBurst_l:Int = 1  'Number of particles generated per emission interval, last

	'Summary:  Creates a basic emitter prototype.  ParticleEmitter.prototypes must be populated manually.
	Method New(ttl:Int, initialValues:ParticleValues = Null, finalValues:ParticleValues = Null)
		Super.New(ttl, initialValues, finalValues)
	End Method	
		
	'Summary: Creates an emitter which emits the prototype's particles.
	Method New(factory:ParticleFactory, interval:Int, ttl:Int = 500, LockParticlesToEmitter:Bool = False)
		Super.New(ttl, Self.initial, Self.last)
		f = factory
		SetEmissions(interval, 1, 1, 1, 1)
		LockToEmitter = LockParticlesToEmitter
		
	End Method
			
	Method Clone:Object()
		'Make a copy of this particle, but with a new startTime.
		Local p:= New ParticleEmitter(f, emitInterval, ttl, LockToEmitter)
		p.initial = initial.Clone(); p.current = initial.Clone(); p.last = last.Clone()
		p.SetEmissions(emitInterval, minBurst_i, maxBurst_i, minBurst_l, maxBurst_l)
		Return p
	End Method
	
	'Summary:  Sets the time between emissions, and how many particles to emit during each event.
	Method SetEmissions:Void(interval:Int, minBurst_i:Int, maxBurst_i:Int, minBurst_l:Int = -1, maxBurst_l:Int = -1)
		'Set last values to initial values if either of them = -1
		If minBurst_l = -1 Then minBurst_l = minBurst_i
		If maxBurst_l = -1 Then maxBurst_l = maxBurst_i
	
		emitInterval = interval
		Self.minBurst_i = minBurst_i; Self.minBurst_l = minBurst_l
		Self.maxBurst_i = maxBurst_i; Self.maxBurst_l = maxBurst_l
	End Method
	
	Method Update:Void()
		'Do normal checks
		Super.Update()
		If (Millisecs() -startTime) > ttl And Particles.IsEmpty() Then
			Self.isDead = True
			'Print "Emitter at (" + current.x + "," + current.y + "): Deactivating."
			Return
		Else
			Self.isDead = False  'Can't die until all of the child particles are dead too. Overrides Super.isDead
		End If

		'Check to see if we should do an emission
		If (Millisecs() -lastEmission >= emitInterval) And (Millisecs() -startTime < ttl) Then
			lastEmission = Millisecs()
			Emit()
		End If
		
		'Particle stack cleanup
		For Local i:Int = 0 Until Particles.Length
			Local o:Particle = Particles.Get(i)
			o.Update()
			If o.Dead Then Particles.Remove(i)
		Next
	End Method
	
	'Summary: Emits a burst of particles based on values specified by the emitter instance.
	Method Emit:Void()
		Local minPsPerEmission = ParticleValues.Range(minBurst_i, minBurst_l, percent)
		Local maxPsPerEmission = ParticleValues.Range(maxBurst_i, maxBurst_l, percent)
		Local amt:Int = Rnd(minPsPerEmission, maxPsPerEmission + 1) 'second value exclusive, we adjust to compensate
		'Print "Emitter at (" + current.x + "," + current.y + "): Emitting " + amt + " particles..."

		'Emit particles
		For Local i:Int = 1 To amt
			Local p:= f.Spawn()  'A particle blueprint
			'Print "OK. Start(" + p.Initial.x + "," + p.Initial.y + "), End(" + p.Last.x + "," + p.Last.y + ")"
			
			'If the particles are supposed to stay where they're at when the emitter moves, we need to modify
			'the prototype's initial and final values to represent the offset of the emitter at the time the 
			'particle was spawned.
			If LockToEmitter = False
				p.Translate(initial.x, initial.y, last.x, last.y)
				'p.initial.x += initial.x; p.last.x += last.x
				'p.initial.y += initial.y; p.last.y += last.y
			End If
			
			'Add the prototype particle to the emitter stack.			
			Particles.Push(p)
		Next
	End Method
	
	'Summary:  Renders the emitter's child particles.  Non-default values lock child particles to emitter position.
	Method Render:Void(xOffset:Float = 0, yOffset:Float = 0)
		For Local o:Particle = EachIn Particles
			'If the emitter is set to locked then render child particles relative to it, otherwise, don't.
			If LockToEmitter Then o.Render(current.x + xOffset, current.y + yOffset) Else o.Render(xOffset, yOffset)
		Next
	End Method
	
	Method RenderDebug:Void(xOffset:Float = 0, yOffset:Float = 0)
		'Debug draw origin
		If LockToEmitter Then
			DrawCircle(xOffset + current.x, yOffset + current.x, 8)
		Else
			DrawCircle(current.x, current.y, 8)
		End If
	End Method

	'Summary:  Manually sets the first and last positions to the specified position.
	Method SetPosition:Void(x:Float, y:Float)
		initial.x = x; initial.y = y
		current.x = x; current.y = y
		last.x = x; last.y = y
	End Method
	
End Class