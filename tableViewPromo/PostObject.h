//
//  PostObject.h
//  tableViewPromo
//
//  Created by Adam Cue on 2/11/14.
//  Copyright (c) 2014 GIDEON ROSENTHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostCell.h"

@interface PostObject : NSObject

@property (nonatomic, readwrite) NSInteger status;
@property (nonatomic, strong) NSString *postTitle;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, readwrite) NSInteger position;



@end
