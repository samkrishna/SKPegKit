//
//  PKURLState.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import <SKPegKit/PKTokenizerState.h>

@interface PKURLState : PKTokenizerState

@property (nonatomic, readwrite, assign) BOOL allowsWWWPrefix;

@end

