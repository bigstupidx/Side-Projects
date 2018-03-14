#import "cocos2d.h"

@interface SlowParticleStar : CCParticleSystemPoint {
	
}

@end

@interface StarParticleLayer : CCLayer {
	CCParticleSystem	*emitter;
	CCSprite *particleSystemSprite;
    CCSprite* background, *background2;
}
@property (readwrite,retain) CCParticleSystem *emitter;


@end

