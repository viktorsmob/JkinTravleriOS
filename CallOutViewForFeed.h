//
//  CallOutViewForFeed.h
//  HuntersRoom
//
//  Created by Manish on 17/02/15.
//  Copyright (c) 2014 Manish. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TouchEventsDelegate <NSObject>

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;
@end
@interface CallOutViewForFeed : UIView


@property (nonatomic,strong)IBOutlet UIButton *btnOnCallOut;

@property (nonatomic,strong)IBOutlet UILabel  *lblStoreName;
@property (nonatomic,strong)IBOutlet UILabel *lblHotDeal;

@property (nonatomic,strong)IBOutlet UILabel *lblState;
@property (nonatomic,strong)IBOutlet UILabel *lblTime;

@property (nonatomic,strong)IBOutlet UIImageView *imgBg;
@property (nonatomic,strong)IBOutlet UIImageView *imgDownArrow;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *BtnDirection;
@property (strong, nonatomic) IBOutlet UIButton *BtnFbInfo;

- (IBAction)BtnBackClicked:(id)sender;


+ (CallOutViewForFeed*)ViewWithFrame:(CGRect)frame;
@end
