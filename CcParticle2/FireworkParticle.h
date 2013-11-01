//
//  FireworkParticle.h
//  BasicCocos2D
//
//  Created by Ian Fan on 7/08/12.
//
//

#import "cocos2d.h"

typedef enum {
  StateIdle,
  StateActive,
  StateDying,
}  PsState;

typedef enum {
  Type1,
  Type2,
}  FireworkType;

/*
typedef struct _explosionData {
  PsqState m_state;
  CCParticleSystemQuad *psq_fire;
  CCParticleSystemQuad *psq_debris;
  // etc etc
} explosionData;
*/
 
@protocol FireworkParticleDelegate <NSObject>
@optional
-(void)fireworkParticleDelegateAddChild:(id)object;
@end

@interface FireworkParticle : NSObject
{
  CGPoint debrisPoint;
  ccTime flyDuration;
}

@property (nonatomic, assign) id <FireworkParticleDelegate> fireworkParticleDelegate;
@property PsState psState;
@property FireworkType fireworkType;
@property (nonatomic,retain) CCParticleSystemQuad *firePsq;
@property (nonatomic,retain) CCParticleSystemQuad *debrisPsq;

-(id)initWithFirePlist:(NSString*)firePlist debrisPlist:(NSString*)debrisPlist fireworkType:(FireworkType)fwType;

-(void)startWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
