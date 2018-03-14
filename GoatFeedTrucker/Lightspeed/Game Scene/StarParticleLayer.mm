
#import "StarParticleLayer.h"


@implementation SlowParticleStar

-(id) init
{
	return [self initWithTotalParticles:150]; // A lot less Star flakes
}

-(id) initWithTotalParticles:(NSUInteger) numberOfParticles
{
	if( !(self=[super initWithTotalParticles:numberOfParticles]) )
		return nil;
	
	// duration
	duration = kCCParticleDurationInfinity;
	
	// gravity
	self.gravity = ccp(0,-10);
	
	// angle
	angle = -90;
	angleVar = 5;
	
	// speed of particles
	self.speed = 130;
	self.speedVar = 10;
	
	// radial
	self.radialAccel = 0;
	self.radialAccelVar = 1;
	
	// tagential
	self.tangentialAccel = 0;
	self.tangentialAccelVar = 1;
	
	// emitter position
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    self.contentSize = winSize;
	self.position = ccp(winSize.width/2, 0);
	posVar = ccp(winSize.width, 0);
	
	// life of particles
	life = 45;
	lifeVar = 25;
	
	// size, in pixels
	startSize = 6.0f;//10.0f;
	startSizeVar = 3.0f;//5.0f;
	endSize = kParticleStartSizeEqualToEndSize;
	
	// emits per second
	emissionRate = 10;
	
	// color of particles
	startColor.r = 1.0f;
	startColor.g = 1.0f;
	startColor.b = 1.0f;
	startColor.a = 0.6f;
	startColorVar.r = 0.0f;
	startColorVar.g = 0.0f;
	startColorVar.b = 0.0f;
	startColorVar.a = 0.0f;
	endColor.r = 1.0f;
	endColor.g = 1.0f;
	endColor.b = 1.0f;
	endColor.a = 0.0f;
	endColorVar.r = 0.0f;
	endColorVar.g = 0.0f;
	endColorVar.b = 0.0f;
	endColorVar.a = 0.0f;
	
	
	// additive
	self.blendAdditive = NO;
	
	return self;
}
@end

@implementation StarParticleLayer
@synthesize emitter;

-(id) init
{
	if( (self=[super init])) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite* background;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            background = [CCSprite spriteWithFile:@"background-ipad.png"];
        }
        else {
            if (winSize.height > 960/2)
            {
                CGPoint pos = ccp(0, (1136 - 960)/2/2);
                [self setPosition:pos];
            }
            winSize = CGSizeMake(640*0.5, 960*0.5);
            background = [CCSprite spriteWithFile:@"background.png"];
        }

        
        [background setPosition:ccp(winSize.width*0.5f, winSize.height*0.5f)];
        [self addChild: background z:-1];
     
        //add some planets to the background
        
        /*CCLayer* planetLayer = [CCLayer node];
        
        int numPlanets = 6;
        
        CGFloat planetDistance = 0.7f;
        
        for(int i = 1 ; i <= numPlanets; i++)
        {
            
            NSString* currPlanetString = [NSString stringWithFormat:@"planet%d.png", i];
            CCSprite* currPlanet = [CCSprite spriteWithFile:currPlanetString];
            
            int randX = CCRANDOM_0_1()* winSize.width;
            int randY = (i+1)* winSize.height*planetDistance + CCRANDOM_0_1() * winSize.height*0.1;
            currPlanet.position = ccp(randX, randY);
            
            CGFloat scale = 100/currPlanet.contentSize.width;
            [currPlanet setScale:scale];
            
            [planetLayer addChild:currPlanet];
        }
        
        id moveDown = [CCMoveBy actionWithDuration:60.0 position:ccp(0,-numPlanets*winSize.height*planetDistance*1.1f)];
        id moveUp = [CCCallBlock actionWithBlock:^{
            planetLayer.position = ccp(0,0);
        }];
        [self addChild:planetLayer];
        
        id moveSeq = [CCSequence actions:moveDown, moveUp, nil];
        [planetLayer runAction:[CCRepeatForever actionWithAction:moveSeq]];
        
        
        
        
		// Star emitter
		particleSystemSprite = (CCSprite*) self;
		self.emitter = [SlowParticleStar node]; // Slow Star fall
		
		[particleSystemSprite addChild: emitter z:500]; 
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		emitter.position = ccp(s.width/2, s.height);
		emitter.life = 4;
		emitter.lifeVar = 1;
		// gravity
		emitter.gravity = ccp(0,-30);
		
		// speed of particles
		emitter.speed = 800;
		emitter.speedVar = 100;
		
		ccColor4F startColor = emitter.startColor;
		startColor.r = 0.9f;
		startColor.g = 0.9f;
		startColor.b = 0.8f;
		emitter.startColor = startColor;
		
		ccColor4F startColorVar = emitter.startColorVar;
		startColorVar.b = 0.1f;
		emitter.startColorVar = startColorVar;
		
		emitter.emissionRate = emitter.totalParticles/emitter.life;
		
		emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];*/
	}
	return self;
}

- (void)update:(ccTime)dt {
}

@end
