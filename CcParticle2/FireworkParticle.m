//
//  FireworkParticle.m
//  BasicCocos2D
//
//  Created by Ian Fan on 7/08/12.
//
//

#import "FireworkParticle.h"

@implementation FireworkParticle

@synthesize fireworkParticleDelegate,psState,fireworkType,firePsq,debrisPsq;

-(void)startWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
  psState = StateActive;
  debrisPoint = endPoint;
  
  if (startPoint.x==0 && startPoint.y==0) startPoint = ccp(CCRANDOM_0_1()*[CCDirector sharedDirector].winSize.width, -60);
  
  firePsq.position = startPoint;
  
  switch (fireworkType) {
    case Type1:{
      CGPoint relaEndPoint = ccpSub(endPoint, startPoint);
      CCPointArray *pointArray = [CCPointArray arrayWithCapacity:5];
      [pointArray addControlPoint:ccp(0, 0)];
      [pointArray addControlPoint:ccp(0.2*relaEndPoint.x+0.6*CCRANDOM_0_1()*relaEndPoint.x, relaEndPoint.y*0.25+CCRANDOM_0_1()*relaEndPoint.y*0.15)];
      [pointArray addControlPoint:ccp(0.4*relaEndPoint.x+0.6*CCRANDOM_0_1()*relaEndPoint.x, relaEndPoint.y*0.5+CCRANDOM_0_1()*relaEndPoint.y*0.15)];
      [pointArray addControlPoint:ccp(0.6*relaEndPoint.x+0.6*CCRANDOM_0_1()*relaEndPoint.x, relaEndPoint.y*0.75+CCRANDOM_0_1()*relaEndPoint.y*0.15)];
      [pointArray addControlPoint:relaEndPoint];
      
      firePsq.life = 0.261;
      firePsq.lifeVar = 0.1;
      firePsq.duration = -1;
      
      [firePsq resetSystem];
      [firePsq unscheduleUpdate];
      [firePsq scheduleUpdate];
      
      flyDuration = (float)ccpDistance(startPoint, endPoint)/400;
      id catmullRomByAction = [CCCatmullRomBy actionWithDuration:flyDuration points:pointArray];
      [firePsq runAction:catmullRomByAction];
      
      id delayTime = [CCDelayTime actionWithDuration:(flyDuration-0.1*flyDuration)];
      id delayTime2 = [CCDelayTime actionWithDuration:0.1*flyDuration];
      id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(doDebris)];
      id callFuncAction2 = [CCCallFunc actionWithTarget:self selector:@selector(shorterFlyPsq)];
      [firePsq runAction:[CCSequence actions:delayTime,callFuncAction2,delayTime2,callFuncAction, nil]];
    }
      break;
      
    default:
      break;
  }
  
}

-(void)shorterFlyPsq {
  firePsq.life = 0.0;
  firePsq.duration = 0.0;
  [firePsq unscheduleUpdate];
  [firePsq scheduleUpdate];
}

-(void)doDebris {
  debrisPsq.position = debrisPoint;
  [debrisPsq resetSystem];
  [debrisPsq unscheduleUpdate];
  [debrisPsq scheduleUpdate];
  
  id delayTime = [CCDelayTime actionWithDuration:(debrisPsq.duration+debrisPsq.life+debrisPsq.lifeVar+0.01)];
  id callFuncAction = [CCCallFunc actionWithTarget:self selector:@selector(doIdle)];
  [debrisPsq runAction:[CCSequence actions:delayTime,callFuncAction, nil]];
}

-(void)doIdle {
  [firePsq resetSystem];
  [firePsq unscheduleUpdate];
  
  [debrisPsq resetSystem];
  [debrisPsq unscheduleUpdate];
  
  self.psState = StateIdle;
}

-(id)initWithFirePlist:(NSString *)firePlist debrisPlist:(NSString *)debrisPlist fireworkType:(FireworkType)fwType {
  if ((self = [super init])) {
    self.psState = StateIdle, self.fireworkType = fwType;
    
    self.firePsq = [CCParticleSystemQuad particleWithFile:firePlist];
    firePsq.position = ccp(0, 0);
    [firePsq unscheduleUpdate];
    
    self.debrisPsq = [CCParticleSystemQuad particleWithFile:debrisPlist];
    debrisPsq.position = ccp(0, 0);
    [debrisPsq unscheduleUpdate];
    
    [self.fireworkParticleDelegate fireworkParticleDelegateAddChild:firePsq];
    [self.fireworkParticleDelegate fireworkParticleDelegateAddChild:debrisPsq];
  }
  
  return self;
}

-(void)dealloc {
  self.firePsq = nil;
  self.debrisPsq = nil;
  
  [super dealloc];
}

@end
