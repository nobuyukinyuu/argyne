' This class stores a set of values common to all particles which have initial and final values.
' you should be able to extend this class when implementing your own particle type; This 
' would allow you to add to the number of values that can be auto- tweened by Particle.Update().
'	-nobu
Import argyne

'Summary: Base class of particle values.
Class ParticleValues
	Field x:Float, y:Float          'Location
	Field dx:Float, dy:Float        'Delta position values
	Field gravX:Float, gravY:Float 	'Directional gravity
	
	Field scl:Float = 1         'Current scale value
	Field alpha:Float = 1       'Alpha value.

	Field angle:Float           'Angle
	Field spin:Float            'Amount of delta rotational spin

	'Summary:  Initializes based on a prototype.
	Method New(p:ParticleValues)
		Set(p)
	End Method
	
	'Summary:  Initializes based on a position.
	Method New(x:Float, y:Float)
		Self.x = x; Self.y = y
	End Method
	
	Method Clone:ParticleValues()
		Return New ParticleValues(Self)
	End Method

	'Summary:  Sets the values of the current ParticleValues to p.	
	Method Set:Void(p:ParticleValues)
		x = p.x; y = p.y
		dx = p.dx; dy = p.dy
		scl = p.scl
		alpha = p.alpha
		gravX = p.gravX; gravY = p.gravY
	End Method

	'Summary:  Sets the values of the current Particle values to a range between p and p2.
	Method Set:Void(p:ParticleValues, p2:ParticleValues, percent:Float)
		x = Range(p.x, p2.x, percent)
		y = Range(p.y, p2.y, percent)
		dx = Range(p.dx, p2.dx, percent)
		dy = Range(p.dy, p2.dy, percent)
		
		scl = Range(p.scl, p2.scl, percent)
		alpha = Range(p.alpha, p2.alpha, percent)
		
		angle = Range(p.angle, p2.angle, percent)
		spin = Range(p.spin, p2.spin, percent)
		
		gravX = Range(p.gravX, p2.gravX, percent)
		gravY = Range(p.gravY, p2.gravY, percent)
	End Method	

	'Summary:  Provides a ranged number between startValue and endValue with a percentage range 0-1.
	Function Range:Float(startValue:Float, endValue:Float, percent:Float)
		Return startValue + (percent * (endValue - startValue))
	End Function
End Class
