//
//  GLView.m
//

#import "GLView.h"

@implementation GLView

@synthesize parent, mainGame, animating, objectsLoaded, texturesLoaded;

#pragma mark Initialization

- (void)initializeObjects: (GLViewController*) p {
	if (self.objectsLoaded)
		return;
	
	//Remember parent
	self.parent = p;
	
	//Initiate game
	self.mainGame = [[Game alloc] initGame];
	
	//Initiate interface
	[self initializeUIKit];
	
	//Display link detection
	NSString *reqSysVer = @"3.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
		displayLinkSupported = TRUE;
	
	//FPS helpers
	calculatedFPS = 0;
	timeFPS = 0;
	
	//Flag
	self.objectsLoaded = TRUE;
}

-(void) initializeUIKit {

	//Buttons
	overlayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
	overlayLabel.backgroundColor = [UIColor blackColor];
	overlayLabel.alpha = 0.5;
	overlayLabel.hidden = TRUE;
	[self addSubview: overlayLabel];
	[overlayLabel release];
	
	pausePanel = [[UIImageView alloc] initWithFrame: CGRectMake(28, 97, 423, 213)];
	pausePanel.image = [UIImage imageNamed: @"imgPanelPaused.png"];
	pausePanel.hidden = TRUE;
	[self addSubview: pausePanel];
	[pausePanel release];
	
	twitterButton = [UIButton buttonWithType: UIButtonTypeCustom];
	twitterButton.frame = CGRectMake(480/2 - 5 - 48, 18, 48, 48);
	[twitterButton addTarget:self action:@selector(broadcastToTwitter) forControlEvents:UIControlEventTouchUpInside];
	[twitterButton setImage:[UIImage imageNamed:@"twitterIcon.png"] forState:UIControlStateNormal];
	[self addSubview:twitterButton];
	
	facebookButton = [UIButton buttonWithType: UIButtonTypeCustom];
	facebookButton.frame = CGRectMake(480/2 + 5, 18, 48, 48);
	[facebookButton addTarget:self action:@selector(broadcastToFacebook) forControlEvents:UIControlEventTouchUpInside];
	[facebookButton setImage:[UIImage imageNamed:@"facebookIcon.png"] forState:UIControlStateNormal];
	[self addSubview:facebookButton];
	
	pauseButton = [UIButton buttonWithType: UIButtonTypeCustom];
	pauseButton.frame = CGRectMake(10, 275, 36, 36);
	[pauseButton addTarget:self action:@selector(pauseClick) forControlEvents:UIControlEventTouchUpInside];
	[pauseButton setImage:[UIImage imageNamed:@"btnPause.png"] forState:UIControlStateNormal];
	[self addSubview:pauseButton];
	
	resumeButton = [UIButton buttonWithType: UIButtonTypeCustom];
	resumeButton.frame = CGRectMake(77, 115+30, 326, 41);
	[resumeButton addTarget:self action:@selector(resumeClick) forControlEvents:UIControlEventTouchUpInside];
	[resumeButton setImage:[UIImage imageNamed:@"btnResume.png"] forState:UIControlStateNormal];
	resumeButton.hidden = TRUE;
	[self addSubview:resumeButton];
	
	restartButton = [UIButton buttonWithType: UIButtonTypeCustom];
	restartButton.frame = CGRectMake(77, 203+30, 326, 41);
	[restartButton addTarget:self action:@selector(restartClick) forControlEvents:UIControlEventTouchUpInside];
	[restartButton setImage:[UIImage imageNamed:@"btnRestart.png"] forState:UIControlStateNormal];
	restartButton.hidden = TRUE;
	[self addSubview:restartButton];
	
	optionsButton = [UIButton buttonWithType: UIButtonTypeCustom];
	optionsButton.frame = CGRectMake(77, 160+30, 326, 41);
	[optionsButton addTarget:self action:@selector(optionsClick) forControlEvents:UIControlEventTouchUpInside];
	[optionsButton setImage:[UIImage imageNamed:@"btnOptions.png"] forState:UIControlStateNormal];
	optionsButton.hidden = TRUE;
	[self addSubview:optionsButton];
	
	quitButton = [UIButton buttonWithType: UIButtonTypeCustom];
	quitButton.frame = CGRectMake(178, 278, 124, 42);
	[quitButton addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
	[quitButton setImage:[UIImage imageNamed:@"btnQuit.png"] forState:UIControlStateNormal];
	quitButton.hidden = TRUE;
	[self addSubview:quitButton];
	
	retryButton = [UIButton buttonWithType: UIButtonTypeCustom];
	retryButton.frame = CGRectMake(27, 278, 124, 42);
	[retryButton addTarget:self action:@selector(retryClick) forControlEvents:UIControlEventTouchUpInside];
	[retryButton setImage:[UIImage imageNamed:@"btnGameOverRetry.png"] forState:UIControlStateNormal];
	retryButton.hidden = TRUE;
	[self addSubview:retryButton];
	
	scoresButton = [UIButton buttonWithType: UIButtonTypeCustom];
	scoresButton.frame = CGRectMake(329, 278, 124, 42);
	[scoresButton addTarget:self action:@selector(scoresClick) forControlEvents:UIControlEventTouchUpInside];
	[scoresButton setImage: isFullGame ? [UIImage imageNamed:@"btnBuyNowSmall.png"] : [UIImage imageNamed:@"btnBuyNowSmall.png"] forState:UIControlStateNormal];
	scoresButton.hidden = TRUE;
	[self addSubview:scoresButton];
	
	gameOverImage = [[UIImageView alloc] initWithFrame: CGRectMake(0, (320 - 90) / 2, 480, 90)];
	gameOverImage.image = [UIImage imageNamed: @"imgGameOver.png"];
	gameOverImage.hidden = TRUE;
	[self addSubview:gameOverImage];
	[gameOverImage release];
	
	gameLogo = [[UIImageView alloc] initWithFrame: CGRectMake(137, 0, 205, 96)];
	[gameLogo setImage: isFullGame ? [UIImage imageNamed: @"imgLogo.png"] : [UIImage imageNamed: @"imgLogoLite.png"]];
	gameLogo.hidden = TRUE;
	[self addSubview:gameLogo];
	[gameLogo release];
	
	newHighScore = [[UIImageView alloc] initWithFrame: CGRectMake(79, 200, 323, 50)];
	newHighScore.image = [UIImage imageNamed: @"newhighscore.png"];
	newHighScore.hidden = TRUE;
	[self addSubview:newHighScore];
	[newHighScore release];
    
	
	//Inactive
	pauseButton.userInteractionEnabled = TRUE;
	resumeButton.userInteractionEnabled = FALSE;
	restartButton.userInteractionEnabled = FALSE;
	optionsButton.userInteractionEnabled = FALSE;
	quitButton.userInteractionEnabled = FALSE;
}

-(void) loadTextures {
	if (self.texturesLoaded)
		return;
	
	NSLog(@"Loading textures...");
	
	//Initiate swords textures
	swordTextures = [[NSMutableArray alloc] init];
	for (int i=0; i<5; i++) {
		Texture2D *tex = [[Texture2D alloc] initWithImage: [UIImage imageNamed: [NSString stringWithFormat: @"sword%i.png", i+1]]];
		[swordTextures insertObject: tex atIndex: i];
		[tex release];
	}
	
	//Initiate normal textures
	background = [[Texture2D alloc] initWithImage: [UIImage imageNamed: @"background.png"]];
	
	//Initiate atlases
	spritesAtlas = [[Atlas alloc] initWithFile: @"SpritesAtlas" Extension: @"png" NormalWidth: 1024];
	particlesAtlas = [[ParticleAtlas alloc] initWithFile: @"ParticlesAtlas" Extension: @"png" NormalWidth: 256];
	
	//Initiate pvrtc texture
	NSString *path = [[NSBundle mainBundle] pathForResource:@"3DAtlas" ofType:@"pvrtc"];
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
	glGenTextures(1, &fruitsTexture);
	glBindTexture(GL_TEXTURE_2D, fruitsTexture);
	glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_FALSE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_PVRTC_2BPPV1_IMG, 512, 512, 0, [texData length], [texData bytes]);
	[texData release];
	
	//Flag
	self.texturesLoaded = TRUE;
}

-(void) unloadTextures {
	if (!self.texturesLoaded)
		return;
	
	NSLog(@"Unloading textures...");
	
	//Release swords textures
	[swordTextures removeAllObjects];
	[swordTextures release];
	swordTextures = nil;
	
	//Release normal textures
	[background release];
	background = nil;
	
	//Release atlases
	[spritesAtlas release];
	[particlesAtlas release];
	spritesAtlas = nil;
	particlesAtlas = nil;
	
	//Release pvrtc texture
	glDeleteTextures(1, &fruitsTexture);
	
	//Flag
	self.texturesLoaded = FALSE;
}

-(void) resetAll {
	//Reset game
	[self.mainGame resetGame];
	
	//Reset controls
	[self resetControls];
}

#pragma mark Animation UIKit

-(void) resetControls {
	//Reset
	overlayLabel.alpha = 0.0;
	pausePanel.alpha = 0.0;
	gameOverImage.alpha = 0.0;
	gameLogo.alpha = 0.0;
	pauseButton.alpha = 1.0;
	
	CGRect f1 = resumeButton.frame;
	f1.origin.x = -480 * 2;
	resumeButton.frame = f1;
	
	CGRect f3 = optionsButton.frame;
	f3.origin.x = 480;
	optionsButton.frame = f3;
	
	CGRect f2 = restartButton.frame;
	f2.origin.x = -480 * 2;
	restartButton.frame = f2;
	
	CGRect f4 = quitButton.frame;
	f4.origin.y = 320;
	quitButton.frame = f4;
	
	CGRect f5 = retryButton.frame;
	f5.origin.y = 320;
	retryButton.frame = f5;
	
	CGRect f6 = scoresButton.frame;
	f6.origin.y = 320;
	scoresButton.frame = f6;
	
	CGRect f7 = gameLogo.frame;
	f7.origin.y = -96;
	gameLogo.frame = f7;
	
	//Enable pause
	pauseButton.userInteractionEnabled = TRUE;
	
	//Hidden
	twitterButton.hidden = TRUE;
	facebookButton.hidden = TRUE;
	overlayLabel.hidden = TRUE;
	pausePanel.hidden = TRUE;
	gameOverImage.hidden = TRUE;
	gameLogo.hidden = TRUE;
	resumeButton.hidden = TRUE;
	restartButton.hidden = TRUE;
	optionsButton.hidden = TRUE;
	quitButton.hidden = TRUE;
	retryButton.hidden = TRUE;
	scoresButton.hidden = TRUE;
}

-(void) animateControlsIn {
	//Disable pause
	pauseButton.userInteractionEnabled = FALSE;
	
	//Visible
	overlayLabel.hidden = FALSE;
	pausePanel.hidden = FALSE;
	gameLogo.hidden = FALSE;
	resumeButton.hidden = FALSE;
	restartButton.hidden = FALSE;
	optionsButton.hidden = FALSE;
	quitButton.hidden = FALSE;
	
	//Animate into place
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.20];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animateControlsInFinished)];

	overlayLabel.alpha = 0.5;
	pausePanel.alpha = 1.0;
	gameLogo.alpha = 1.0;
	pauseButton.alpha = 0.0;
	
	CGRect f1 = resumeButton.frame;
	f1.origin.x = 77;
	resumeButton.frame = f1;
	
	CGRect f2 = restartButton.frame;
	f2.origin.x = 77;
	restartButton.frame = f2;
	
	CGRect f3 = optionsButton.frame;
	f3.origin.x = 77;
	optionsButton.frame = f3;
	
	CGRect f4 = quitButton.frame;
	f4.origin.y = 278;
	quitButton.frame = f4;
	
	CGRect f7 = gameLogo.frame;
	f7.origin.y = 0;
	gameLogo.frame = f7;
	
	[UIView commitAnimations];
}

-(void) animateControlsInFinished {
	//Active
	resumeButton.userInteractionEnabled = TRUE;
	restartButton.userInteractionEnabled = TRUE;
	optionsButton.userInteractionEnabled = TRUE;
	quitButton.userInteractionEnabled = TRUE;
}

-(void) animateControlsOut {
	//Inactive
	resumeButton.userInteractionEnabled = FALSE;
	restartButton.userInteractionEnabled = FALSE;
	optionsButton.userInteractionEnabled = FALSE;
	quitButton.userInteractionEnabled = FALSE;
	
	//Animate into place
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.20];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animateControlsOutFinished)];
	
	overlayLabel.alpha = 0.0;
	pausePanel.alpha = 0.0;
	gameLogo.alpha = 0.0;
	pauseButton.alpha = 1.0;

	CGRect f1 = resumeButton.frame;
	f1.origin.x = -480 * 2;
	resumeButton.frame = f1;
	
	CGRect f3 = optionsButton.frame;
	f3.origin.x = 480;
	optionsButton.frame = f3;
	
	CGRect f2 = restartButton.frame;
	f2.origin.x = -480 * 2;
	restartButton.frame = f2;
	
	CGRect f4 = quitButton.frame;
	f4.origin.y = 320;
	quitButton.frame = f4;
	
	CGRect f7 = gameLogo.frame;
	f7.origin.y = -96;
	gameLogo.frame = f7;
	
	[UIView commitAnimations];
}

-(void) animateControlsOutFinished {
	//Enable pause
	pauseButton.userInteractionEnabled = TRUE;
	
	//Hidden
	overlayLabel.hidden = TRUE;
	pausePanel.hidden = TRUE;
	gameLogo.hidden = TRUE;
	resumeButton.hidden = TRUE;
	restartButton.hidden = TRUE;
	optionsButton.hidden = TRUE;
	quitButton.hidden = TRUE;
}

-(void) animateGameOverIn {
	//Highscore

	
	//Disable pause
	pauseButton.userInteractionEnabled = FALSE;
	
	//Alpha
	twitterButton.alpha = 0;
	facebookButton.alpha = 0;
	
	//Visible
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(85,80,320,50)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"a14d56d404ca6be";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
	twitterButton.hidden = FALSE;
	facebookButton.hidden = FALSE;
	overlayLabel.hidden = FALSE;
	gameOverImage.hidden = FALSE;
	quitButton.hidden = FALSE;
	retryButton.hidden = FALSE;
	scoresButton.hidden = FALSE;
	
	CGRect f70 = gameOverImage.frame;
	f70.size.width = 0;
	f70.size.height = 0;
	f70.origin.x = screenWidth/2;
	f70.origin.y = screenHeight/2;
	gameOverImage.frame = f70;
	
	CGRect f80 = newHighScore.frame;
	f80.size.width = 0;
	f80.size.height = 0;
	f80.origin.x = 240;
	f80.origin.y = 225;
	newHighScore.frame = f80;
	
	//Animate into place
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.20];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animateGameOverInFinished)];
	
	twitterButton.alpha = 1.0;
	facebookButton.alpha = 1.0;
	overlayLabel.alpha = 0.5;
	gameOverImage.alpha = 1.0;
	pauseButton.alpha = 0.0;
	newHighScore.alpha = 1.0;
	
	CGRect f4 = quitButton.frame;
	f4.origin.y = 278;
	quitButton.frame = f4;
	
	CGRect f5 = retryButton.frame;
	f5.origin.y = 278;
	retryButton.frame = f5;
	
	CGRect f6 = scoresButton.frame;
	f6.origin.y = 278;
	scoresButton.frame = f6;
	
	CGRect f71 = gameOverImage.frame;
	f71.size.width = 480;
	f71.size.height = 90;
	f71.origin.x = 0;
	f71.origin.y = (320 - 90) / 2;
	gameOverImage.frame = f71;
	
	CGRect f81 = newHighScore.frame;
	f81.size.width = 323;
	f81.size.height = 50;
	f81.origin.x = 79;
	f81.origin.y = 200;
	newHighScore.frame = f81;
	
	[UIView commitAnimations];
}

-(void) animateGameOverInFinished {
	//Active
	quitButton.userInteractionEnabled = TRUE;
	retryButton.userInteractionEnabled = TRUE;
	scoresButton.userInteractionEnabled = TRUE;
}

-(void) animateGameOverOut {
	//Inactive
	quitButton.userInteractionEnabled = FALSE;
	retryButton.userInteractionEnabled = FALSE;
	scoresButton.userInteractionEnabled = FALSE;
	
	//Animate into place
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.20];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animateGameOverOutFinished)];
	
	twitterButton.alpha = 0.0;
	facebookButton.alpha = 0.0;
	overlayLabel.alpha = 0.0;
	gameOverImage.alpha = 0.0;
	pauseButton.alpha = 1.0;
	newHighScore.alpha = 0.0;
	
	CGRect f4 = quitButton.frame;
	f4.origin.y = 320;
	quitButton.frame = f4;
	
	CGRect f5 = retryButton.frame;
	f5.origin.y = 320;
	retryButton.frame = f5;
	
	CGRect f6 = scoresButton.frame;
	f6.origin.y = 320;
	scoresButton.frame = f6;
	
	CGRect f70 = gameOverImage.frame;
	f70.size.width = 0;
	f70.size.height = 0;
	f70.origin.x = screenWidth/2;
	f70.origin.y = screenHeight/2;
	gameOverImage.frame = f70;
	
	CGRect f80 = newHighScore.frame;
	f80.size.width = 0;
	f80.size.height = 0;
	f80.origin.x = 240;
	f80.origin.y = 225;
	newHighScore.frame = f80;
	
	[UIView commitAnimations];
}

-(void) animateGameOverOutFinished {
	//Enable pause
	pauseButton.userInteractionEnabled = TRUE;
	
	//Hidden
	twitterButton.hidden = TRUE;
	facebookButton.hidden = TRUE;
	overlayLabel.hidden = TRUE;
	gameOverImage.hidden = TRUE;
	quitButton.hidden = TRUE;
	retryButton.hidden = TRUE;
	scoresButton.hidden = TRUE;
	newHighScore.hidden = TRUE;
}

#pragma mark Animation OpenGLES

-(void) startAnimation {
	if (!animating) {
		if (displayLinkSupported) {
			displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawScene)];
			[displayLink setFrameInterval: 1];
			[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		} else {
			timerScene = [NSTimer scheduledTimerWithTimeInterval: 1.0f/60.0f target:self selector:@selector(drawScene) userInfo:nil repeats: YES];
		}
		
		//Animating
		animating = TRUE;
	}
	
	//Re-read current sword
	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
	int selectedOption = [def integerForKey: @"selectedOption"];
	mainGame.sword = selectedOption;
}

- (void)stopAnimation {
	if (animating) {
		if (displayLinkSupported) {
			[displayLink invalidate];
			displayLink = nil;
		} else	{
			[timerScene invalidate];
			timerScene = nil;
		}
		
		//No longer animating
		animating = FALSE;
	}
}

-(void)drawScene {
	if (animating) {	
		//FPS calculation
		if (mainGame.currentFrame % 60 == 0) {
			//Get time interval
			float diff = CFAbsoluteTimeGetCurrent() - timeFPS;
			
			//Calculate FPS
			calculatedFPS = 60.0f / diff;
		
			//Remember
			timeFPS = CFAbsoluteTimeGetCurrent();
		}
		
		//Game calculation
		[mainGame calculateFrame];
		
		//Game rendering
		[self drawFrame];
		
		//Game over (when the screen is totally clean)
		if (mainGame.active == FALSE && [mainGame.fruits count] == 0)
			[self gameOver];
	}
}

#pragma mark Drawing

-(void) drawFrame {	
	//Draw on framebuffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	//Draw background
	[self drawBackground];
	
	//Bottom sprites
	[self drawBottomSprites];
	[spritesAtlas renderObjects];
	
	//3D
	[self draw3DFruits];
	
	//Top sprites 
	[self drawParticles];
	[particlesAtlas renderObjects];
	
	//HUD
	[self drawTopSprites];
	[self drawHUD];
	[spritesAtlas renderObjects];
	
	//Swords
	[self drawSwords];
	
	//Render framebuffer to screen
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer: GL_RENDERBUFFER_OES];
}

-(void) drawBackground {
	//Clear buffers
    glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	
	
	//Reset transformations
    glLoadIdentity();	
	glTranslatef(0, 0, -5000);
	
	//Background
	[background drawAtPoint: CGPointMake(screenWidth/2, screenHeight/2)];
}

-(void) drawBottomSprites {
	//Reset transformations
    glLoadIdentity();	
	glTranslatef(0, 0, -4500);
	
	//Sprites
	for (int i=0; i<[mainGame.sprites count]; i++) {
		Sprite *s = [mainGame.sprites objectAtIndex: i];
		if (s.type == 1) {
			//Splat
			[spritesAtlas addObject: [NSString stringWithFormat: @"splatter%i", s.model] PosX: s.posX PosY: s.posY Rotation: s.rotation Scale: s.size Alpha: s.alpha];
		}
	}
	
	//Fruit shadows
	if (mainGame.highPerformance) {
		for (int i=0; i<[mainGame.fruits count]; i++) {
			//Get fruit
			Fruit *f = [mainGame.fruits objectAtIndex: i];
			
			//Skip falling for bananna, special or half fruits
			if (f.type == 20 || f.type == 120 || f.type == 130 || f.type % 10 != 0)
				continue;
			
			//Coords
			if (f.type == 140) {
				[spritesAtlas addObject: @"glow" PosX: f.posX PosY: f.posY Rotation: 0.0 Scale: 0.85 Alpha: 0.85];
			} else {
				for (int j=0; j<[f.oldCoords count]; j++) {
					//Get coord
					Coord *c = [f.oldCoords objectAtIndex: j];
					
					//Add sprite
					[spritesAtlas addObject: @"shadow" PosX: c.posX PosY: c.posY Rotation: 0.0 Scale: 1.0 Alpha: (j + 1) * 0.022];
				}
			}
		}
	}
}

-(void) draw3DFruits {	
	//Enable normals
	glEnableClientState(GL_NORMAL_ARRAY);
	
	//Depth
	glEnable(GL_DEPTH_TEST);
	
	//Bind texture
	glBindTexture(GL_TEXTURE_2D, fruitsTexture);
	
	//Counts
	int fruitCount = [mainGame.fruits count];
	
	//Fruits
	for (int i=0; i<fruitCount; i++) {
		//Get fruit
		Fruit *f = [mainGame.fruits objectAtIndex: i];
		
		//Transformations
		glLoadIdentity();
		glTranslatef(f.posX, f.posY, -200 * (fruitCount - i));
		glRotatef(f.rotation, f.vectorX, f.vectorY, f.vectorZ);
		glScalef(f.scale, f.scale, f.scale);
		
		//No vertices
		GLfloat noVertices = 0;

		//Pointers to arrays
		if (f.type == 10) {
			//=== Pineapple ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &PineappleVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &PineappleVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &PineappleVertexData[0].texCoord);
			noVertices = kPineappleNumberOfVertices;
		} else if (f.type == 11){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Pineapple1VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Pineapple1VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Pineapple1VertexData[0].texCoord);
			noVertices = kPineapple1NumberOfVertices;
		} else if (f.type == 12){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Pineapple2VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Pineapple2VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Pineapple2VertexData[0].texCoord);
			noVertices = kPineapple2NumberOfVertices;
		} else if (f.type == 20) {
			//=== Banana ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &BananaVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &BananaVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &BananaVertexData[0].texCoord);
			noVertices = kBananaNumberOfVertices;
		} else if (f.type == 21){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Banana1VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Banana1VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Banana1VertexData[0].texCoord);
			noVertices = kBanana1NumberOfVertices;
		} else if (f.type == 22){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Banana2VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Banana2VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Banana2VertexData[0].texCoord);
			noVertices = kBanana2NumberOfVertices;
		} else if (f.type == 30) {
			//=== Kiwi ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &KiwiVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &KiwiVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &KiwiVertexData[0].texCoord);
			noVertices = kKiwiNumberOfVertices;
		} else if (f.type == 31){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Kiwi1VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Kiwi1VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Kiwi1VertexData[0].texCoord);
			noVertices = kKiwi1NumberOfVertices;
		} else if (f.type == 32){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Kiwi2VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Kiwi2VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Kiwi2VertexData[0].texCoord);
			noVertices = kKiwi2NumberOfVertices;
		} else if (f.type == 40) {
			//=== Lemon ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &LemonVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &LemonVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &LemonVertexData[0].texCoord);
			noVertices = kLemonNumberOfVertices;
		} else if (f.type == 41){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Lemon1VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Lemon1VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Lemon1VertexData[0].texCoord);
			noVertices = kLemon1NumberOfVertices;
		} else if (f.type == 42){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Lemon2VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Lemon2VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Lemon2VertexData[0].texCoord);
			noVertices = kLemon2NumberOfVertices;
		} else if (f.type == 50) {
			//=== Mango ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &MangoVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &MangoVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &MangoVertexData[0].texCoord);
			noVertices = kMangoNumberOfVertices;
		} else if (f.type == 51){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Mango1VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Mango1VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Mango1VertexData[0].texCoord);
			noVertices = kMango1NumberOfVertices;
		} else if (f.type == 52){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Mango2VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Mango2VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Mango2VertexData[0].texCoord);
			noVertices = kMango2NumberOfVertices;
		} else if (f.type == 60) {
			//=== RedApple ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &RedappleVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &RedappleVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &RedappleVertexData[0].texCoord);
			noVertices = kRedappleNumberOfVertices;
		} else if (f.type == 61){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Redapple1VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Redapple1VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Redapple1VertexData[0].texCoord);
			noVertices = kRedapple1NumberOfVertices;
		} else if (f.type == 62){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Redapple2VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Redapple2VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Redapple2VertexData[0].texCoord);
			noVertices = kRedapple2NumberOfVertices;
		} else if (f.type == 70) {
			//=== GreenApple ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &GreenappleVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &GreenappleVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &GreenappleVertexData[0].texCoord);
			noVertices = kGreenappleNumberOfVertices;
		} else if (f.type == 71){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Greenapple1VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Greenapple1VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Greenapple1VertexData[0].texCoord);
			noVertices = kGreenapple1NumberOfVertices;
		} else if (f.type == 72){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Greenapple2VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Greenapple2VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Greenapple2VertexData[0].texCoord);
			noVertices = kGreenapple2NumberOfVertices;
		} else if (f.type == 80) {
			//=== Coconut ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &CoconutVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &CoconutVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &CoconutVertexData[0].texCoord);
			noVertices = kCoconutNumberOfVertices;
		} else if (f.type == 81){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Coconut1VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Coconut1VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Coconut1VertexData[0].texCoord);
			noVertices = kCoconut1NumberOfVertices;
		} else if (f.type == 82){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Coconut2VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Coconut2VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Coconut2VertexData[0].texCoord);
			noVertices = kCoconut2NumberOfVertices;
		} else if (f.type == 90) {
			//=== Pear ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &PearVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &PearVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &PearVertexData[0].texCoord);
			noVertices = kPearNumberOfVertices;
		} else if (f.type == 91){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Pear1VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Pear1VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Pear1VertexData[0].texCoord);
			noVertices = kPear1NumberOfVertices;
		} else if (f.type == 92){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Pear2VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Pear2VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Pear2VertexData[0].texCoord);
			noVertices = kPear2NumberOfVertices;
		} else if (f.type == 100) {
			//=== Melon ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &MelonVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &MelonVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &MelonVertexData[0].texCoord);
			noVertices = kMelonNumberOfVertices;
		} else if (f.type == 101){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Melon1VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Melon1VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Melon1VertexData[0].texCoord);
			noVertices = kMelon1NumberOfVertices;
		} else if (f.type == 102){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Melon2VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Melon2VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Melon2VertexData[0].texCoord);
			noVertices = kMelon2NumberOfVertices;
		} else if (f.type == 110) {
			//=== Orange ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &OrangeVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &OrangeVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &OrangeVertexData[0].texCoord);
			noVertices = kOrangeNumberOfVertices;
		} else if (f.type == 111){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Orange1VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Orange1VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Orange1VertexData[0].texCoord);
			noVertices = kOrange1NumberOfVertices;
		} else if (f.type == 112){
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &Orange2VertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &Orange2VertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &Orange2VertexData[0].texCoord);
			noVertices = kOrange2NumberOfVertices;
		} else if (f.type == 120) {
			//=== Coin ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &CoinVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &CoinVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &CoinVertexData[0].texCoord);
			noVertices = kCoinNumberOfVertices;
		} else if (f.type == 130) {
			//=== Clock ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &ClockVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &ClockVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &ClockVertexData[0].texCoord);
			noVertices = kClockNumberOfVertices;
		} else if (f.type == 140) {
			//=== Poison ===//
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &PoisonVertexData[0].vertex);
			glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &PoisonVertexData[0].normal);
			glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &PoisonVertexData[0].texCoord);
			noVertices = kPoisonNumberOfVertices;
		} 
		
		//Drawing triangles
		glDrawArrays(GL_TRIANGLES, 0, noVertices);
	}
	
	//Depth
	glDisable(GL_DEPTH_TEST);
	
	//Disable normals
	glDisableClientState(GL_NORMAL_ARRAY);
}

-(void) drawSwords {
	//Reset
	glLoadIdentity();
	
	//Enabled blending
	glEnable(GL_BLEND);

	//Bind normal texture
	Texture2D *tex = [swordTextures objectAtIndex: mainGame.sword];
	glBindTexture(GL_TEXTURE_2D, [tex name]);
	
	//Draw swords
	for (int i=0; i<[mainGame.swords count]; i++) {
		//Get sword
		Sword *s = [mainGame.swords objectAtIndex: i];
		
		//Send to gpu
		glTexCoordPointer(2,GL_FLOAT, 0, s.coordinates);
		glVertexPointer(2, GL_FLOAT, 0, s.vertices);
		glDrawArrays(GL_TRIANGLES, 0, s.verticesCount/2);
	}
	
	//Disable blending
	glDisable(GL_BLEND);
}

-(void) drawParticles {
	//Sprites
	for (int i=0; i<[mainGame.particles count]; i++) {
		Sprite *s = [mainGame.particles objectAtIndex: i];
		[particlesAtlas addObjectID: s.model PosX: s.posX PosY: s.posY Scale: s.size];
	}
}

-(void) drawTopSprites {
	//Sprites
	for (int i=0; i<[mainGame.sprites count]; i++) {
		Sprite *s = [mainGame.sprites objectAtIndex: i];
		
		if (s.type == 4) {
			//Missed
			[spritesAtlas addObject: @"missed" PosX: s.posX PosY: s.posY Rotation: s.rotation Scale: s.size Alpha: s.alpha];
		} else  if (s.type == 7) {
			//Smoke
			[spritesAtlas addObject: @"smoke" PosX: s.posX PosY: s.posY Rotation: s.rotation Scale: s.size Alpha: s.alpha];			
		} else if (s.type == 8) {
			//Strikethrough
			[spritesAtlas addObject: @"strikethrough" PosX: s.posX PosY: s.posY Rotation: s.rotation Scale: s.size Alpha: s.alpha];			
		} 
	}
}

-(void) drawHUD {
	//Sprites
	for (int i=0; i<[mainGame.sprites count]; i++) {
		Sprite *s = [mainGame.sprites objectAtIndex: i];
		
		if (s.type == 5) {
			//Banners
			if (s.model == 1)
				[spritesAtlas addObject: @"lucky" PosX: s.posX PosY: s.posY Rotation: s.rotation Scale: s.size Alpha: s.alpha];
			else if (s.model == 2)
				[spritesAtlas addObject: @"highscore" PosX: s.posX PosY: s.posY Rotation: s.rotation Scale: s.size Alpha: s.alpha];
			else if (s.model == 3)
				[spritesAtlas addObject: @"combo3" PosX: s.posX PosY: s.posY Rotation: s.rotation Scale: s.size Alpha: s.alpha];
			else if (s.model == 4)
				[spritesAtlas addObject: @"combo4" PosX: s.posX PosY: s.posY Rotation: s.rotation Scale: s.size Alpha: s.alpha];
			else if (s.model == 5)
				[spritesAtlas addObject: @"combo5" PosX: s.posX PosY: s.posY Rotation: s.rotation Scale: s.size Alpha: s.alpha];
			else if (s.model == 6)
				[spritesAtlas addObject: @"extra" PosX: s.posX PosY: s.posY Rotation: s.rotation Scale: s.size Alpha: s.alpha];
			else if (s.model == 7)
				[spritesAtlas addObject: @"double" PosX: s.posX PosY: s.posY Rotation: s.rotation Scale: s.size Alpha: s.alpha];
		}
	}
	
	//Lucky
	if (mainGame.doubleFrames > 0) {
		if (mainGame.doubleFrames > 180) {
			if ((mainGame.doubleFrames % 40) > 20)
				[spritesAtlas addObject: @"doubleind" PosX: screenWidth - 45 PosY: 30];
		}
		else {
			if ((mainGame.doubleFrames % 10) > 5)
				[spritesAtlas addObject: @"doubleind" PosX: screenWidth - 45 PosY: 30];
		}
	}
	
	//Top-left side
	[spritesAtlas addObject: @"score" PosX: 60  PosY: screenHeight - 20];
	[self drawNumber: mainGame.score Font: 0 PosX: 15 PosY: screenHeight - 55 Size: 34 Spacing: 31 Alpha: 1.0 Center: FALSE];
	
	//Top-right side
	if (mainGame.mode == 0) {
		//Lives
		[spritesAtlas addObject: @"lives" PosX: screenWidth - 50  PosY: screenHeight - 20];
		[self drawNumber: mainGame.lives Font: 0 PosX: screenWidth - 50 PosY: screenHeight - 55 Size: 34 Spacing: 31 Alpha: 1.0 Center: FALSE];
	} else if (mainGame.mode == 1 || mainGame.mode == 2) {		
		//Time
		[spritesAtlas addObject: @"time" PosX: screenWidth - 45  PosY: screenHeight - 20];
		[self drawNumber: mainGame.countdownTime Font: 0 PosX: mainGame.countdownTime >= 10 ? screenWidth - 80 : screenWidth - 50 PosY: screenHeight - 55 Size: 34 Spacing: 31 Alpha: 1.0 Center: FALSE];
	}
	
	//Debug
	//[self drawNumber: mainGame.comboPower Font:0 PosX:0 PosY: screenHeight - 55 Size:34 Spacing:31 Alpha: 1.0 Center: TRUE];
}

-(void) drawNumber: (int) label Font: (int) fontno PosX: (float) x PosY: (float) y Size: (float) size Spacing: (float) spacing Alpha: (float) alpha Center: (bool) center {
	//Create and clean digit buffer
	int characters[10];
	for (int i=0; i<10; i++)
		characters[i] = 0;
	
	//Decompose number to digits
	do {		
		if (label < 10) {
			characters[0] = label;
			label -= characters[0];
		} else if (label < 100) {
			characters[1] = label / 10;
			label -= characters[1] * 10;
		} else if (label < 1000) {
			characters[2] = label / 100;
			label -= characters[2] * 100;
		} else if (label < 10000) {
			characters[3] = label / 1000;
			label -= characters[3] * 1000;
		} else if (label < 100000) {
			characters[4] = label / 10000;
			label -= characters[4] * 10000;
		} else if (label < 1000000) {
			characters[5] = label / 100000;
			label -= characters[5] * 100000;
		} else if (label < 10000000) {
			characters[6] = label / 1000000;
			label -= characters[6] * 1000000;
		} else if (label < 100000000) {
			characters[7] = label / 10000000;
			label -= characters[7] * 10000000;
		}
	} while (label > 0);
	
	//Calculate digits
	int digits = 1;
	for (int i=0; i<10; i++)
		if (characters[i] > 0)
			digits = i + 1;
	
	//Thousands separator
	if (digits >= 4) {
		//Shift digits
		for (int i=9; i>=4; i--)
			characters[i] = characters[i-1];
		
		//Add comma
		characters[3] = 10;
		
		//Extra digit for comma
		digits++;
	}
	
	//Calculate text width
	float text_width = digits * spacing;
	
	//Text is centered
	if (center)
		x = (screenWidth - text_width) / 2;
	
	//First letter offset
	x += size / 2;
	
	//Draw every digit
	for (int i=digits-1; i>=0; i--) {
		int ch = characters[i];		
		
		//Comma
		if (ch == 10)
			x -= spacing / 2;
		
		//Texture
		NSString *tex;
		if (ch < 10)
			tex = [NSString stringWithFormat: @"digit%i", ch];
		else
			tex = @"digit_comma";
		
		//Draw digit
		[spritesAtlas addObject: tex PosX: x PosY: y Rotation: 0.0 Scale: 1.0 Alpha: alpha];
		
		//Comma
		if (ch == 10)
			x += spacing * 3 / 2;
		else
			x += spacing;
	}
}

#pragma mark OS Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		//Get touch ID
		int touchID = (int)(void*)touch;
		
		//Get real coordinates
		CGPoint cgp = [touch locationInView: self];
		cgp.y = screenHeight - cgp.y;
		
		//Cleanup swords with same id
		int i = 0;
		while (i<[mainGame.swords count]) {
			Sword *s = [mainGame.swords objectAtIndex: i];
			if (s.touchID == touchID)
				[mainGame.swords removeObjectAtIndex: i];
			else
				i++;
		}
		
		//Initiate sword
		Sword *s = [[Sword alloc] initWithTouchID: touchID CoordX: cgp.x CoordY: cgp.y];
		[mainGame.swords insertObject: s atIndex: [mainGame.swords count]];
		[s release];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		//Get touch ID
		int touchID = (int)(void*)touch;
		
		//Get real coordinates
		CGPoint cgp = [touch locationInView: self];
		cgp.y = screenHeight - cgp.y;
		
		//Find sword
		for (int i=0; i<[mainGame.swords count]; i++) {
			Sword *s = [mainGame.swords objectAtIndex: i];
			if (s.touchID == touchID) {
				[s addCoordX: cgp.x CoordY: cgp.y Force: TRUE];
				break;
			}
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		//Get touch ID
		int touchID = (int)(void*)touch;
		
		//Find sword
		for (int i=0; i<[mainGame.swords count]; i++) {
			Sword *s = [mainGame.swords objectAtIndex: i];
			if (s.touchID == touchID)
				[s endCoords];
		}
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {	
	for (UITouch *touch in touches) {
		//Get touch ID
		int touchID = (int)(void*)touch;
		
		//Find sword
		for (int i=0; i<[mainGame.swords count]; i++) {
			Sword *s = [mainGame.swords objectAtIndex: i];
			if (s.touchID == touchID)
				[s endCoords];
		}
	}
}

#pragma mark UI Events

-(void) pauseClick {
	//Click sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Pause
	[self pauseGame];
}

-(void) resumeClick {
	//Click sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Resume
	[self resumeGame];
}

-(void) restartClick {
	//Click sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Reset game state
	[mainGame resetGame];
	//Resume
	[self resumeGame];
}

-(void) optionsClick {
	//Click sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Flag
	self.parent.wentToSecondaryWindow = TRUE;
	
	//Present options controller
	OptionsViewController *ovc = [[[OptionsViewController alloc] initWithNibName: @"OptionsViewController" bundle: nil] autorelease];
	[self.parent presentFadingViewController: ovc];
}

-(void) quitClick {
	//Click sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Actual quit
	[parent quitToMainMenu];
}

-(void) retryClick {
	//Click sound
	[[Audio sharedAudio] playSound: @"touch"];
	
	//Reset game state
	[mainGame resetGame];
	[bannerView_ removeFromSuperview];
	//Resume
	[self restartGame];
}

-(void) scoresClick {
	//Click sound
	[[Audio sharedAudio] playSound: @"touch"];
	[bannerView_ removeFromSuperview];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/fruit-slayer!/id492296208?ls=1&mt=8"]];
    
}

#pragma mark Other events

-(void) pauseGame {
	if (!mainGame.active)
		return;
	
	//Stop animation and present menu
	[self stopAnimation];
	[self animateControlsIn];
	
	//Sound
	[[Audio sharedAudio] playSound: @"whoosh1"];
}

-(void) resumeGame {
	if (!mainGame.active)
		return;
	
	//Start animation and hide menu
	[self startAnimation];
	[self animateControlsOut];
	
	//Sound
	[[Audio sharedAudio] playSound: @"whoosh1"];
}

-(void) restartGame {
	//Start animation and hide menu
	[self startAnimation];
	[self animateGameOverOut];
	
	//Sound
	[[Audio sharedAudio] playSound: @"whoosh1"];
}

-(void) gameOver {
	//Deactivate game
	mainGame.active = FALSE;
	
	//Sound
	//[[Audio sharedAudio] playSound: @"tumtum"];
	
	//Stop animation and present game over
	[self stopAnimation];
	[self animateGameOverIn];

	//Scorekeeping
	if (isFullGame) {
		//Add new score
	//	[[GameKitLibrary sharedGameKit] addNewScore: mainGame.score Category: mainGame.mode Sync: FALSE];
		
		//Update achievements
		if (mainGame.mode == 0) {
			if (mainGame.score >= 300) {
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 0 Sync: FALSE];
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 1 Sync: FALSE];
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 2 Sync: FALSE];
			} else if (mainGame.score >= 200) {
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 0 Sync: FALSE];
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 1 Sync: FALSE];			
			} else if (mainGame.score >= 100) {
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 0 Sync: FALSE];
			}
		} else if (mainGame.mode == 1) {
			if (mainGame.score >= 300) {
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 3 Sync: FALSE];
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 4 Sync: FALSE];
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 5 Sync: FALSE];
			} else if (mainGame.score >= 200) {
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 3 Sync: FALSE];
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 4 Sync: FALSE];			
			} else if (mainGame.score >= 100) {
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 3 Sync: FALSE];
			}
		} else if (mainGame.mode == 2) {
			if (mainGame.score >= 300) {
		//		[[GameKitLibrary sharedGameKit] completeAchievement: 6 Sync: FALSE];			
			}
		}

	}
}

#pragma mark Facebook/Twitter/Email sharing

-(void)broadcastToTwitter{
	SHKItem *item = [SHKItem text: [self textToBroadcast]];
	item.title = @"FruitSlayer for iPhone";
	
	SHKSharer *controller = [[[SHKTwitter alloc] init] autorelease];
	controller.item = item;
	[controller share];
}

-(void)broadcastToFacebook {
	SHKItem *item = [SHKItem text: [self textToBroadcast]];
	item.title = @"FruitSlayer for iPhone";
	
	SHKSharer *controller = [[[SHKFacebook alloc] init] autorelease];
	controller.item = item;
	[controller share];
}

-(NSString *) textToBroadcast {
	if (isFullGame)
		return [NSString stringWithFormat: @"I just got %i points in #FruitSlayer!!! Can you beat me? http://bit.ly/fruitslayerapp", [[GameKitLibrary sharedGameKit] getBestScoreForCategory: mainGame.mode]];
	else
		return @"Download FruitSlayer from the AppStore! This game is awesome! http://bit.ly/fruitslayerapp";
}

#pragma mark Memory management

- (void)dealloc {
	//Release
	[self stopAnimation];
	[self unloadTextures];
	
	//Release
	[mainGame release];
	mainGame = nil;
	
	//Debug
	NSLog(@"GLView deallocated");
	
	//Super
	[super dealloc];
}

@end
