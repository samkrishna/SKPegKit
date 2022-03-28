//
//  PKCommentState.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import <SKPegKit/SKPegKit.h>

@interface PKCommentState : PKTokenizerState

- (void)addSingleLineStartMarker:(NSString *)start;
- (void)removeSingleLineStartMarker:(NSString *)start;
- (void)addMultiLineStartMarker:(NSString *)start endMarker:(NSString *)end;
- (void)removeMultiLineStartMarker:(NSString *)start;

@property (nonatomic, readonly, assign) BOOL reportCommentTokens;
@property (nonatomic, readonly, assign) BOOL balancedEOFTerminatedComments;

@end

