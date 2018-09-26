//
//  AutoHeightRichText.m
//  HuaYang
//
//  Created by johnxguo on 2017/5/8.
//  Copyright © 2017年 tencent. All rights reserved.

#import "AutoHeightRichText.h"

@implementation AHRichItem

- (Type)type {
    return None;
}

@end

@implementation TextRichItem

- (TextRichItem *)initWithText:(NSString *)text
                     textColor:(UIColor *)color
                      textFont:(UIFont *)font
                   endEllipsis:(BOOL)endEllipsis
                         click:(void(^)())click
                        schema:(NSString *)schema {
    if (self = [super init]) {
        self.text = text;
        self.textColor = color;
        self.textFont = font;
        self.endEllipsis = endEllipsis;
        self.click = click;
        self.schema = schema;
        self.canHide = FALSE;
    }
    return self;
}

- (Type)type {
    return Text;
}

@end

@implementation ImageRichItem

- (ImageRichItem *)initWithImage:(UIImage *)image
                       imageSize:(CGSize)size
                           click:(void (^)())click
                          schema:(NSString *)schema {
    if (self = [super init]) {
        self.image = image;
        self.imageSize = size;
        self.click = click;
        self.schema = schema;
        self.canHide = FALSE;
    }
    return self;
}

- (Type)type {
    return Image;
}

@end

@interface HitRect : NSObject
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, retain) AHRichItem *item;
@end

@interface FitItem : NSObject
@property (nonatomic, assign) int line;
@property (nonatomic, assign) CGFloat x;
@end

@interface TextFitItem : FitItem
@property (nonatomic, retain) TextRichItem *item;
@property (nonatomic, copy) NSString *primeString;
@end

@interface ImageFitItem : FitItem
@property (nonatomic, retain) ImageRichItem *item;
@end

@interface LineItem : NSObject
@property (nonatomic, retain) DrawItem *drawitem;
@property (nonatomic, retain) AHRichItem *richitem;
@end

@implementation HitRect
@end

@implementation FitItem
@end

@implementation TextFitItem
@end

@implementation ImageFitItem
@end

@implementation LineItem
@end

@implementation DrawItem
@end

@implementation ImageDrawItem
@end

@implementation TextDrawItem
@end

@implementation AutoHeightRichText {
    BOOL _needFit;
    CGFloat _height;
    NSMutableArray<AHRichItem *> *_items;
    NSMutableArray<HitRect *> *_hitRects;
    NSString* _ellipsis;
    NSString* _c_r;
    NSUInteger _lockFitLoc;
    int _lockMaxline;
}

- (instancetype)init {
    if (self = [super init]) {
        _ellipsis = @"...";
        _lockFitLoc = 0;
        _lockMaxline = 0;
        _c_r = @"\n";
        _items = [[NSMutableArray alloc] init];
        _hitRects = [[NSMutableArray alloc] init];
        _drawItems = [[NSMutableArray alloc] init];
        [self clear];
    }
    return self;
}
-(void)dealloc
{
    [self clear];
}

- (void)clear {
    _needFit = TRUE;
    _height = 0;
    [_items removeAllObjects];
    [_hitRects removeAllObjects];
    [(NSMutableArray*)_drawItems removeAllObjects];
}

- (CGFloat)height {
    return _height;
}

- (void)setWidth:(CGFloat)width {
    if (width != _width) {
        _needFit = TRUE;
        _width = width;
    }
}

- (void)addItem:(AHRichItem *)item {
    if (!item) {
        return;
    }
    
    if (item.type == None) {
        return;
    }
    _needFit = TRUE;
    [_items addObject:item];
}


- (void)lockFit {
    if (_maxLine == INT_MAX) {
        return;
    }
    
    _lockFitLoc = _items.count;
    _lockMaxline = _maxLine;
}

- (void)unlockFit {
    _lockFitLoc = 0;
    _lockMaxline = 0;
}

- (BOOL)fit {
    if (!_needFit) {
        return FALSE;
    }
    
    if (_lockFitLoc > 0 && _maxLine < INT_MAX) {
        return FALSE;
    }
    
    if (_width == 0) {
        return FALSE;
    }
    
    NSMutableArray *waitList = [[NSMutableArray alloc] init];
    NSMutableArray *doneList = [[NSMutableArray alloc] init];
    
    int t_line = 0;
    CGFloat t_x = 0;
    
    NSUInteger count = _items.count;
    for (NSUInteger i = 0; i < _lockFitLoc; i++) {
        AHRichItem *item = _items[i];
        if (item.type == Text) {
            TextFitItem *fitItem = [[TextFitItem alloc] init];
            fitItem.item = (TextRichItem *)item;
            fitItem.primeString = fitItem.item.text;
            [waitList addObject:fitItem];
        } else if (item.type == Image) {
            ImageFitItem *fitItem = [[ImageFitItem alloc] init];
            fitItem.item = (ImageRichItem *)item;
            [waitList addObject:fitItem];
        }
    }
    
    if (waitList.count > 0) {
        if (![self fitWithLock:waitList
                      doneList:doneList
                       maxLine:_lockMaxline
                        t_line:&t_line
                           t_x:&t_x]) {
            return FALSE;
        }
    }
    
    [waitList removeAllObjects];
    
    for (NSUInteger i = _lockFitLoc; i < count; i++) {
        AHRichItem *item = _items[i];
        if (item.type == Text) {
            TextFitItem *fitItem = [[TextFitItem alloc] init];
            fitItem.item = (TextRichItem *)item;
            fitItem.primeString = fitItem.item.text;
            [waitList addObject:fitItem];
        } else if (item.type == Image) {
            ImageFitItem *fitItem = [[ImageFitItem alloc] init];
            fitItem.item = (ImageRichItem *)item;
            [waitList addObject:fitItem];
        }
    }
    
    if (waitList.count > 0) {
        if (![self fitWithLock:waitList
                      doneList:doneList
                       maxLine:_maxLine
                        t_line:&t_line
                           t_x:&t_x]) {
            return FALSE;
        }
    }
    
    [self createDrawItems:doneList];
    
    _needFit = FALSE;
    
    return TRUE;
}

- (BOOL)fitWithLock:(NSMutableArray *)waitList
           doneList:(NSMutableArray *)doneList
            maxLine:(int)maxLine
             t_line:(int *)p_t_line
                t_x:(CGFloat *)p_t_x {
    
    int t_line = *p_t_line;
    CGFloat t_x = *p_t_x;
    int r_line = maxLine - 1;
    CGFloat r_x = self.width;
    
    while ([waitList count] != 0) {
        
        NSObject *item = [waitList objectAtIndex:0];
        [waitList removeObjectAtIndex:0];
        
        if (![self addInternal:item
                          line:&t_line
                             x:&t_x
                       maxLine:maxLine]) {
            
            NSMutableArray *newWaitList = [[NSMutableArray alloc] init];
            for (NSObject *obj in waitList) {
                if ([obj isKindOfClass:[TextFitItem class]]) {
                    TextFitItem *t = (TextFitItem *)obj;
                    if (t.item.canHide) {
                        continue;
                    }
                    if (t.item.endEllipsis) {
                        t.primeString = _ellipsis;
                    }
                    [newWaitList addObject:t];
                } else {
                    ImageFitItem *t = (ImageFitItem *)obj;
                    if (t.item.canHide) {
                        continue;
                    }
                    [newWaitList addObject:t];
                }
            }
            
            do {
                NSMutableArray* tlist = [doneList mutableCopy];
                
                int count = (int)[newWaitList count];
                BOOL flag = FALSE;
                for (int i = count - 1; i >= 0; i--) {
                    if (![self addReverse:newWaitList[i]
                                     line:&r_line
                                        x:&r_x]) {
                        flag = TRUE;
                        break;
                    }
                }
                
                if (!flag) {
                    if ([self makeEllipsis:newWaitList
                                  doneList:tlist
                                   pending:item
                                    t_line:&t_line
                                       t_x:&t_x
                                    r_line:&r_line
                                       r_x:&r_x]) {
                        [doneList removeAllObjects];
                        [doneList addObjectsFromArray:tlist];
                        break;
                    }
                }
                
                [newWaitList removeAllObjects];
                tlist = [doneList mutableCopy];
                r_line = maxLine - 1;
                r_x = self.width;
                
                if ([self makeEllipsis:newWaitList
                              doneList:tlist
                               pending:item
                                t_line:&t_line
                                   t_x:&t_x
                                r_line:&r_line
                                   r_x:&r_x]) {
                    [doneList removeAllObjects];
                    [doneList addObjectsFromArray:tlist];
                    break;
                }
                
                break;
                
            } while (0);
            
            t_line = maxLine;
            t_x = self.width;
            break;
            
        } else {
            [doneList addObject:item];
        }
    }
    
    *p_t_line = t_line;
    *p_t_x = t_x;
    
    return TRUE;
}

- (void)createDrawItems:(NSArray *)doneList {
    NSMutableArray *di = (NSMutableArray *)self.drawItems;
    [di removeAllObjects];
    [_hitRects removeAllObjects];
    
    NSMutableArray *line = [[NSMutableArray alloc] init];
    __block CGFloat x = 0;
    __block CGFloat y = 0;
    __block CGFloat maxHeight = 0;
    for (FitItem *item in doneList) {
        if ([item isKindOfClass:[TextFitItem class]]) {
            TextFitItem *t = (TextFitItem *)item;
            NSString *str = t.primeString;
            NSUInteger length = [str length];
            NSRange fullRange = NSMakeRange(0, length);
            __block NSUInteger st = 0;
            __block CGFloat loc = x;
            
            [str enumerateSubstringsInRange:fullRange
                                    options:NSStringEnumerationByComposedCharacterSequences
                                 usingBlock:^(NSString * _Nullable substring,
                                              NSRange substringRange,
                                              NSRange enclosingRange,
                                              BOOL * _Nonnull stop) {
                                     BOOL lineBreak = FALSE;
                                     NSUInteger new_st = 0;
                                     if ([substring isEqualToString:_c_r]) {
                                         lineBreak = TRUE;
                                         new_st = substringRange.location + substringRange.length;
                                     } else {
                                         CGSize size = [self getSize:substring font:t.item.textFont];
                                         if (loc + size.width > self.width) {
                                             lineBreak = TRUE;
                                             new_st = substringRange.location;
                                             loc = size.width;
                                         } else {
                                             loc += size.width;
                                         }
                                     }
                                     
                                     if (lineBreak) {
                                         TextDrawItem *td = [[TextDrawItem alloc] init];
                                         td.text = [str substringWithRange:NSMakeRange(st, substringRange.location - st)];
                                         td.textColor = t.item.textColor;
                                         td.textFont = t.item.textFont;
                                         CGSize size = [self getSize:td.text font:t.item.textFont];
                                         td.rect = CGRectMake(x, y, size.width, size.height);
                                         LineItem *lineItem = [[LineItem alloc] init];
                                         lineItem.drawitem = td;
                                         lineItem.richitem = t.item;
                                         [line addObject:lineItem];
                                         x = 0;
                                         y = [self addDrawLine:line
                                                     maxHeight:&maxHeight];
                                         st = new_st;
                                         [line removeAllObjects];
                                     }
                                 }];
            
            if (st < length) {
                TextDrawItem *td = [[TextDrawItem alloc] init];
                td.text = [str substringWithRange:NSMakeRange(st, length - st)];
                td.textColor = t.item.textColor;
                td.textFont = t.item.textFont;
                CGSize size = [self getSize:td.text font:t.item.textFont];
                CGRect rect = CGRectMake(x, y, size.width, size.height);
                td.rect = rect;
                LineItem *lineItem = [[LineItem alloc] init];
                lineItem.drawitem = td;
                lineItem.richitem = t.item;
                [line addObject:lineItem];
                x += size.width;
            }
            
            
        } else if ([item isKindOfClass:[ImageFitItem class]]) {
            ImageFitItem *t = (ImageFitItem *)item;
            if (x + t.item.imageSize.width > self.width) {
                x = 0;
                int _y = [self addDrawLine:line
                            maxHeight:&maxHeight];
                if (_y != 0) {
                    y = _y;
                } else {
                    y = y + maxHeight;
                }
                [line removeAllObjects];
            }
            
            ImageDrawItem *td =[[ImageDrawItem alloc] init];
            td.image = t.item.image;
            td.url = t.item.url;
            td.rect = CGRectMake(x, y, t.item.imageSize.width, t.item.imageSize.height);
            LineItem *lineItem = [[LineItem alloc] init];
            lineItem.drawitem = td;
            lineItem.richitem = t.item;
            [line addObject:lineItem];
            x += td.rect.size.width;
            
        }
    }
    
    if ([line count] > 0) {
        y = [self addDrawLine:line
                    maxHeight:&maxHeight];
    }
    
    _height = y;
}

- (CGFloat)addDrawLine:(NSArray *)line
             maxHeight:(CGFloat *)p_maxHeight {
    
    CGFloat maxHeight = 0;
    CGFloat ret_y = 0;
    BOOL flag = FALSE;
    for (LineItem *item in line) {
        CGFloat h = item.drawitem.rect.size.height;
        maxHeight = maxHeight > h ? maxHeight : h;
    }
    
    *p_maxHeight = maxHeight;
    
    NSMutableArray *draws = (NSMutableArray *)self.drawItems;
    for (LineItem *item in line) {
        CGFloat h = item.drawitem.rect.size.height;
        CGRect rect = item.drawitem.rect;
        rect.origin.y += (maxHeight - h) / 2;
        item.drawitem.rect = rect;
        [draws addObject:item.drawitem];
        HitRect* hit = [[HitRect alloc] init];
        hit.item = item.richitem;
        hit.rect = rect;
        [_hitRects addObject:hit];
        
        if (!flag) {
            flag = TRUE;
            ret_y = rect.origin.y + (maxHeight + h) / 2;
        }
    }
    
    return ret_y;
}

- (BOOL)makeEllipsis:(NSMutableArray *)waitList
            doneList:(NSMutableArray *)doneList
             pending:(NSObject *)pending
              t_line:(int *)p_t_line
                 t_x:(CGFloat *)p_t_x
              r_line:(int *)p_r_line
                 r_x:(CGFloat *)p_r_x {
    
    int r_line = *p_r_line;
    CGFloat r_x = *p_r_x;
    
    do {
        
        if (((TextFitItem *)pending).item.canHide) {
            continue;
        }
        
        if (([pending isKindOfClass:[TextFitItem class]]
             && !((TextFitItem *)pending).item.endEllipsis)||
            [pending isKindOfClass:[ImageFitItem class]]) {
            
            [waitList insertObject:pending atIndex:0];
            
            [self addReverse:pending
                        line:&r_line
                           x:&r_x];
            
        } else {
            break;
        }
        
        pending = nil;
        
    } while ([doneList count] > 0 &&
             (pending = [doneList lastObject]) &&
             ([doneList removeLastObject], TRUE));
    
    if (!pending) {
        return FALSE;
    }
    
    TextFitItem *pendingText = (TextFitItem *)pending;
    
    CGSize ellipsisSize = [self getSize:_ellipsis
                                   font:(UIFont *)pendingText.item.textFont];
    
    int t_line = 0;
    CGFloat t_x = 0;
    
    if ([doneList count] > 0) {
        FitItem * item = (FitItem *)[doneList lastObject];
        t_line = item.line;
        t_x = item.x;
    }
    
    if (r_line > t_line || (r_line == t_line && r_x > t_x + ellipsisSize.width)) {
        [self culEllipsisString:pendingText
                         t_line:t_line
                            t_x:t_x
                         r_line:r_line
                            r_x:r_x];
        [waitList insertObject:pending atIndex:0];
        for (NSObject *item in waitList) {
            [doneList addObject:item];
        }
        *p_t_line = t_line;
        *p_r_line = r_line;
        *p_t_x = t_x;
        *p_r_x = r_x;
        return TRUE;
        
    } else {
        if ([doneList count] == 0) {
            return FALSE;
        }
        
        pending = [doneList lastObject];
        [doneList removeLastObject];
        pendingText.primeString = _ellipsis;
        [waitList insertObject:pendingText atIndex:0];
        
        if ([self makeEllipsis:waitList
                      doneList:doneList
                       pending:pending
                        t_line:&t_line
                           t_x:&t_x
                        r_line:&r_line
                           r_x:&r_x]) {
            *p_t_line = t_line;
            *p_r_line = r_line;
            *p_t_x = t_x;
            *p_r_x = r_x;
            return TRUE;
        }
    }
    
    return FALSE;
}

- (void)culEllipsisString:(TextFitItem *)pending
                   t_line:(int)t_line
                      t_x:(CGFloat)t_x
                   r_line:(int)r_line
                      r_x:(CGFloat)r_x {
    
    NSString *str = pending.primeString;
    NSUInteger length = [str length];
    CGSize ellipsisSize = [self getSize:_ellipsis
                                   font:(UIFont *)pending.item.textFont];
    NSRange fullRange = NSMakeRange(0, length);
    
    __block int end = (int)length - 1;
    __block int b_line = t_line;
    __block CGFloat b_x = t_x;
    
    [str enumerateSubstringsInRange:fullRange
                            options:NSStringEnumerationByComposedCharacterSequences
                         usingBlock:^(NSString * _Nullable substring,
                                      NSRange substringRange,
                                      NSRange enclosingRange,
                                      BOOL * _Nonnull stop) {
                             if ([substring isEqualToString:_c_r]) {
                                 if (++b_line > r_line) {
                                     if (substringRange.location > 0) {
                                         end = (int)(substringRange.location - 1);
                                     }
                                     *stop = YES;
                                 } else {
                                     b_x = 0;
                                 }
                             } else {
                                 CGSize size = [self getSize:substring font:pending.item.textFont];
                                 if (b_line == r_line) {
                                     if (b_x + size.width + ellipsisSize.width >= r_x) {
                                         if (substringRange.location > 0) {
                                             end = (int)(substringRange.location - 1);
                                         }
                                         *stop = YES;
                                     } else {
                                         b_x += size.width;
                                     }
                                 } else {
                                     if (b_x + size.width >= self.width) {
                                         b_line++;
                                         b_x = size.width;
                                         if (b_line == r_line) {
                                             if (b_x + ellipsisSize.width >= r_x) {
                                                 if (substringRange.location > 0) {
                                                     end = (int)(substringRange.location - 1);
                                                 }
                                                 *stop = YES;
                                             }
                                         }
                                     } else {
                                         b_x += size.width;
                                     }
                                 }
                             }
                        }];

    
    pending.primeString = [[str substringWithRange:NSMakeRange(0, end + 1)] stringByAppendingString:_ellipsis];

}

- (BOOL)addReverse:(NSObject *)item
              line:(int *)p_line
                 x:(CGFloat *)p_x {
    
    __block int line = *p_line;
    __block int x = *p_x;
    
    if ([item isKindOfClass:[TextFitItem class]]) {
        TextFitItem *t = (TextFitItem *)item;
        NSString* text = t.primeString;
        int length = (int)[text length];
        NSRange fullRange = NSMakeRange(0, length);
        __block BOOL fail = FALSE;
        [text enumerateSubstringsInRange:fullRange
                                 options:NSStringEnumerationByComposedCharacterSequences
                              usingBlock:^(NSString * _Nullable substring,
                                           NSRange substringRange,
                                           NSRange enclosingRange,
                                           BOOL * _Nonnull stop) {
                                  if ([substring isEqualToString:_c_r]) {
                                      if (--line < 0) {
                                          fail = TRUE;
                                          *stop = YES;
                                      } else {
                                          x = 0;
                                      }
                                  } else {
                                      CGSize size = [self getSize:substring font:t.item.textFont];
                                      if (x - size.width < 0) {
                                          if (--line < 0) {
                                              fail = TRUE;
                                              *stop = YES;
                                          } else {
                                              x = self.width - size.width;
                                          }
                                      } else {
                                          x -= size.width;
                                      }
                                  }
                              }];
        if (fail) {
            return FALSE;
        }
        
    } else if ([item isKindOfClass:[ImageFitItem class]]) {
        ImageFitItem *t = (ImageFitItem *)item;
        CGSize size = t.item.imageSize;
        if (x - size.width < 0) {
            if (--line < 0) {
                return FALSE;
            } else {
                x = self.width - size.width;
            }
        } else {
            x -= size.width;
        }
    }
    
    *p_line = line;
    *p_x = x;

    return TRUE;
}

- (BOOL)addInternal:(NSObject *)item
               line:(int *)p_line
                  x:(CGFloat *)p_x
            maxLine:(int)maxLine {
    
    __block int line = *p_line;
    __block CGFloat x = *p_x;
    
    if ([item isKindOfClass:[TextFitItem class]]) {
        TextFitItem *t = (TextFitItem *)item;
        NSString* text = t.primeString;
        NSUInteger length = [text length];
        NSRange fullRange = NSMakeRange(0, length);
        __block BOOL fail = FALSE;
        
        [text enumerateSubstringsInRange:fullRange
                                options:NSStringEnumerationByComposedCharacterSequences
                             usingBlock:^(NSString * _Nullable substring,
                                          NSRange substringRange,
                                          NSRange enclosingRange,
                                          BOOL * _Nonnull stop) {
                                 if ([substring isEqualToString:_c_r]) {
                                     if (++line >= maxLine) {
                                         fail = TRUE;
                                         *stop = YES;
                                     } else {
                                         x = 0;
                                     }
                                 } else {
                                     CGSize size = [self getSize:substring font:t.item.textFont];
                                     if (x + size.width > self.width) {
                                         if (++line >= maxLine) {
                                             fail = TRUE;
                                             *stop = YES;
                                         } else {
                                             x = size.width;
                                         }
                                     } else {
                                         x += size.width;
                                     }
                                 }
                             }];
        
        if (fail) {
            return FALSE;
        }
        
        t.line = line;
        t.x = x;
        
    } else if ([item isKindOfClass:[ImageFitItem class]]) {
        ImageFitItem *t = (ImageFitItem *)item;
        CGSize size = t.item.imageSize;
        if (x + size.width > self.width) {
            if (++line >= maxLine) {
                return FALSE;
            } else {
                x = size.width;
            }
        } else {
            x += size.width;
        }
        
        t.line = line;
        t.x = x;
    }
    
    *p_line = line;
    *p_x = x;
    
    return TRUE;
}

- (void)hit:(CGPoint)point {
    for (HitRect* rect in _hitRects) {
        if ([self isPoint:point inRect:rect.rect]) {
            if (rect.item.click) {
                rect.item.click();
            }
            if (rect.item.schema) {
                // exec schema
            }
            break;
        }
    }
}

- (BOOL)isPoint:(CGPoint)point
         inRect:(CGRect)rect {
    return point.x >= rect.origin.x &&
           point.x <  rect.origin.x + rect.size.width &&
           point.y >= rect.origin.y &&
           point.y <  rect.origin.y + rect.size.height;
}

- (CGSize)getSize:(NSString *)str
             font:(UIFont *)font {
    return [str sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

@end
