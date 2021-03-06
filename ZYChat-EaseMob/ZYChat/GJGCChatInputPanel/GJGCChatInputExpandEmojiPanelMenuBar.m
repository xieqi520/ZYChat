                                                                                      //
//  GJGCChatInputExpandEmojiPanelMenuBar.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/6/4.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCChatInputExpandEmojiPanelMenuBar.h"
#import "GJGCChatInputExpandEmojiPanelMenuBarDataSource.h"

@implementation GJGCChatInputExpandEmojiPanelMenuBarItem

- (instancetype)initWithIconName:(NSString *)iconName
{
    if (self = [super init]) {
        
        self.gjcf_width = 62;
        self.gjcf_height = 40.5f;
        
        self.backImgView = [[UIImageView alloc]init];
        self.backImgView.gjcf_size = self.gjcf_size;
        [self addSubview:self.backImgView];
     
        self.iconImgView = [[UIImageView alloc]init];
        self.iconImgView.gjcf_size = (CGSize){30,30};
        self.iconImgView.gjcf_centerX = self.gjcf_width/2;
        self.iconImgView.gjcf_centerY = self.gjcf_height/2;
        self.iconImgView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.iconImgView];
        self.iconImgView.image = [UIImage imageNamed:iconName];
        
        self.rightSeprateLine = [[UIImageView alloc]init];
        self.rightSeprateLine.gjcf_size = CGSizeMake(0.5, self.gjcf_height);
        self.rightSeprateLine.backgroundColor = [GJGCChatInputPanelStyle mainSeprateLineColor];
        self.rightSeprateLine.gjcf_right = self.gjcf_width;
        [self addSubview:self.rightSeprateLine];
        self.rightSeprateLine.hidden = YES;
        
        [self switchToNormal];
    }
    return self;
}

- (void)setSeprateLineShow:(BOOL)state
{
    self.rightSeprateLine.hidden = !state;
}

- (void)switchToSelected
{
    self.backImgView.backgroundColor = GJCFQuickHexColor(@"dadada");
}

- (void)switchToNormal
{
    self.backImgView.backgroundColor = [UIColor clearColor];
}

@end


#define GJGCChatInputExpandEmojiPanelMenuBarItemBaseTag 3355678

@implementation GJGCChatInputExpandEmojiPanelMenuBar

- (instancetype)initWithDelegate:(id<GJGCChatInputExpandEmojiPanelMenuBarDelegate>)aDelegate;
{
    if (self = [super init]) {
        
        self.itemSourceArray = [GJGCChatInputExpandEmojiPanelMenuBarDataSource menuBarItems];
        self.delegate = aDelegate;
        
        self.gjcf_width = 62*self.itemSourceArray.count;
        self.gjcf_height = 40.5;
        
        [self setupSubViewsWithSourceArray:self.itemSourceArray];
    }
    return self;
}

- (instancetype)initWithDelegateForCommentBarStyle:(id<GJGCChatInputExpandEmojiPanelMenuBarDelegate>)aDelegate
{
    if (self = [super init]) {
        
        self.itemSourceArray = [GJGCChatInputExpandEmojiPanelMenuBarDataSource commentBarItems];
        self.delegate = aDelegate;
        
        self.gjcf_width = 62*self.itemSourceArray.count;
        self.gjcf_height = 40.5;
        
        [self setupSubViewsWithSourceArray:self.itemSourceArray];
    }
    return self;
}

- (void)setupSubViewsWithSourceArray:(NSArray *)sourceArray
{
    CGFloat itemWidth = 62;
    CGFloat itemHeight = self.gjcf_height;
    
    for (NSInteger index = 0; index < sourceArray.count; index ++) {
        
        CGFloat marginX = index * itemWidth;
        CGFloat marginY = 0;
        
        GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem *sourceItem = [sourceArray objectAtIndex:index];
        
        GJGCChatInputExpandEmojiPanelMenuBarItem *item = [[GJGCChatInputExpandEmojiPanelMenuBarItem alloc]initWithIconName:sourceItem.faceEmojiIconName];
        item.gjcf_left = marginX;
        item.gjcf_top = marginY;
        item.gjcf_width = itemWidth;
        item.gjcf_height = itemHeight;
        item.tag = GJGCChatInputExpandEmojiPanelMenuBarItemBaseTag + index;
        [item setSeprateLineShow:sourceItem.isNeedShowRightSideLine];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnBarItem:)];
        [item addGestureRecognizer:tapGesture];
        
        [self addSubview:item];
        
        if (index == 0) {
            
            _selectedIndex = 0;
            
            [item switchToSelected];
        }
    }
}

- (void)selectItemIndex:(NSInteger)index
{
    _selectedIndex = index;
    
    for (GJGCChatInputExpandEmojiPanelMenuBarItem *item in self.subviews) {
        
        if (item.tag - GJGCChatInputExpandEmojiPanelMenuBarItemBaseTag != index) {
            
            [item switchToNormal];
            
        }else{
            
            [item switchToSelected];
        }
    }
}

- (void)selectAtIndex:(NSInteger)index
{
    [self selectItemIndex:index];
}

- (void)tapOnBarItem:(UITapGestureRecognizer *)tapR
{
    UIView *tapView = tapR.view;
    
    NSInteger index = tapView.tag - GJGCChatInputExpandEmojiPanelMenuBarItemBaseTag;

    if (_selectedIndex == index) {
        return;
    }
    
    [self selectItemIndex:index];
    
    GJGCChatInputExpandEmojiPanelMenuBarDataSourceItem *sourceItem = [self.itemSourceArray objectAtIndex:index];

    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiPanelMenuBar:didChoose:)]) {
        
        [self.delegate emojiPanelMenuBar:self didChoose:sourceItem];
    }
}

@end
