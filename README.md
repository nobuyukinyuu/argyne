argyne
======
Superemitter particle system for Monkey.  Possibly undergoing a re-write in the near future!

![](http://i.imgur.com/hhiQ6nI.png)

###Features
* A "Super-emitter" interface-based design - All valid particles implement Particle, including emitters, which means that emitters act as particles, and can recursively spawn other emitters as if they were particles, as well.
* Linear tween capability of all base properties - As an interface requirement of Particle, there exist 3 copies of a base properties container -- The Current of which is automatically tweened on update between the first and last values. adding more properties is simple; all tools are exposed in the ParticleValues class.
* Frame-based iteration values exist as default ParticleValues, including delta-spin, delta-xy, and gravity. This is in addition to the delta-time based values of location, angle, scale, and alpha. These values iterate based on how many estimated frames have elapsed since the last update, providing flexibility to coders who prefer frame-time animation. These values can also be automatically tweened over the life of the particle.
* Factory-based particle emitting. Emitters take an argument of an object which implements ParticleFactory, which contains a method allowing the emitter to spawn particles according to factory specifications. Factories can spawn other emitters which can call on itself or other factories, and thus spawn emitters recursively to n levels.
* A particle manager which performs automatic memory management of particles available. Particles and emitters mark themselves Dead after ttl as an interface requirement of Particle, and ParticleManager cleans them up. Eventually, it will deal with both allocation and deallocation using brl.pool, but for now, things are allocated manually, and de-allocated by ParticleManger.
* Some basic all-purpose particles are included with the module to get you started.


###Coming Soon
* Curve easing for tweens
* Delay value in addition to ttl. Automatically delays the start of the behavior of a Particle until after the delay has passed.
* Some sort of animated particle class to the basic all-purposes included classes
* ParticleManager caller values for all particles, so a particular manager can manage the total number of particles and emitters in the system, and cycle out old ones when the manager's limit is reached (preventing cascade reactions).
* Resource pooling using brl.pool for optimal memory management.


###Donate
If you like this project, please consider giving a small donation to support further development.

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=RHZMPB4RL3T82&lc=US&item_name=Nobu%27s%20Monkey%2dX%20projects&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted)

