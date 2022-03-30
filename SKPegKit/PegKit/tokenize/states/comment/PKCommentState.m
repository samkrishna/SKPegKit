//
//  PKCommentState.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import "PKTokenizer.h"
#import "PKToken.h"
#import "PKReader.h"
#import "PKSingleLineCommentState.h"
#import "PKMultiLineCommentState.h"
#import "PKCommentState.h"

@interface PKCommentState ()
@property (nonatomic, readwrite, strong) PKSymbolRootNode *rootNode;
@property (nonatomic, readwrite, strong) PKSingleLineCommentState *singleLineState;
@property (nonatomic, readwrite, strong) PKMultiLineCommentState *multiLineState;
@end

@implementation PKCommentState

- (void)addSingleLineStartMarker:(NSString *)start {

}

- (void)removeSingleLineStartMarker:(NSString *)start {

}

- (void)addMultiLineStartMarker:(NSString *)start endMarker:(NSString *)end {

}

- (void)removeMultiLineStartMarker:(NSString *)start {
    
}

@end
