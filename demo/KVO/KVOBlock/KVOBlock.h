//
//  KVOBlock.h
//  KVOBlock
//
//  Created by wangkan on 2017/2/20.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for KVOBlock.
FOUNDATION_EXPORT double KVOBlockVersionNumber;

//! Project version string for KVOBlock.
FOUNDATION_EXPORT const unsigned char KVOBlockVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KVOBlock/PublicHeader.h>

typedef void(^KVOBlockChange) (__weak __nullable id self, __nullable id old, __nullable id newVal);

@interface NSObject (KVOBlock)
/**
 *  Safe KVO whitout manual remove observer
 *
 *  @param keyPath          keypath
 *  @param observationBlock three object (observingTarget, oldValue, newValue)
 */
- (void)observeKeyPath:(nonnull NSString*)keyPath withBlock:(nonnull KVOBlockChange)observationBlock;
- (void)removeObserverFor:(nonnull NSString*)keyPath;
@end
