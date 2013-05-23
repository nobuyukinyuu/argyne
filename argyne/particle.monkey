' This file contains the base particle class and the Particle interface.  
' All particles should inherit from BaseParticle under most circumstances.
' If you're looking for basic particles which can be used in your games, 
' or to make your own particle types from, see basic_particles.monkey.
'	-nobu

Import argyne

'Summary:  All particles must implement this interface.
Interface Particle
	'Particle values.
	Method Initial:ParticleValues() Property
	Method Initial:Void(value:ParticleValues) Property
	Method Current:ParticleValues() Property
	Method Current:Void(value:ParticleValues) Property
	Method Last:ParticleValues() Property
	Method Last:Void(value:ParticleValues) Property

	'Required members
	Method Dead:Bool() Property
	Method Dead:Void(value:Bool) Property
	
	'Required Methods		
	Method Clone:Object()
	Method Update:Void()
	Method Render:Void(xOffset:Float = 0, yOffset:Float = 0)
	
	'Summary:  Translates the position of the partlce in all ParticleValues
	Method Translate:Void(firstX:Float, firstY:Float, lastX:Float, lastY:Float)
End Interface

'Summary:  The base Particle implementing-class. 
Class BaseParticle Implements Particle
	Field initial:= New ParticleValues()  'Initial values to use as permenant prototype
	Field current:= New ParticleValues() 'Values on current update
	Field last:= New ParticleValues()  'Final values
			
	Field startTime:Int, ttl:Int  'Initial creation time and time to live
	
	Field isDead:Bool             'Is set to TRUE when ttl has elapsed, for easy cleanup.
	Field DT:Float = 1.0 / float(UpdateRate())  'Delta time target
	Field frames:Float, percent:Float  'The number of frames since epoch, and the amount of percent from epoch-ttl.

	'#Region Satisfy the Particle interface requirement.
	Method Initial:ParticleValues() Property 'Get
		Return initial
	End Method	
	Method Initial:Void(value:ParticleValues) Property 'Set
		initial = value
	End Method	
	Method Current:ParticleValues() Property 'Get
		Return current
	End Method	
	Method Current:Void(value:ParticleValues) Property 'Set
		current = value
	End Method	
	Method Last:ParticleValues() Property 'Get
		Return last
	End Method	
	Method Last:Void(value:ParticleValues) Property 'Set
		last = value
	End Method
	
	Method Dead:Bool() Property
		Return isDead
	End Method
	Method Dead:Void(value:Bool) Property
		isDead = value
	End Method
	'#End Region
	
		
	Method New(ttl = 500, initialValues:ParticleValues = Null, finalValues:ParticleValues = Null)
		startTime = Millisecs()  'Set start to now.
		Self.ttl = ttl
		If initialValues <> Null Then
			initial = initialValues
			current = initialValues.Clone()
		End If
		If finalValues <> Null Then
			last = finalValues
		Else  'Set final values to initial values, if initial values exist.
			If initialValues <> Null Then finalValues = initialValues.Clone()
		End If
		
	End Method
		
	Method Clone:Object()
		'Make a copy of this particle, but with a new startTime.
		Return New BaseParticle(ttl, initial.Clone(), last.Clone())
	End Method

	Method Update:Void()
		'Avoid a divide by zero; if ttl is 0 then we don't need to update anyway.
		If ttl = 0 Then
			isDead = True
			Return
		End If
		
		'All values use delta time, even the ones which would normally be frame-time.
		'To achieve this, an estimated number of "frames" is calculated since epoch.
		'The percentage is calculated similarly, as a value 0-1 from epoch to ttl.
		frames = (Millisecs() -startTime) / (DT * 1000.0)
		percent = (Millisecs() -startTime) / float(ttl)

		If percent >= 1 Then isDead = True
					
		'Update all values.
		current.Set(initial, last, percent)  'First, apply transitory percentage values.

		'Now, let's apply frame-based values to alter/tweak the current positions.
		'Apply gravity to the delta values.
		current.dx += (current.gravX * frames)
		current.dy += (current.gravY * frames)

		current.x += (current.dx * frames)  'Apply delta X forces.
		current.y += (current.dy * frames)  'Apply delta Y forces.
		
		current.angle += (current.spin * frames) 'Apply delta rotation.		
	End Method
	
	Method Render:Void(xOffset:Float = 0, yOffset:Float = 0)
		'NOTE:  Override me.	
	End Method

	Method Translate:Void(firstX:Float, firstY:Float, lastX:Float, lastY:Float)
		initial.x += firstX; initial.y += firstY
		last.x += lastX; last.y += lastY
	End Method
	
End Class
