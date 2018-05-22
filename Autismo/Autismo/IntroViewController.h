//
//  IntroRoutinesViewController.h
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 23/11/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"

@interface IntroViewController : UIViewController <EAIntroDelegate>

-(void)showRoutinesIntro:(UIView*)view;
-(void)showMainIntro:(UIView*)view;


@end
