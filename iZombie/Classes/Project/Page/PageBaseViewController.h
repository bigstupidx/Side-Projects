//
//  PageBaseViewController.h
//  iEngine
//
//  Created by Muhammed Safiul Azam on 9/14/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogUtility.h"


@interface PageBaseViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {

	PageBaseViewController *_parent;
	
	CGFloat _rotate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(PageBaseViewController *) parent;

-(PageBaseViewController *) getParent;

-(CGFloat) getRotate;
-(void) setRotate:(CGFloat) rotate;

@end
