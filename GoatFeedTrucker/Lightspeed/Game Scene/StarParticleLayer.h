#import "cocos2d.h"

@interface SlowParticleStar : CCParticleSystemPoint {
	
}

@end

@interface StarParticleLayer : CCLayer {
	CCParticleSystem	*emitter;
	CCSprite *particleSystemSprite;
	
}
@property (readwrite,retain) CCParticleSystem *emitter;


@end

