'Example project demonstrating argyne capabilities

Import mojo
Import argyne

Function Main:Int()
	New Game()
End Function

Class Game Extends App
	Field p:= New ParticleManager()
	Field f:= New SolidParticleFactory(128, 0, 255, 255, 16, 128)
	Field e:ParticleEmitter
	
	Method OnCreate:Int()
		SetUpdateRate 60
				
		'Set up the emitter
		e = New ParticleEmitter(f, 5000, 1)
		e.SetEmissions(e.emitInterval, 30, 50)
	End Method
	
	Method OnUpdate:Int()
		p.Update()   'Update the entire system.
	
		If MouseDown()
			e.SetPosition(MouseX(), MouseY())  'Set the emitter prototype's position.	
			Local ep:= ParticleEmitter(e.Clone())  'Emitter clone
			ep.Emit()  'Force an emission.
			p.Emitters.Push(ep)  'Add the emitter clone to the manager's emitter stack.
		End If


		If KeyHit(KEY_ESCAPE) or KeyHit(KEY_CLOSE) Then Error("")
	End Method
	
	Method OnRender:Int()
		Cls()
		
		p.Render()
	End Method
End Class