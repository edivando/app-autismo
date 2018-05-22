//
//  IntroRoutinesViewController.m
//  Autismo
//
//  Created by Antônio Ramon Vasconcelos de Freitas on 23/11/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController () {
    UIView *rootView;
    EAIntroView *_intro;
}

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rootView = self.navigationController.view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showRoutinesIntro:(UIView*)view {
    //basic
    EAIntroPage *page1 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroRoutine1"];
    EAIntroPage *page2 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroRoutine2"];
    EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroRoutine3"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:view.bounds andPages:@[page1,page2,page3]];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(0, 0, 130, 30)];
    [btn setTitle:NSLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 2.f;
    btn.layer.cornerRadius = 10;
    btn.layer.borderColor = [[UIColor blueColor] CGColor];
    intro.skipButton = btn;
    intro.skipButtonY = 40.f;
    intro.skipButtonAlignment = EAViewAlignmentCenter;
    
    [intro setDelegate:self];
    [intro showInView:view animateDuration:0.3];

}

-(void)showMainIntro:(UIView*)view {
    EAIntroPage *page1 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroMain1"];
    EAIntroPage *page2 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroMain2"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:view.bounds andPages:@[page1,page2]];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(0, 0, 130, 30)];
    [btn setTitle:NSLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 2.f;
    btn.layer.cornerRadius = 10;
    btn.layer.borderColor = [[UIColor blueColor] CGColor];
    intro.skipButton = btn;
    intro.skipButtonY = 40.f;
    intro.skipButtonAlignment = EAViewAlignmentCenter;
    
    [intro setDelegate:self];
    [intro showInView:view animateDuration:0.3];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
