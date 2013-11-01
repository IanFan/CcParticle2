//
//  ParticleLayer.h
//  BasicCocos2D
//
//  Created by Ian Fan on 7/08/12.
//
//

#import "cocos2d.h"
#import "FireworkParticle.h"

@interface ParticleLayer : CCLayer <FireworkParticleDelegate>
{
  NSMutableArray *psMutableArray;
}

+(CCScene *) scene;

@end
