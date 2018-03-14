
#import "StarParticle.h"


@implementation StarParticle

-(id) init
{
	return [self initWithTotalParticles:1500];
	
}

-(id) initWithTotalParticles:(NSUInteger) numberOfParticles
{
	if( !(self=[super initWithTotalParticles:numberOfParticles]) )
		return nil;
	
	// duration
	duration = 2.00f;
	
	self.emitterMode = kCCParticleModeGravity;
	
	// Gravity Mode: gravity
	self.gravity = ccp(0,0);
	
	// Gravity Mode: speed of particles
	self.speed = 160;
	self.speedVar = 20;
	
	// Gravity Mode: radial
	self.radialAccel = -120;
	self.radialAccelVar = 0;
	
	// Gravity Mode: tagential
	self.tangentialAccel = 30;
	self.tangentialAccelVar = 0;
	
	// angle
	angle = 90;
	angleVar = 360;
	
	// emitter position
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	self.position = ccp(winSize.width/2, winSize.height/2);
	posVar = CGPointZero;
	
	// life of particles
	life = 3.0f;
	lifeVar = 1;
	
	// spin of particles
	startSpin = 0;
	startSpinVar = 0;
	endSpin = 0;
	endSpinVar = 2000;
	
	// size, in pixels
	startSize = 30.0f;
	startSizeVar = 00.0f;
	endSize = kCCParticleStartSizeEqualToEndSize;
	
	
	// color of particles
	startColor.r = 0.5f;
	startColor.g = 0.5f;
	startColor.b = 0.5f;
	startColor.a = 1.0f;
	startColorVar.r = 0.5f;
	startColorVar.g = 0.5f;
	startColorVar.b = 0.5f;
	startColorVar.a = 1.0f;
	endColor.r = 0.1f;
	endColor.g = 0.1f;
	endColor.b = 0.1f;
	endColor.a = 0.2f;
	endColorVar.r = 0.1f;
	endColorVar.g = 0.1f;
	endColorVar.b = 0.1f;
	endColorVar.a = 0.2f;
	
	// emits per second
	emissionRate = totalParticles/duration;
	
	self.texture = [[CCTextureCache sharedTextureCache] addImage: @"starfart.png"];
	
	// additive
	self.blendAdditive = NO;
	
	return self;
}
@end
