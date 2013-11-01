//
//  ParticleLayer.m
//  BasicCocos2D
//
//  Created by Ian Fan on 7/08/12.
//
//

#import "ParticleLayer.h"

@implementation ParticleLayer

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	ParticleLayer *layer = [ParticleLayer node];
	[scene addChild: layer];
  
	return scene;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  /*
  UITouch *touch = [touches anyObject];
  CGPoint point = [touch locationInView:[touch view]];
  point = [[CCDirector sharedDirector]convertToGL:point];
  
  [self triggerFireworkAtPosition:point];
  */
  
  for(UITouch *touch in touches){
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector]convertToGL:point];
    [self triggerFireworkAtPosition:point];
  }
}

-(void)triggerFireworkAtPosition:(CGPoint)position {
  for (int i=0; i<[psMutableArray count]; i++) {
    FireworkParticle *fp = [psMutableArray objectAtIndex:i];
    if (fp.psState == StateIdle) {
      [fp startWithStartPoint:CGPointZero endPoint:position];
      [psMutableArray removeObjectAtIndex:i];
      [psMutableArray addObject:fp];
      break;
    }
  }
}

#pragma mark -
#pragma mark fireworkParticleDelegate

-(void)fireworkParticleDelegateAddChild:(id)object {
  [self addChild:object];
}

#pragma mark - Setup

-(void)setParticle {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  [[CCTextureCache sharedTextureCache] addImage:@"magicFireParticalTexture.png"];
  
  psMutableArray = [[NSMutableArray alloc]init];
  
  for (int i=0; i<20; i++) {
    FireworkParticle *fireworkParticle = [FireworkParticle alloc];
    fireworkParticle.fireworkParticleDelegate = self;
    [fireworkParticle initWithFirePlist:@"magicFire.plist" debrisPlist:@"magicExlposion.plist" fireworkType:Type1];
    
    [psMutableArray addObject:fireworkParticle];
    [fireworkParticle release];
  }
  
  [self triggerFireworkAtPosition:ccp(winSize.width/2, winSize.height/2)];
}

#pragma mark - Init

-(id) init {
	if((self = [super init])) {
    [self setParticle];
    
    [[CCDirector sharedDirector].view setMultipleTouchEnabled:YES];
    self.touchEnabled = YES;
	}
	return self;
}

- (void) dealloc {
  [psMutableArray release], psMutableArray=nil;
  
	[super dealloc];
}

@end
