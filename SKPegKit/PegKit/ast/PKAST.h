//
//  PKAST.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

@import Foundation;

@class PKToken;

@interface PKAST : NSObject <NSCopying>

@property (nonatomic, readonly, assign) NSUInteger type;
@property (nonatomic, readonly, strong) NSString *name;

@property (nonatomic, readwrite, strong) PKToken *token;
@property (nonatomic, readwrite, strong) NSMutableArray *children;

+ (instancetype)ASTWithToken:(PKToken *)tok;
- (instancetype)initWithToken:(PKToken *)tok;

- (void)addChild:(PKAST *)a;
- (BOOL)isNil;

- (NSString *)treeDescription;

@end

