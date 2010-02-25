//  BigBrowserView.m Copyright (c) 2001-2004 Philippe Mougin.
//  This software is open source. See the license.

#import "BigBrowserView.h"
#import <objc/objc-class.h>
#import <objc/objc.h>
#import "Compiler.h"
#import "ExecEngine.h"
#import "FSInterpreterPrivate.h"
#import "FSNSObject.h"
#import "Array.h"
#import "BigBrowserCell.h"
#import "miscTools.h"
#import "BlockStackElem.h"
#import "BlockPrivate.h"
#import "BlockInspector.h"
#import "miscTools.h"
#import "NewlyAllocatedObjectHolder.h"
#import "ArrayRepId.h"
#import "BigBrowserArgumentPanel.h"
#import "FScriptTextView.h"
#import "FSGenericObjectInspector.h"
#import "BigBrowserToolbar.h"
#import "System.h"
#import "BigBrowserButtonCtxBlock.h"
#import "BigBrowserToolbarButton.h"
#import "FSNSString.h"
#import "FSIdentifierFormatter.h"
#import "FSCollectionInspector.h"
#import "FSBoolean.h"
#import "NamedNumber.h"
#import "PointerPrivate.h"
#import "BigBrowserMatrix.h"
#import "PointerPrivate.h"

//#import "TestFS.h"

static int compareClassesForAlphabeticalOrder(id class1, id class2, void *context)
{
  NSString *class1String = printString(class1);
  NSString *class2String = printString(class2);
  
  if ([class1String hasPrefix:@"%"] && ![class2String hasPrefix:@"%"])
    return NSOrderedDescending;
  else if ([class2String hasPrefix:@"%"] && ![class1String hasPrefix:@"%"])
    return NSOrderedAscending;
  else
    return [class1String compare:class2String]; 
}

static int compareMethodsNamesForAlphabeticalOrder(NSString *m1, NSString *m2, void *context)
{  
  if ([m1 hasPrefix:@"_"] && ![m2 hasPrefix:@"_"])
    return NSOrderedDescending;
  else if ([m2 hasPrefix:@"_"] && ![m1 hasPrefix:@"_"])
    return NSOrderedAscending;
  else
    return [m1 compare:m2]; 
}

static id objectFromAutoresizingMask(unsigned int mask)
{
  if (mask & ~(NSViewMinXMargin | NSViewWidthSizable | NSViewMaxXMargin | NSViewMinYMargin | NSViewHeightSizable | NSViewMaxYMargin)) return [Number numberWithDouble:mask];
  else if (mask == 0) return [NamedNumber namedNumberWithDouble:NSRegularControlSize name:@"NSViewNotSizable"];
  else
  {
    NSMutableString *str = [NSMutableString string];
   
    if (mask & NSViewMinXMargin)    [str appendString:@"NSViewMinXMargin"];
    if (mask & NSViewWidthSizable)  [str appendString:[str length] == 0 ? @"NSViewWidthSizable"  : @" + NSViewWidthSizable"];
    if (mask & NSViewMaxXMargin)    [str appendString:[str length] == 0 ? @"NSViewMaxXMargin"    : @" + NSViewMaxXMargin"];
    if (mask & NSViewMinYMargin)    [str appendString:[str length] == 0 ? @"NSViewMinYMargin"    : @" + NSViewMinYMargin"];
    if (mask & NSViewHeightSizable) [str appendString:[str length] == 0 ? @"NSViewHeightSizable" : @" + NSViewHeightSizable"];
    if (mask & NSViewMaxYMargin)    [str appendString:[str length] == 0 ? @"NSViewMaxYMargin"    : @" + NSViewMaxYMargin"];
  
    return [NamedNumber namedNumberWithDouble:mask name:str];
  }  
}


static id objectFromBackingStoreType(NSBackingStoreType backingStoreType)
{
  switch (backingStoreType)
  {
  case NSBackingStoreBuffered:    return [NamedNumber namedNumberWithDouble:backingStoreType name:@"NSBackingStoreBuffered"];
  case NSBackingStoreRetained:    return [NamedNumber namedNumberWithDouble:backingStoreType name:@"NSBackingStoreRetained"];  
  case NSBackingStoreNonretained: return [NamedNumber namedNumberWithDouble:backingStoreType name:@"NSBackingStoreNonretained"];
  default:             return [Number numberWithDouble:backingStoreType];
  } 
}

static id objectFromBorderType(NSBorderType borderType)
{
  switch (borderType)
  {
  case NSNoBorder:     return [NamedNumber namedNumberWithDouble:borderType name:@"NSNoBorder"];
  case NSLineBorder:   return [NamedNumber namedNumberWithDouble:borderType name:@"NSLineBorder"];  
  case NSBezelBorder:  return [NamedNumber namedNumberWithDouble:borderType name:@"NSBezelBorder"];
  case NSGrooveBorder: return [NamedNumber namedNumberWithDouble:borderType name:@"NSGrooveBorder"];
  default:             return [Number numberWithDouble:borderType];
  } 
}

static id objectFromBezelStyle(NSBezelStyle bezelStyle)
{
  switch (bezelStyle)
  {
  case NSRoundedBezelStyle:          return [NamedNumber namedNumberWithDouble:bezelStyle name:@"NSRoundedBezelStyle"];
  case NSRegularSquareBezelStyle:    return [NamedNumber namedNumberWithDouble:bezelStyle name:@"NSRegularSquareBezelStyle"];  
  case NSThickSquareBezelStyle:      return [NamedNumber namedNumberWithDouble:bezelStyle name:@"NSThickSquareBezelStyle"];
  case NSThickerSquareBezelStyle:    return [NamedNumber namedNumberWithDouble:bezelStyle name:@"NSThickerSquareBezelStyle"];
  case NSDisclosureBezelStyle:       return [NamedNumber namedNumberWithDouble:bezelStyle name:@"NSDisclosureBezelStyle"];  
  case NSShadowlessSquareBezelStyle: return [NamedNumber namedNumberWithDouble:bezelStyle name:@"NSShadowlessSquareBezelStyle"];
  case NSCircularBezelStyle:         return [NamedNumber namedNumberWithDouble:bezelStyle name:@"NSCircularBezelStyle"];
  case NSTexturedSquareBezelStyle:   return [NamedNumber namedNumberWithDouble:bezelStyle name:@"NSTexturedSquareBezelStyle"];
  case NSHelpButtonBezelStyle:       return [NamedNumber namedNumberWithDouble:bezelStyle name:@"NSHelpButtonBezelStyle"];  
  default:                           return [Number numberWithDouble:bezelStyle];
  } 
}

static id objectFromBoxType(NSBoxType boxType)
{
  switch (boxType)
  {
  case NSBoxPrimary:   return [NamedNumber namedNumberWithDouble:boxType name:@"NSBoxPrimary"];
  case NSBoxSecondary: return [NamedNumber namedNumberWithDouble:boxType name:@"NSBoxSecondary"];  
  case NSBoxSeparator: return [NamedNumber namedNumberWithDouble:boxType name:@"NSBoxSeparator"];
  case NSBoxOldStyle:  return [NamedNumber namedNumberWithDouble:boxType name:@"NSBoxOldStyle"];
  default:             return [Number numberWithDouble:boxType];
  } 
}

static id objectFromBrowserColumnResizingType(NSBrowserColumnResizingType browserColumnResizingType)
{
  switch (browserColumnResizingType)
  {
  case NSBrowserNoColumnResizing:   return [NamedNumber namedNumberWithDouble:browserColumnResizingType name:@"NSBrowserNoColumnResizing"];
  case NSBrowserAutoColumnResizing: return [NamedNumber namedNumberWithDouble:browserColumnResizingType name:@"NSBrowserAutoColumnResizing"];  
  case NSBrowserUserColumnResizing: return [NamedNumber namedNumberWithDouble:browserColumnResizingType name:@"NSBrowserUserColumnResizing"];
  default:                          return [Number numberWithDouble:browserColumnResizingType];
  } 
}

/*static id objectFromButtonType(NSButtonType buttonType)
{
  switch (buttonType)
  {
  case NSMomentaryLight:        return [NamedNumber namedNumberWithDouble:buttonType name:@"NSMomentaryLight"];
  case NSMomentaryPushButton:   return [NamedNumber namedNumberWithDouble:buttonType name:@"NSMomentaryPushButton"];  
  case NSMomentaryChangeButton: return [NamedNumber namedNumberWithDouble:buttonType name:@"NSMomentaryChangeButton"];
  case NSPushOnPushOffButton:   return [NamedNumber namedNumberWithDouble:buttonType name:@"NSPushOnPushOffButton"];
  case NSOnOffButton:           return [NamedNumber namedNumberWithDouble:buttonType name:@"NSOnOffButton"];  
  case NSToggleButton:          return [NamedNumber namedNumberWithDouble:buttonType name:@"NSToggleButton"];
  case NSSwitchButton:          return [NamedNumber namedNumberWithDouble:buttonType name:@"NSSwitchButton"];
  case NSRadioButton:           return [NamedNumber namedNumberWithDouble:buttonType name:@"NSRadioButton"];  
  default:                      return [Number numberWithDouble:buttonType];
  } 
}*/

static id objectFromCellEntryType(int cellEntryType)
{
  switch (cellEntryType)
  {
  case NSIntType:            return [NamedNumber namedNumberWithDouble:cellEntryType name:@"NSIntType"];
  case NSPositiveIntType:    return [NamedNumber namedNumberWithDouble:cellEntryType name:@"NSPositiveIntType"];  
  case NSFloatType:          return [NamedNumber namedNumberWithDouble:cellEntryType name:@"NSFloatType"];
  case NSPositiveFloatType:  return [NamedNumber namedNumberWithDouble:cellEntryType name:@"NSPositiveFloatType"];
  case NSDoubleType:         return [NamedNumber namedNumberWithDouble:cellEntryType name:@"NSDoubleType"];  
  case NSPositiveDoubleType: return [NamedNumber namedNumberWithDouble:cellEntryType name:@"NSPositiveDoubleType"];
  case NSAnyType:            return [NamedNumber namedNumberWithDouble:cellEntryType name:@"NSAnyType"];  
  default:                   return [Number numberWithDouble:cellEntryType];
  } 
}

static id objectFromCellImagePosition(int cellImagePosition)
{
  switch (cellImagePosition)
  {
  case NSNoImage:       return [NamedNumber namedNumberWithDouble:cellImagePosition name:@"NSNoImage"];
  case NSImageOnly:     return [NamedNumber namedNumberWithDouble:cellImagePosition name:@"NSImageOnly"];  
  case NSImageLeft:     return [NamedNumber namedNumberWithDouble:cellImagePosition name:@"NSImageLeft"];
  case NSImageRight:    return [NamedNumber namedNumberWithDouble:cellImagePosition name:@"NSImageRight"];
  case NSImageBelow:    return [NamedNumber namedNumberWithDouble:cellImagePosition name:@"NSImageBelow"];  
  case NSImageAbove:    return [NamedNumber namedNumberWithDouble:cellImagePosition name:@"NSImageAbove"];
  case NSImageOverlaps: return [NamedNumber namedNumberWithDouble:cellImagePosition name:@"NSImageOverlaps"];  
  default:              return [Number numberWithDouble:cellImagePosition];
  } 
}

static id objectFromCellMask(unsigned int mask)
{
  if (mask & ~(NSContentsCellMask | NSPushInCellMask | NSPushInCellMask | NSChangeGrayCellMask | NSChangeBackgroundCellMask)) return [Number numberWithDouble:mask];
  else if (mask == 0) return [NamedNumber namedNumberWithDouble:mask name:@"NSNoCellMask"];
  else
  {
    NSMutableString *str = [NSMutableString string];
    if (mask & NSContentsCellMask)         [str appendString:@"NSContentsCellMask"];
    if (mask & NSPushInCellMask)           [str appendString:[str length] == 0 ? @"NSPushInCellMask"           : @" + NSPushInCellMask"];
    if (mask & NSChangeGrayCellMask)       [str appendString:[str length] == 0 ? @"NSChangeGrayCellMask"       : @" + NSChangeGrayCellMask"];  
    if (mask & NSChangeBackgroundCellMask) [str appendString:[str length] == 0 ? @"NSChangeBackgroundCellMask" : @" + NSChangeBackgroundCellMask"];      
    return [NamedNumber namedNumberWithDouble:mask name:str];
  }   
}

static id objectFromCellStateValue(NSCellStateValue cellStateValue)
{
  switch (cellStateValue)
  {
  case NSMixedState: return [NamedNumber namedNumberWithDouble:cellStateValue name:@"NSMixedState"];
  case NSOffState:   return [NamedNumber namedNumberWithDouble:cellStateValue name:@"NSOffState"];  
  case NSOnState:    return [NamedNumber namedNumberWithDouble:cellStateValue name:@"NSOnState"];
  default:           return [Number numberWithDouble:cellStateValue];
  } 
}

static id objectFromCellType(NSCellType cellType)
{
  switch (cellType)
  {
  case NSNullCellType:  return [NamedNumber namedNumberWithDouble:cellType name:@"NSNullCellType"];
  case NSTextCellType:  return [NamedNumber namedNumberWithDouble:cellType name:@"NSTextCellType"];  
  case NSImageCellType: return [NamedNumber namedNumberWithDouble:cellType name:@"NSImageCellType"];
  default:              return [Number numberWithDouble:cellType];
  } 
}

static id objectFromControlSize(NSControlSize controlSize)
{
  switch (controlSize)
  {
  case NSRegularControlSize: return [NamedNumber namedNumberWithDouble:controlSize name:@"NSRegularControlSize"];
  case NSSmallControlSize:   return [NamedNumber namedNumberWithDouble:controlSize name:@"NSSmallControlSize"];  
  case NSMiniControlSize:    return [NamedNumber namedNumberWithDouble:controlSize name:@"NSMiniControlSize"];
  default:                   return [Number numberWithDouble:controlSize];
  } 
}

static id objectFromControlTint(NSControlTint controlTint)
{
  switch (controlTint)
  {
  case NSDefaultControlTint:  return [NamedNumber namedNumberWithDouble:controlTint name:@"NSDefaultControlTint"];
  case NSBlueControlTint:     return [NamedNumber namedNumberWithDouble:controlTint name:@"NSBlueControlTint"];  
  case NSGraphiteControlTint: return [NamedNumber namedNumberWithDouble:controlTint name:@"NSGraphiteControlTint"];
  case NSClearControlTint:    return [NamedNumber namedNumberWithDouble:controlTint name:@"NSClearControlTint"];
  default:                    return [Number numberWithDouble:controlTint];
  } 
}

static id objectFromDrawerState(NSDrawerState drawerState)
{
  switch (drawerState)
  {
  case NSDrawerClosedState:  return [NamedNumber namedNumberWithDouble:drawerState name:@"NSDrawerClosedState"];
  case NSDrawerOpeningState: return [NamedNumber namedNumberWithDouble:drawerState name:@"NSDrawerOpeningState"];  
  case NSDrawerOpenState:    return [NamedNumber namedNumberWithDouble:drawerState name:@"NSDrawerOpenState"];
  case NSDrawerClosingState: return [NamedNumber namedNumberWithDouble:drawerState name:@"NSDrawerClosingState"];
  default:                   return [Number numberWithDouble:drawerState];
  } 
}

static id objectFromEventType(NSEventType eventType)
{
  switch (eventType)
  {
  case NSLeftMouseDown:      return [NamedNumber namedNumberWithDouble:eventType name:@"NSLeftMouseDown"];
  case NSLeftMouseUp:        return [NamedNumber namedNumberWithDouble:eventType name:@"NSLeftMouseUp"];  
  case NSRightMouseDown:     return [NamedNumber namedNumberWithDouble:eventType name:@"NSRightMouseDown"];
  case NSRightMouseUp:       return [NamedNumber namedNumberWithDouble:eventType name:@"NSRightMouseUp"];
  case NSOtherMouseDown:     return [NamedNumber namedNumberWithDouble:eventType name:@"NSOtherMouseDown"];
  case NSOtherMouseUp:       return [NamedNumber namedNumberWithDouble:eventType name:@"NSOtherMouseUp"];  
  case NSMouseMoved:         return [NamedNumber namedNumberWithDouble:eventType name:@"NSMouseMoved"];
  case NSLeftMouseDragged:   return [NamedNumber namedNumberWithDouble:eventType name:@"NSLeftMouseDragged"];
  case NSRightMouseDragged:  return [NamedNumber namedNumberWithDouble:eventType name:@"NSRightMouseDragged"];
  case NSOtherMouseDragged:  return [NamedNumber namedNumberWithDouble:eventType name:@"NSOtherMouseDragged"];  
  case NSMouseEntered:       return [NamedNumber namedNumberWithDouble:eventType name:@"NSMouseEntered"];
  case NSMouseExited:        return [NamedNumber namedNumberWithDouble:eventType name:@"NSMouseExited"];
  case NSCursorUpdate:       return [NamedNumber namedNumberWithDouble:eventType name:@"NSCursorUpdate"];
  case NSKeyDown:            return [NamedNumber namedNumberWithDouble:eventType name:@"NSKeyDown"];  
  case NSKeyUp:              return [NamedNumber namedNumberWithDouble:eventType name:@"NSKeyUp"];
  case NSFlagsChanged:       return [NamedNumber namedNumberWithDouble:eventType name:@"NSFlagsChanged"];
  case NSAppKitDefined:      return [NamedNumber namedNumberWithDouble:eventType name:@"NSAppKitDefined"];
  case NSSystemDefined:      return [NamedNumber namedNumberWithDouble:eventType name:@"NSSystemDefined"];  
  case NSApplicationDefined: return [NamedNumber namedNumberWithDouble:eventType name:@"NSApplicationDefined"];
  case NSPeriodic:           return [NamedNumber namedNumberWithDouble:eventType name:@"NSPeriodic"];
  case NSScrollWheel:        return [NamedNumber namedNumberWithDouble:eventType name:@"NSScrollWheel"];
  default:                   return [Number numberWithDouble:eventType];
  } 
}

static id objectFromFocusRingType(NSFocusRingType focusRingType)
{
  switch (focusRingType)
  {
  case NSFocusRingTypeDefault:  return [NamedNumber namedNumberWithDouble:focusRingType name:@"NSFocusRingTypeDefault"];
  case NSFocusRingTypeNone:     return [NamedNumber namedNumberWithDouble:focusRingType name:@"NSFocusRingTypeNone"];  
  case NSFocusRingTypeExterior: return [NamedNumber namedNumberWithDouble:focusRingType name:@"NSFocusRingTypeExterior"];
  default:                      return [Number numberWithDouble:focusRingType];
  } 
}

static id objectFromGradientType(NSGradientType gradientType)
{
  switch (gradientType)
  {
  case NSGradientNone:          return [NamedNumber namedNumberWithDouble:gradientType name:@"NSGradientNone"];
  case NSGradientConcaveWeak:   return [NamedNumber namedNumberWithDouble:gradientType name:@"NSGradientConcaveWeak"];  
  case NSGradientConcaveStrong: return [NamedNumber namedNumberWithDouble:gradientType name:@"NSGradientConcaveStrong"];
  case NSGradientConvexWeak:    return [NamedNumber namedNumberWithDouble:gradientType name:@"NSGradientConvexWeak"];
  case NSGradientConvexStrong:  return [NamedNumber namedNumberWithDouble:gradientType name:@"NSGradientConvexStrong"];  
  default:                      return [Number numberWithDouble:gradientType];
  } 
}

static id objectFromGridStyleMask(unsigned int mask)
{
  if (mask & ~(NSTableViewSolidVerticalGridLineMask | NSTableViewSolidHorizontalGridLineMask)) return [Number numberWithDouble:mask];
  else if (mask == 0) return [NamedNumber namedNumberWithDouble:mask name:@"NSTableViewGridNone"];
  else
  {
    NSMutableString *str = [NSMutableString string];
    if (mask & NSTableViewSolidVerticalGridLineMask)    [str appendString:@"NSTableViewSolidVerticalGridLineMask"];
    if (mask & NSTableViewSolidHorizontalGridLineMask)  [str appendString:[str length] == 0 ? @"NSTableViewSolidHorizontalGridLineMask"  : @" + NSTableViewSolidHorizontalGridLineMask"];  
    return [NamedNumber namedNumberWithDouble:mask name:str];
  }   
}

static id objectFromImageAlignment(NSImageAlignment imageAlignment)
{
  switch (imageAlignment)
  {
  case NSImageAlignCenter:      return [NamedNumber namedNumberWithDouble:imageAlignment name:@"NSImageAlignCenter"];
  case NSImageAlignTop:         return [NamedNumber namedNumberWithDouble:imageAlignment name:@"NSImageAlignTop"];  
  case NSImageAlignTopLeft:     return [NamedNumber namedNumberWithDouble:imageAlignment name:@"NSImageAlignTopLeft"];
  case NSImageAlignTopRight:    return [NamedNumber namedNumberWithDouble:imageAlignment name:@"NSImageAlignTopRight"];
  case NSImageAlignLeft:        return [NamedNumber namedNumberWithDouble:imageAlignment name:@"NSImageAlignLeft"];  
  case NSImageAlignBottom:      return [NamedNumber namedNumberWithDouble:imageAlignment name:@"NSImageAlignBottom"];
  case NSImageAlignBottomLeft:  return [NamedNumber namedNumberWithDouble:imageAlignment name:@"NSImageAlignBottomLeft"];  
  case NSImageAlignBottomRight: return [NamedNumber namedNumberWithDouble:imageAlignment name:@"NSImageAlignBottomRight"];
  case NSImageAlignRight:       return [NamedNumber namedNumberWithDouble:imageAlignment name:@"NSImageAlignRight"];
  default:                      return [Number numberWithDouble:imageAlignment];
  } 
}

static id objectFromImageFrameStyle(NSImageFrameStyle imageFrameStyle)
{
  switch (imageFrameStyle)
  {
  case NSImageFrameNone:      return [NamedNumber namedNumberWithDouble:imageFrameStyle name:@"NSImageFrameNone"];
  case NSImageFramePhoto:     return [NamedNumber namedNumberWithDouble:imageFrameStyle name:@"NSImageFramePhoto"];  
  case NSImageFrameGrayBezel: return [NamedNumber namedNumberWithDouble:imageFrameStyle name:@"NSImageFrameGrayBezel"];
  case NSImageFrameGroove:    return [NamedNumber namedNumberWithDouble:imageFrameStyle name:@"NSImageFrameGroove"];
  case NSImageFrameButton:    return [NamedNumber namedNumberWithDouble:imageFrameStyle name:@"NSImageFrameButton"];  
  default:                    return [Number numberWithDouble:imageFrameStyle];
  } 
}

static id objectFromImageScaling(NSImageScaling imageScaling)
{
  switch (imageScaling)
  {
  case NSScaleProportionally: return [NamedNumber namedNumberWithDouble:imageScaling name:@"NSScaleProportionally"];
  case NSScaleToFit:          return [NamedNumber namedNumberWithDouble:imageScaling name:@"NSScaleToFit"];  
  case NSScaleNone:           return [NamedNumber namedNumberWithDouble:imageScaling name:@"NSScaleNone"];
  default:                    return [Number numberWithDouble:imageScaling];
  } 
}

static id objectFromKeyModifierMask(unsigned int mask)
{
  unsigned int newMask = mask & ~(unsigned int)32767; // We are not interested in the lower 16 bits of the modifier flags, which are reserved for device-dependent bits. 
  
  if (newMask & ~(NSAlphaShiftKeyMask | NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask | NSNumericPadKeyMask | NSHelpKeyMask | NSFunctionKeyMask))
    return [Number numberWithDouble:mask];
    
  NSMutableString *str = [NSMutableString string];
   
  if (newMask & NSAlphaShiftKeyMask)    [str appendString:@"NSAlphaShiftKeyMask"];
  if (newMask & NSShiftKeyMask)         [str appendString:[str length] == 0 ? @"NSShiftKeyMask"      : @" + NSShiftKeyMask"];
  if (newMask & NSControlKeyMask)       [str appendString:[str length] == 0 ? @"NSControlKeyMask"    : @" + NSControlKeyMask"];
  if (newMask & NSAlternateKeyMask)     [str appendString:[str length] == 0 ? @"NSAlternateKeyMask"  : @" + NSAlternateKeyMask"];
  if (newMask & NSCommandKeyMask)       [str appendString:[str length] == 0 ? @"NSCommandKeyMask"    : @" + NSCommandKeyMask"];
  if (newMask & NSNumericPadKeyMask)    [str appendString:[str length] == 0 ? @"NSNumericPadKeyMask" : @" + NSNumericPadKeyMask"];
  if (newMask & NSHelpKeyMask)          [str appendString:[str length] == 0 ? @"NSHelpKeyMask"       : @" + NSHelpKeyMask"];
  if (newMask & NSFunctionKeyMask)      [str appendString:[str length] == 0 ? @"NSFunctionKeyMask"   : @" + NSFunctionKeyMask"];
  
  return ([str length] == 0 ? [Number numberWithDouble:mask] : [NamedNumber namedNumberWithDouble:mask name:str]);
}

static id objectFromMatrixMode(NSMatrixMode matrixMode)
{
  switch (matrixMode)
  {
  case NSRadioModeMatrix:     return [NamedNumber namedNumberWithDouble:matrixMode name:@"NSRadioModeMatrix"];
  case NSHighlightModeMatrix: return [NamedNumber namedNumberWithDouble:matrixMode name:@"NSHighlightModeMatrix"];  
  case NSListModeMatrix:      return [NamedNumber namedNumberWithDouble:matrixMode name:@"NSListModeMatrix"];
  case NSTrackModeMatrix :    return [NamedNumber namedNumberWithDouble:matrixMode name:@"NSTrackModeMatrix"];
  default:                    return [Number numberWithDouble:matrixMode];
  } 
}

static id objectFromPopUpArrowPosition(NSPopUpArrowPosition popUpArrowPosition)
{
  switch (popUpArrowPosition)
  {
  case NSPopUpNoArrow:       return [NamedNumber namedNumberWithDouble:popUpArrowPosition name:@"NSPopUpNoArrow"];
  case NSPopUpArrowAtCenter: return [NamedNumber namedNumberWithDouble:popUpArrowPosition name:@"NSPopUpArrowAtCenter"];  
  case NSPopUpArrowAtBottom: return [NamedNumber namedNumberWithDouble:popUpArrowPosition name:@"NSPopUpArrowAtBottom"];
  default:                   return [Number numberWithDouble:popUpArrowPosition];
  } 
}

static id objectFromQTMovieLoopMode(NSQTMovieLoopMode loopMode)
{
  switch (loopMode)
  {
  case NSQTMovieNormalPlayback:              return [NamedNumber namedNumberWithDouble:loopMode name:@"NSQTMovieNormalPlayback"];
  case NSQTMovieLoopingPlayback:             return [NamedNumber namedNumberWithDouble:loopMode name:@"NSQTMovieLoopingPlayback"];  
  case NSQTMovieLoopingBackAndForthPlayback: return [NamedNumber namedNumberWithDouble:loopMode name:@"NSQTMovieLoopingBackAndForthPlayback"];
  default:                                   return [Number numberWithDouble:loopMode];
  } 
}

static id objectFromRectEdge(NSRectEdge rectEdge)
{
  switch (rectEdge)
  {
  case NSMinXEdge: return [NamedNumber namedNumberWithDouble:rectEdge name:@"NSMinXEdge"];
  case NSMinYEdge: return [NamedNumber namedNumberWithDouble:rectEdge name:@"NSMinYEdge"];  
  case NSMaxXEdge: return [NamedNumber namedNumberWithDouble:rectEdge name:@"NSMaxXEdge"];
  case NSMaxYEdge: return [NamedNumber namedNumberWithDouble:rectEdge name:@"NSMaxYEdge"];
  default:         return [Number numberWithDouble:rectEdge];
  } 
}

static id objectFromScrollArrowPosition(NSScrollArrowPosition scrollArrowPosition)
{
  switch (scrollArrowPosition)
  {
  case NSScrollerArrowsDefaultSetting: return [NamedNumber namedNumberWithDouble:scrollArrowPosition name:@"NSScrollerArrowsDefaultSetting"];
  case NSScrollerArrowsNone:           return [NamedNumber namedNumberWithDouble:scrollArrowPosition name:@"NSScrollerArrowsNone"];  
  default:                             return [Number numberWithDouble:scrollArrowPosition];
  } 
}

static id objectFromScrollerPart(NSScrollerPart scrollerPart)
{
  switch (scrollerPart) 
  {
  case NSScrollerNoPart:        return [NamedNumber namedNumberWithDouble:scrollerPart name:@"NSScrollerNoPart"];       
  case NSScrollerDecrementPage: return [NamedNumber namedNumberWithDouble:scrollerPart name:@"NSScrollerDecrementPage"];      
  case NSScrollerKnob:          return [NamedNumber namedNumberWithDouble:scrollerPart name:@"NSScrollerKnob"];     
  case NSScrollerIncrementPage: return [NamedNumber namedNumberWithDouble:scrollerPart name:@"NSScrollerIncrementPage"];  
  case NSScrollerDecrementLine: return [NamedNumber namedNumberWithDouble:scrollerPart name:@"NSScrollerDecrementLine"];
  case NSScrollerIncrementLine: return [NamedNumber namedNumberWithDouble:scrollerPart name:@"NSScrollerIncrementLine"];  
  case NSScrollerKnobSlot:      return [NamedNumber namedNumberWithDouble:scrollerPart name:@"NSScrollerKnobSlot"];
  default:                      return [Number numberWithDouble:scrollerPart];
  }
}

static id objectFromSegmentSwitchTracking(NSSegmentSwitchTracking segmentSwitchTracking)
{
  switch (segmentSwitchTracking) 
  {
    case NSSegmentSwitchTrackingSelectOne: return [NamedNumber namedNumberWithDouble:segmentSwitchTracking name:@"NSSegmentSwitchTrackingSelectOne"];       
    case NSSegmentSwitchTrackingSelectAny: return [NamedNumber namedNumberWithDouble:segmentSwitchTracking name:@"NSSegmentSwitchTrackingSelectAny"];      
    case NSSegmentSwitchTrackingMomentary: return [NamedNumber namedNumberWithDouble:segmentSwitchTracking name:@"NSSegmentSwitchTrackingMomentary"];     
    default:                               return [Number numberWithDouble:segmentSwitchTracking];
  }
}

static id objectFromSelectionAffinity(NSSelectionAffinity selectionAffinity)
{
  switch (selectionAffinity) 
  {
    case NSSelectionAffinityUpstream:   return [NamedNumber namedNumberWithDouble:selectionAffinity name:@"NSSelectionAffinityUpstream"];       
    case NSSelectionAffinityDownstream: return [NamedNumber namedNumberWithDouble:selectionAffinity name:@"NSSelectionAffinityDownstream"];      
    default:                            return [Number numberWithDouble:selectionAffinity];
  }
}

static id objectFromSelectionGranularity(NSSelectionGranularity selectionGranularity)
{
  switch (selectionGranularity) 
  {
    case NSSelectByCharacter: return [NamedNumber namedNumberWithDouble:selectionGranularity name:@"NSSelectByCharacter"];       
    case NSSelectByWord:      return [NamedNumber namedNumberWithDouble:selectionGranularity name:@"NSSelectByWord"];      
    case NSSelectByParagraph: return [NamedNumber namedNumberWithDouble:selectionGranularity name:@"NSSelectByParagraph"];     
    default:                  return [Number numberWithDouble:selectionGranularity];
  }
}

static id objectFromSelectionDirection(NSSelectionDirection selectionDirection)
{
  switch (selectionDirection) 
  {
    case NSDirectSelection:   return [NamedNumber namedNumberWithDouble:selectionDirection name:@"NSDirectSelection"];       
    case NSSelectingNext:     return [NamedNumber namedNumberWithDouble:selectionDirection name:@"NSSelectingNext"];      
    case NSSelectingPrevious: return [NamedNumber namedNumberWithDouble:selectionDirection name:@"NSSelectingPrevious"];     
    default:                  return [Number numberWithDouble:selectionDirection];
  }
}

static id objectFromSliderType(NSSliderType sliderType)
{
  switch (sliderType) 
  {
    case NSLinearSlider:   return [NamedNumber namedNumberWithDouble:sliderType name:@"NSLinearSlider"];       
    case NSCircularSlider: return [NamedNumber namedNumberWithDouble:sliderType name:@"NSCircularSlider"];      
    default:               return [Number numberWithDouble:sliderType];
  }
}

static id objectFromTabState(NSTabState tabState)
{
  switch (tabState) 
  {
    case NSBackgroundTab: return [NamedNumber namedNumberWithDouble:tabState name:@"NSBackgroundTab"];       
    case NSPressedTab:    return [NamedNumber namedNumberWithDouble:tabState name:@"NSPressedTab"];      
    case NSSelectedTab:   return [NamedNumber namedNumberWithDouble:tabState name:@"NSSelectedTab"];     
    default:              return [Number numberWithDouble:tabState];
  }
}

static id objectFromTabViewType(NSTabViewType tabViewType)
{
  switch (tabViewType) 
  {
  case NSTopTabsBezelBorder:    return [NamedNumber namedNumberWithDouble:tabViewType name:@"NSTopTabsBezelBorder"];       
  case NSLeftTabsBezelBorder:   return [NamedNumber namedNumberWithDouble:tabViewType name:@"NSLeftTabsBezelBorder"];      
  case NSBottomTabsBezelBorder: return [NamedNumber namedNumberWithDouble:tabViewType name:@"NSBottomTabsBezelBorder"];     
  case NSRightTabsBezelBorder:  return [NamedNumber namedNumberWithDouble:tabViewType name:@"NSRightTabsBezelBorder"];  
  case NSNoTabsBezelBorder:     return [NamedNumber namedNumberWithDouble:tabViewType name:@"NSNoTabsBezelBorder"];
  case NSNoTabsLineBorder:      return [NamedNumber namedNumberWithDouble:tabViewType name:@"NSNoTabsLineBorder"];  
  case NSNoTabsNoBorder:        return [NamedNumber namedNumberWithDouble:tabViewType name:@"NSNoTabsNoBorder"];
  default:                      return [Number numberWithDouble:tabViewType];
  }
}

static id objectFromTextAlignment(NSTextAlignment alignment)
{
  switch (alignment) 
  {
  case NSLeftTextAlignment:      return [NamedNumber namedNumberWithDouble:alignment name:@"NSLeftTextAlignment"];       
  case NSRightTextAlignment:     return [NamedNumber namedNumberWithDouble:alignment name:@"NSRightTextAlignment"];      
  case NSCenterTextAlignment:    return [NamedNumber namedNumberWithDouble:alignment name:@"NSCenterTextAlignment"];     
  case NSJustifiedTextAlignment: return [NamedNumber namedNumberWithDouble:alignment name:@"NSJustifiedTextAlignment"];  
  case NSNaturalTextAlignment:   return [NamedNumber namedNumberWithDouble:alignment name:@"NSNaturalTextAlignment"];
  default:                       return [Number numberWithDouble:alignment];
  }
}

static id objectFromTextFieldBezelStyle(NSTextFieldBezelStyle textFielBezelStyle)
{
  switch (textFielBezelStyle)
  {
  case NSTextFieldSquareBezel:  return [NamedNumber namedNumberWithDouble:textFielBezelStyle name:@"NSTextFieldSquareBezel"];
  case NSTextFieldRoundedBezel: return [NamedNumber namedNumberWithDouble:textFielBezelStyle name:@"NSTextFieldRoundedBezel"];  
  default:                      return [Number numberWithDouble:textFielBezelStyle];
  } 
}

static id objectFromTickMarkPosition(NSTickMarkPosition tickMarkPosition, BOOL isVertical)
{
  switch (tickMarkPosition) 
  {
  case NSTickMarkBelow: return [NamedNumber namedNumberWithDouble:tickMarkPosition name: isVertical ? @"NSTickMarkRight" : @"NSTickMarkBelow"];       
  case NSTickMarkAbove: return [NamedNumber namedNumberWithDouble:tickMarkPosition name: isVertical ? @"NSTickMarkLeft"  : @"NSTickMarkAbove"];      
  //case NSTickMarkLeft:  return [NamedNumber namedNumberWithDouble:tickMarkPosition name:@"NSTickMarkLeft"];     
  //case NSTickMarkRight: return [NamedNumber namedNumberWithDouble:tickMarkPosition name:@"NSTickMarkRight"];  
  default:              return [Number numberWithDouble:tickMarkPosition];
  }
}

static id objectFromTitlePosition(NSTitlePosition titlePosition)
{
  switch (titlePosition) 
  {
  case NSNoTitle:     return [NamedNumber namedNumberWithDouble:titlePosition name:@"NSNoTitle"];       
  case NSAboveTop:    return [NamedNumber namedNumberWithDouble:titlePosition name:@"NSAboveTop"];      
  case NSAtTop:       return [NamedNumber namedNumberWithDouble:titlePosition name:@"NSAtTop"];     
  case NSBelowTop:    return [NamedNumber namedNumberWithDouble:titlePosition name:@"NSBelowTop"];  
  case NSAboveBottom: return [NamedNumber namedNumberWithDouble:titlePosition name:@"NSAboveBottom"];
  case NSAtBottom:    return [NamedNumber namedNumberWithDouble:titlePosition name:@"NSAtBottom"];  
  case NSBelowBottom: return [NamedNumber namedNumberWithDouble:titlePosition name:@"NSBelowBottom"];
  default:            return [Number numberWithDouble:titlePosition];
  }
}

static id objectFromToolbarDisplayMode(NSToolbarDisplayMode toolbarDisplayMode)
{
  switch (toolbarDisplayMode) 
  {
  case NSToolbarDisplayModeDefault:      return [NamedNumber namedNumberWithDouble:toolbarDisplayMode name:@"NSToolbarDisplayModeDefault"];       
  case NSToolbarDisplayModeIconAndLabel: return [NamedNumber namedNumberWithDouble:toolbarDisplayMode name:@"NSToolbarDisplayModeIconAndLabel"];      
  case NSToolbarDisplayModeIconOnly:     return [NamedNumber namedNumberWithDouble:toolbarDisplayMode name:@"NSToolbarDisplayModeIconOnly"];     
  case NSToolbarDisplayModeLabelOnly:    return [NamedNumber namedNumberWithDouble:toolbarDisplayMode name:@"NSToolbarDisplayModeLabelOnly"];  
  default:                               return [Number numberWithDouble:toolbarDisplayMode];
  }
}

static id objectFromToolbarSizeMode(NSToolbarSizeMode toolbarSizeMode)
{
  switch (toolbarSizeMode) 
  {
  case NSToolbarSizeModeDefault:      return [NamedNumber namedNumberWithDouble:toolbarSizeMode name:@"NSToolbarSizeModeDefault"];       
  case NSToolbarSizeModeRegular:      return [NamedNumber namedNumberWithDouble:toolbarSizeMode name:@"NSToolbarSizeModeRegular"];      
  case NSToolbarSizeModeSmall:        return [NamedNumber namedNumberWithDouble:toolbarSizeMode name:@"NSToolbarSizeModeSmall"];     
  default:                            return [Number numberWithDouble:toolbarSizeMode];
  }
}

static id objectFromUsableScrollerParts(NSUsableScrollerParts usableScrollerParts)
{
  switch (usableScrollerParts) 
  {
  case NSNoScrollerParts:    return [NamedNumber namedNumberWithDouble:usableScrollerParts name:@"NSNoScrollerParts"];       
  case NSOnlyScrollerArrows: return [NamedNumber namedNumberWithDouble:usableScrollerParts name:@"NSOnlyScrollerArrows"];      
  case NSAllScrollerParts:   return [NamedNumber namedNumberWithDouble:usableScrollerParts name:@"NSAllScrollerParts"];     
  default:                   return [Number numberWithDouble:usableScrollerParts];
  }
}

static id objectFromWindowLevel(int windowLevel)
{
  if      (windowLevel == NSNormalWindowLevel)       return [NamedNumber namedNumberWithDouble:windowLevel name:@"NSNormalWindowLevel"];       
  else if (windowLevel == NSFloatingWindowLevel)     return [NamedNumber namedNumberWithDouble:windowLevel name:@"NSFloatingWindowLevel"];      
  else if (windowLevel ==  NSSubmenuWindowLevel)     return [NamedNumber namedNumberWithDouble:windowLevel name:@"NSSubmenuWindowLevel"];     
  else if (windowLevel ==  NSTornOffMenuWindowLevel) return [NamedNumber namedNumberWithDouble:windowLevel name:@"NSTornOffMenuWindowLevel"];  
  else if (windowLevel ==  NSModalPanelWindowLevel)  return [NamedNumber namedNumberWithDouble:windowLevel name:@"NSModalPanelWindowLevel"];
  else if (windowLevel ==  NSMainMenuWindowLevel)    return [NamedNumber namedNumberWithDouble:windowLevel name:@"NSMainMenuWindowLevel"];       
  else if (windowLevel ==  NSStatusWindowLevel)      return [NamedNumber namedNumberWithDouble:windowLevel name:@"NSStatusWindowLevel"];      
  else if (windowLevel ==  NSPopUpMenuWindowLevel)   return [NamedNumber namedNumberWithDouble:windowLevel name:@"NSPopUpMenuWindowLevel"];     
  else if (windowLevel ==  NSScreenSaverWindowLevel) return [NamedNumber namedNumberWithDouble:windowLevel name:@"NSScreenSaverWindowLevel"];        
  else                                               return [Number numberWithDouble:windowLevel];
}

static id objectFromWindowMask(unsigned int mask)
{
  if (mask & ~(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask | NSTexturedBackgroundWindowMask)) return [Number numberWithDouble:mask];
  else if (mask == 0) return [NamedNumber namedNumberWithDouble:mask name:@"NSBorderlessWindowMask"]; 
  else
  {  
    NSMutableString *str = [NSMutableString string];
  
    if (mask & NSTitledWindowMask)             [str appendString:@"NSTitledWindowMask"];
    if (mask & NSClosableWindowMask)           [str appendString:[str length] == 0 ? @"NSClosableWindowMask"           : @" + NSClosableWindowMask"];
    if (mask & NSMiniaturizableWindowMask)     [str appendString:[str length] == 0 ? @"NSMiniaturizableWindowMask"     : @" + NSMiniaturizableWindowMask"];
    if (mask & NSResizableWindowMask)          [str appendString:[str length] == 0 ? @"NSResizableWindowMask"          : @" + NSResizableWindowMask"];
    if (mask & NSTexturedBackgroundWindowMask) [str appendString:[str length] == 0 ? @"NSTexturedBackgroundWindowMask" : @" + NSTexturedBackgroundWindowMask"];
  
    return [NamedNumber namedNumberWithDouble:mask name:str];
  }  
}

/*static id objectFromWindowOrderingMode(NSWindowOrderingMode orderingMode)
{
  switch (orderingMode) 
  {
    case NSWindowAbove: return [NamedNumber namedNumberWithDouble:orderingMode name:@"NSWindowAbove"];       
    case NSWindowBelow: return [NamedNumber namedNumberWithDouble:orderingMode name:@"NSWindowBelow"];      
    case NSWindowOut:   return [NamedNumber namedNumberWithDouble:orderingMode name:@"NSWindowOut"];     
    default:            return [Number numberWithDouble:orderingMode];
  }
}*/


static NSString *humanReadableFScriptTypeDescriptionFromEncodedObjCType(const char *ptr)
{
  while (*ptr == 'r' || *ptr == 'n' || *ptr == 'N' || *ptr == 'o' || *ptr == 'O' || *ptr == 'R' || *ptr == 'V')
    ptr++;

  if      (strcmp(ptr,@encode(id))                  == 0) return @"";
  else if (strcmp(ptr,@encode(char))                == 0) return @"";
  else if (strcmp(ptr,@encode(int))                 == 0) return @"int";
  else if (strcmp(ptr,@encode(short))               == 0) return @"short";
  else if (strcmp(ptr,@encode(long))                == 0) return @"long";
  else if (strcmp(ptr,@encode(long long))           == 0) return @"long long";
  else if (strcmp(ptr,@encode(unsigned char))       == 0) return @"unsigned char";
  else if (strcmp(ptr,@encode(unsigned short))      == 0) return @"unsigned short";
  else if (strcmp(ptr,@encode(unsigned int))        == 0) return @"unsigned int";
  else if (strcmp(ptr,@encode(unsigned long))       == 0) return @"unsigned long";
  else if (strcmp(ptr,@encode(unsigned long long))  == 0) return @"unsigned long long";
  else if (strcmp(ptr,@encode(float))               == 0) return @"float";
  else if (strcmp(ptr,@encode(double))              == 0) return @"double";
  else if (strcmp(ptr,@encode(char *))              == 0) return [[NSUserDefaults standardUserDefaults] boolForKey:@"mapCharPointerToNSString"] ? @"char *" : @"pointer";
  else if (strcmp(ptr,@encode(SEL))                 == 0) return @"SEL";
  else if (strcmp(ptr,@encode(Class))               == 0) return @"Class";
  else if (*ptr == '^')                                   return @"pointer";
  else if (strcmp(ptr,@encode(NSRange))             == 0) return @"NSRange";
  else if (strcmp(ptr,@encode(NSPoint))             == 0) return @"NSPoint";
  else if (strcmp(ptr,@encode(NSSize))              == 0) return @"NSSize";
  else if (strcmp(ptr,@encode(NSRect))              == 0) return @"NSRect";
  else if (strcmp(ptr,@encode(_Bool))               == 0) return @"_Bool";
  else                                                    return @"";  
}

static NSMutableArray *customButtons = nil; 

@interface BigBrowserView(BigBrowserViewPrivateInternal)  // Methods declaration to let the compiler know

- (void) disable;
- (void) fillMatrixForWorkspaceBrowsing:(NSMatrix*)matrix;
- (void) fillMatrix:(NSMatrix *)matrix withMethodsForObject:(id)object;
- (void) fillMatrix:(NSMatrix *)m withObject:(id)o;
- (void) filter;
- (void) inspectObjectAction:(id)sender;
- (id)   selectedObject;
- (void) selectMethodNamed:(NSString *)methodName;
- (void) selfAction:(id)sender;
- (void) sendMessage:(SEL)selector withArguments:(Array *)arguments;
- (BOOL) sendMessageTo:(id)receiver selectorString:(NSString *)selectorStr arguments:(Array *)arguments putResultInMatrix:(NSMatrix *)matrix;
- (void) setMethodFilterString:(NSString *)theMethodFilterString;
- (void) setTitleOfLastColumn:(NSString *)title;
- (void) stopNameSheet:(id)sender;
- (id)   validSelectedObject;

@end


@implementation BigBrowserView

+ (NSArray *)customButtons 
{
  return customButtons;
}

+(void) initialize 
{
  static BOOL tooLate = NO;
  if ( !tooLate ) 
  {  
    int i;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *registrationDict = [NSMutableDictionary dictionary];
    
    [registrationDict setObject:[NSNumber numberWithInt:[[NSFont userFixedPitchFontOfSize:-1] pointSize]] forKey:@"FScriptFontSize"];
    [defaults registerDefaults:registrationDict];
    
    if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_2) 
    {
      // 10.3 or later system
      // NSLog(@"Loading PantherAndLaterOnly.bundle");
      [[NSBundle bundleWithPath:[[NSBundle bundleForClass:self] pathForResource:@"PantherAndLaterOnly" ofType:@"bundle"]] load];
    }  
        
    customButtons = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (i = 1; i < 11; i++)
    {
      BigBrowserToolbarButton *button = [[BigBrowserToolbarButton alloc] initWithFrame:NSMakeRect(0,0,93,30)];
      NSString *buttonName  = [defaults stringForKey:[NSString stringWithFormat:@"BigBrowserToolbarButtonCustom%dName",i]];
      NSData *blockData = [defaults objectForKey:[NSString stringWithFormat:@"BigBrowserToolbarButtonCustom%dBlock",i]];
      Block *block = nil;
       
      if (blockData)
      { 
        NS_DURING
          block = [[NSKeyedUnarchiver unarchiveObjectWithData:blockData] retain];
        NS_HANDLER
          NSLog([NSString stringWithFormat:@"Problem while loading a block for an F-Script object browser custom button: %@ %@", [localException name], [localException reason]]);
          block = nil; // We will fall back to the default block template
        NS_ENDHANDLER
      }
      
      if (!buttonName)  buttonName  = [NSString stringWithFormat:@"Custom%d", i];
      
      if (!block) 
      {
        NSString *blockSource;
        
        if (i == 1)
        {
          buttonName = @"Example1";
          blockSource = @"[:selectedObject|\n\n\"This block is an example illustrating the use of custom buttons in the object browser. This block prompts the user to save the selected object, and then returns a custom string.\"\n\nselectedObject save.\n'hello, I''m the result of the Example1 block !'\n]";
        }
        else if (i == 2)
        {
          buttonName = @"Example2";
          blockSource = @"#isEqual:";
        }
        else if (i == 3)
        {
          buttonName = @"Example3";
          blockSource = @"[\n\"This block is an example illustrating the use of custom buttons in the object browser. This block will simply open a standard about box.\"\n\nNSApplication sharedApplication orderFrontStandardAboutPanel:nil\n]";
        }
        else blockSource = @"[:selectedObject| selectedObject  \"Define your custom block here.\"]";
        
        block = [blockSource asBlock];
      }  
      
      [button setIdentifier:[NSString stringWithFormat:@"Custom%d", i]];
      [button setName:buttonName];
      [button setBlock:block];
      [button setAction:@selector(applyBlockAction:)];
      [customButtons addObject:button];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCustomButtonsSettings:) name:NSApplicationWillTerminateNotification object:nil];
  }
} 

+ (void)saveCustomButtonsSettings 
{
  int i;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  for (i = 0; i < 10; i++)
  { 
    [defaults setObject:[[customButtons objectAtIndex:i] name] forKey:[NSString stringWithFormat:@"BigBrowserToolbarButtonCustom%dName",i+1] inDomain:@"NSGlobalDomain"]; // This is an undocumented Cocoa API in Mac OS X 10.1
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[[customButtons objectAtIndex:i] block]] forKey:[NSString stringWithFormat:@"BigBrowserToolbarButtonCustom%dBlock",i+1] inDomain:@"NSGlobalDomain"]; // This is an undocumented Cocoa API in Mac OS X 10.1
  } 
  [defaults synchronize];
}

+ (void)saveCustomButtonsSettings:(NSNotification *)aNotification
{
  [self saveCustomButtonsSettings];
}
 
- (void) applyBlockAction:(id)sender
{
  //BOOL exceptionOccured = NO;
  NSDictionary *userInfo = nil;
  id blockStack;
  Block *block = [sender block];

  NS_DURING
    [block compilIfNeeded];
  NS_HANDLER
      NSRunAlertPanel(@"Syntax Error", [localException reason], @"OK", nil, nil,nil);
      //exceptionOccured = YES; // NS_VOIDRETURN seems to be broken, so we use this control variable.
      userInfo = [[[localException userInfo] retain] autorelease]; // to be sure it stay alive during the rest of the current method
  NS_ENDHANDLER

  if (userInfo && (blockStack = [userInfo objectForKey:@"blockStack"]) )
  {
    inspectBlocksInCallStack(blockStack);
    return;
  }   

  if ([block isCompact])
  {
    [self sendMessage:[block selector] withArguments:nil];
  }
  else
  { 
    BigBrowserButtonCtxBlock *contextualizedBlock;
    SEL messageToArgumentSelector;
    
    contextualizedBlock = [interpreter bigBrowserButtonCtxBlockFromString:[block printString]];
    [contextualizedBlock setMaster:block];
    
    if ([contextualizedBlock argumentCount] == 0 )
    {
      NS_DURING 
        [contextualizedBlock value];
      NS_HANDLER
        NSRunAlertPanel(@"Error", [localException reason], @"OK", nil, nil,nil);
        userInfo = [[[localException userInfo] retain] autorelease]; // to be sure it stay alive during the rest of the current method
      NS_ENDHANDLER

      if (userInfo && (blockStack = [userInfo objectForKey:@"blockStack"]) )
      {
        inspectBlocksInCallStack(blockStack);
        return;
      }   
    }  
    else if ((messageToArgumentSelector = [contextualizedBlock messageToArgumentSelector]) != (SEL)0)
    {
      NSString *methodName = [Compiler stringFromSelector:messageToArgumentSelector];
      id selectedObject;

      if ((selectedObject = [self validSelectedObject]) == nil)
      {
        NSBeep();
        return;
      }
      
      [browser setDelegate:nil];
      [self selectMethodNamed:methodName];
      [browser setDelegate:self];
      
      if ([methodName isEqualToString:@"alloc"] || [methodName isEqualToString:@"allocWithZone:"])
        [self sendMessageTo:selectedObject selectorString:methodName arguments:[NSArray array] putResultInMatrix:[browser matrixInColumn:[browser lastColumn]]];
      else
      {
        id result = nil;
        
        NS_DURING 
          result = [contextualizedBlock value:selectedObject];
        NS_HANDLER
          NSRunAlertPanel(@"Error", [localException reason], @"OK", nil, nil,nil);
          userInfo = [[[localException userInfo] retain] autorelease]; // to be sure it stay alive during the rest of the current method
        NS_ENDHANDLER

        if (!result)
        {
          if (userInfo && (blockStack = [userInfo objectForKey:@"blockStack"]) ) inspectBlocksInCallStack(blockStack);
          return;
        }   
        
        [self fillMatrix:[browser matrixInColumn:[browser lastColumn]] withObject:result];
      }
    }
    else 
      [self sendMessage:@selector(applyBlock:) withArguments:[Array arrayWithObject:contextualizedBlock]];
  } 
  [browser scrollColumnToVisible:[browser lastColumn]];
  [browser scrollColumnsLeftBy:1]; // Workaround for the call above to scrollColumnToVisible: not working as expected.
}

- (void)addClassLabel:(NSString *)label toMatrix:(NSMatrix *)matrix
{
  NSBrowserCell *cell;
  //NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor colorWithCalibratedRed:0.13 green:0.6 blue:0.14 alpha:1], NSForegroundColorAttributeName, nil];
  NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor whiteColor], NSForegroundColorAttributeName, [NSColor colorWithCalibratedRed:0.1 green:0.65 blue:0.12 alpha:1], NSBackgroundColorAttributeName, nil];
  NSMutableAttributedString *attrStr = [[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %@   ", label] attributes:txtDict] autorelease];

  [matrix addRow];
  cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];  
  [cell setLeaf:YES];
  [cell setEnabled:NO];

  [matrix addRow];
  cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];  
  [cell setLeaf:YES];
  [cell setEnabled:NO];
  [attrStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0,[attrStr length])];
  [cell setAttributedStringValue:attrStr];
}

- (void)addLabel:(NSString *)label toMatrix:(NSMatrix *)matrix indentationLevel:(unsigned)indentationLevel
{
  NSBrowserCell *cell;
  NSMutableString *cellString = [NSMutableString string];

  [matrix addRow];
  cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];  
  [cell setLeaf:YES];
  [cell setEnabled:NO];
  for (unsigned i = 0; i < indentationLevel; i++) [cellString appendString:@"     "];
  [cellString appendString:label];
  [cell setStringValue:cellString];
}

- (void)addLabel:(NSString *)label toMatrix:(NSMatrix *)matrix
{
  [self addLabel:label toMatrix:matrix indentationLevel:0];
}

- (void)addObject:(id)object toMatrix:(NSMatrix *)matrix indentationLevel:(unsigned)indentationLevel leaf:(BOOL)leaf
{
  NSBrowserCell *cell;
  NSString *objectString = printString(object);
  
  if ([objectString length] > 510)
    objectString = [[objectString substringWithRange:NSMakeRange(0,500)] stringByAppendingString:@" ..."];

  [matrix addRow];
  cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];  
  [cell setRepresentedObject:object];
  if (object == nil || leaf) 
  {  
    [cell setLeaf:YES];
  }
  
  if ([object isKindOfClass:[NewlyAllocatedObjectHolder class]])
  {
    NSColor *txtColor = [NSColor purpleColor];
    NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:txtColor, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *attrStr = [[[NSMutableAttributedString alloc] initWithString:objectString attributes:txtDict] autorelease];
    
    [cell setAttributedStringValue:attrStr];
  }
  else
  {
    NSMutableString *cellString = [NSMutableString string];
    for (unsigned i = 0; i < indentationLevel; i++) [cellString appendString:@"     "];
    [cellString appendString:objectString];
    [cell setStringValue:cellString];
  }
}


- (void)addObject:(id)object toMatrix:(NSMatrix *)matrix indentationLevel:(unsigned)indentationLevel
{
  [self addObject:object toMatrix:matrix indentationLevel:indentationLevel leaf:NO];
}

- (void)addObject:(id)object toMatrix:(NSMatrix *)matrix
{
  [self addObject:object toMatrix:matrix indentationLevel:1];
}


- (void)addObject:(id)object withLabel:(NSString *)label toMatrix:(NSMatrix *)matrix leaf:(BOOL)leaf
{

  //NSRange rangeOfFilterInObjectPrintString = [printString(object) rangeOfString:methodFilterString options:NSCaseInsensitiveSearch];
  //NSRange rangeOfFilterInLabel = [label rangeOfString:methodFilterString options:NSCaseInsensitiveSearch];

  //if ([methodFilterString isEqualToString:@""] || rangeOfFilterInObjectPrintString.location != NSNotFound || rangeOfFilterInObjectPrintString.length != 0 || rangeOfFilterInLabel.location != NSNotFound || rangeOfFilterInLabel.length != 0)
  //{
    [self addLabel:label toMatrix:matrix];
    [self addObject:object toMatrix:matrix indentationLevel:1 leaf:leaf];
  //}  
}


- (void)addObject:(id)object withLabel:(NSString *)label toMatrix:(NSMatrix *)matrix
{
  //NSRange rangeOfFilterInObjectPrintString = [printString(object) rangeOfString:methodFilterString options:NSCaseInsensitiveSearch];
  //NSRange rangeOfFilterInLabel = [label rangeOfString:methodFilterString options:NSCaseInsensitiveSearch];

  //if ([methodFilterString isEqualToString:@""] || rangeOfFilterInObjectPrintString.location != NSNotFound || rangeOfFilterInObjectPrintString.length != 0 || rangeOfFilterInLabel.location != NSNotFound || rangeOfFilterInLabel.length != 0)
  //{
    [self addLabel:label toMatrix:matrix];
    [self addObject:object toMatrix:matrix indentationLevel:1 leaf:NO];
  //}  
}

- (void)addObjects:(NSArray *)objects withLabel:(NSString *)label toMatrix:(NSMatrix *)matrix
{
  if (objects)
  {
    unsigned i;
    unsigned count = [objects count];
  
    if (count != 0) 
    {
      [self addLabel:label toMatrix:matrix];
      for (i = 0; i < count; i++) [self addObject:[objects objectAtIndex:i] toMatrix:matrix];
    }
  }      
}

- (void)browser:(NSBrowser *)sender createRowsForColumn:(int)column inMatrix:(NSMatrix *)matrix // We are our own delegate 
{
  [matrixes addObject:matrix];
  
  if (column == 0)
  { 
    if (isBrowsingWorkspace) [self fillMatrixForWorkspaceBrowsing:matrix]; 
    else [self fillMatrix:matrix withObject:rootObject];
  }
  else if ( ((float)column)/2 != (int)(column/2) )
  {
    [self fillMatrix:matrix withMethodsForObject:[[browser selectedCell] representedObject]];
  }
  else  
  {     
    NSString    *selectedString     = [[[[self subviews] objectAtIndex:0] selectedCell] stringValue];
    SEL          selector           = [Compiler selectorFromString:selectedString];
    NSArray     *selectorComponents = [NSStringFromSelector(selector) componentsSeparatedByString:@":"];
    int          nbarg              = [selectorComponents count]-1;
    id           selectedObject     = [self selectedObject];  //[[[[self subviews] objectAtIndex:0] selectedCellInColumn:column-2] representedObject];
    MsgContext  *msgContext         = [[[MsgContext alloc] init] autorelease];
    int          unsupportedArgumentIndex;

    if ([selectedObject isKindOfClass:[NewlyAllocatedObjectHolder class]]) selectedObject = [selectedObject object];
    
    [msgContext prepareForMessageWithReceiver:selectedObject selector:[Compiler selectorFromString:selectedString]];
    unsupportedArgumentIndex = [msgContext unsuportedArgumentIndex];
    
    if (unsupportedArgumentIndex != -1)
    {
      NSString *errorString = [NSString stringWithFormat:@"Can't invoke method: the type expected for argument %d is not supported by F-Script.", unsupportedArgumentIndex+1];
      NSRunAlertPanel(@"Sorry", errorString, @"OK", nil, nil,nil);
      return;
    }
    else if ([msgContext unsuportedReturnType])
    {
      NSString *errorString = [NSString stringWithFormat:@"Can't invoke method: return type not supported by F-Script."];
      NSRunAlertPanel(@"Sorry", errorString, @"OK", nil, nil,nil);
      return;
    }  
    else if (nbarg == 0)
    {
      // NSBrowserCell *cell;
      [self sendMessageTo:selectedObject selectorString:selectedString arguments:[NSArray array] putResultInMatrix:matrix];
    
      /*if (cell = [matrix cellAtRow:0 column:0])
      {
        [self performSelector:@selector(setTitleOfLastColumn:) withObject:printString([[cell representedObject] classOrMetaclass]) afterDelay:0];
        // We do this because at the time tis method is called, the new column is not yet created.
        // Hence the need to delay the setTitle. 
      } */
    } 
    else
    {
      int i;
      int baseWidth  = 480;
      int baseHeight = nbarg*(userFixedPitchFontSize()+17)+75;
      NSButton *sendButton;
      NSButton *cancelButton;
      NSForm *f;
      NSWindow *argumentsWindow;
      NSMethodSignature *signature = [selectedObject methodSignatureForSelector:selector];
      
      argumentsWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(100,100,baseWidth,baseHeight) styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO];
      [argumentsWindow setTitle:@"Arguments"];
      [argumentsWindow setMinSize:NSMakeSize(230,baseHeight)];
      [argumentsWindow setMaxSize:NSMakeSize(1400,baseHeight)];
      
      f = [[[NSForm alloc] initWithFrame:NSMakeRect(20,60,baseWidth-40,baseHeight-80)] autorelease];
      [f setAutoresizingMask:NSViewWidthSizable];
      [f setInterlineSpacing:8]; 
      [[argumentsWindow contentView] addSubview:f]; // The form must be the first subview 
                                                    // (this is used by method sendMessageAction:)
      [argumentsWindow setInitialFirstResponder:f];                                              
                                                          
      sendButton = [[[NSButton alloc] initWithFrame:NSMakeRect(baseWidth/2,13,125,30)] autorelease];
      [sendButton setBezelStyle:1];
      [sendButton setTitle:@"Send Message"];   
      [sendButton setAction:@selector(sendMessageAction:)];
      [sendButton setTarget:self];
      [sendButton setKeyEquivalent:@"\r"];
      [[argumentsWindow contentView] addSubview:sendButton];
      
      cancelButton = [[[NSButton alloc] initWithFrame:NSMakeRect(baseWidth/2-95,13,95,30)] autorelease];
      [cancelButton setBezelStyle:1];
      [cancelButton setTitle:@"Cancel"];   
      [cancelButton setAction:@selector(cancelArgumentsSheetAction:)];
      [cancelButton setTarget:self];
      [[argumentsWindow contentView] addSubview:cancelButton];
      
      if (nbarg == 1 && [[selectorComponents objectAtIndex:0] hasPrefix:@"operator_"]) [f addEntry:selectedString];
      else 
        for (i = 0; i < nbarg; i++)
        {
          NSString *typeDescription = humanReadableFScriptTypeDescriptionFromEncodedObjCType([signature getArgumentTypeAtIndex:i+2]);
          
          if ([typeDescription length] > 0) typeDescription = [[@"(" stringByAppendingString:typeDescription] stringByAppendingString:@")"];
          
          [f addEntry:[[[selectorComponents objectAtIndex:i] stringByAppendingString:@":"] stringByAppendingString:typeDescription]];
        }
        
      [f setTextFont:[NSFont userFixedPitchFontOfSize:userFixedPitchFontSize()]];
      [f setTitleFont:[NSFont systemFontOfSize:systemFontSize()]];

      [f setAutosizesCells:YES]; 
      [f setTarget:sendButton];
      [f setAction:@selector(performClick:)];
      [f selectTextAtIndex:0];
      
      [NSApp beginSheet:argumentsWindow modalForWindow:[self window] modalDelegate:self didEndSelector:NULL contextInfo:NULL];
    }
  }
  [browser tile]; 
}

- (void) browseWorkspace
{
  isBrowsingWorkspace = YES;
  [rootObject release];
  rootObject = nil;  
  [browser loadColumnZero];
  //[browser displayColumn:0]; // may be unnecessary
}

- (void) cancelArgumentsSheetAction:(id)sender
{
  [NSApp endSheet:[sender window]];
  [[sender window] close];
  [[browser matrixInColumn:[browser lastColumn]-1] deselectAllCells];
}

- (void) cancelNameSheetAction:(id)sender
{
  [NSApp endSheet:[sender window]];
  [[sender window] close];
}

- (void) classesAction:(id)sender
{
  Array *classes = allClasses();
  [classes sortUsingFunction:compareClassesForAlphabeticalOrder context:NULL];
  [self setRootObject:classes]; 
}

- (void) dealloc
{
  //NSLog(@"BigBrowserView dealloc");

  /////// Partial Workaround for a bug in OS X 10.3 causing  memory leaks
  
  NSEnumerator *enumerator = [matrixes objectEnumerator];
  NSMatrix *matrix;
  int lastRowIndex;

  while ((matrix = [enumerator nextObject]))
  { 
    for ( lastRowIndex = [matrix numberOfRows]-1; lastRowIndex >= 0; lastRowIndex--)
      [matrix removeRow:lastRowIndex];
  }
  
  ////////////////////////////

  [matrixes release];
  [rootObject release];
  [interpreter release];
  [browser release];
  [statusBar release];
  [methodFilterString release];
  [super dealloc];
}

- (void) doubleClickAction:(id)sender
{
  int selectedColumn = [browser selectedColumn];

  // The inspector should not open if the user double clicked on a method
  if (((float)selectedColumn)/2 == (int)(selectedColumn/2) ) [self inspectObjectAction:sender];
}

- (void)fillMatrixForWorkspaceBrowsing:(NSMatrix*)matrix
{
  NSArray *symbols = [interpreter identifiers];
  unsigned count = [symbols count];
  unsigned i;
  BigBrowserCell *cell;
  NSString *cellString; 
  id object;
    
  [matrix renewRows:count columns:1]; // As a side effect, this will supress the selection
  [matrix sizeToCells]; // The NSMatrix doc advise to do that after calling renewRows:columns:
    
  for (i = 0; i < count; i++)
  {
    object = [interpreter objectForIdentifier:[symbols objectAtIndex:i] found:NULL];
    cell = [matrix cellAtRow:i column:0];
    [cell setRepresentedObject:object];
    if (object == nil) [cell setLeaf:YES];
    cellString = [NSString stringWithFormat:@"%@ = %@",[symbols objectAtIndex:i],printString(object)];
    if ([cellString length] > 510)
      cellString = [[cellString substringWithRange:NSMakeRange(0,500)] stringByAppendingString:@" ..."];
    //if ([cellString length] > 23) [matrix setToolTip:cellString forCell:cell];  
    [cell setStringValue:cellString];  
  }
}

- (void)fillMatrix:(NSMatrix *)matrix withMethodsForObject:(id)object
{
  id cls;
  BOOL exceptionOccured = NO;
  BOOL doNotShowSelectorsStartingWithUnderscore    = [[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptDoNotShowSelectorsStartingWithUnderscore"];
  BOOL doNotShowSelectorsStartingWithAccessibility = [[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptDoNotShowSelectorsStartingWithAccessibility"];
  BOOL methodFilterStringIsEmpty = [methodFilterString isEqualToString:@""];
  
  NS_DURING
    if ([object isKindOfClass:[NewlyAllocatedObjectHolder class]]) object = [object object];
  NS_HANDLER  
    // An exception may happend if the object is invalid (i.e. an invalid proxy)
    NSBeep();
    exceptionOccured = YES; // NS_VOIDRETURN seems to be broken, so we use this control variable.
  NS_ENDHANDLER
  
  if (exceptionOccured) return;
  
  if (isKindOfClassNSProxy(object) && object != [object class]) // the second condition is used because NSProxy is instance of itself and thus the isKindOfClassNSProxy() function returns YES even for the classes in the NSProxy hierarchy
  {
    // We try to get the class of the real object
    NSString *realObjectClassName = nil;
    
    NS_DURING
      realObjectClassName = [object className]; 
      // HACK: className is a method implemented by NSObject, but not by NSProxy.
      // Thus, this method should be forwarded to the real object. 
      // We do this inside an exception handler because the call to className may raise 
      // (for instance, if the real object is not in the NSObject hierarchy and does not responds to className,
      // or if there is a communication problem during the distributed object call)
      
      cls = NSClassFromString(realObjectClassName);
    NS_HANDLER
      cls = nil;
    NS_ENDHANDLER
    
    if (cls == nil) 
      if (realObjectClassName) NSBeginInformationalAlertSheet(@"Method list not available", @"OK", nil, nil, [self window], nil, NULL, NULL, NULL, @"Sorry, the method list for this object is not available. The class of the object (i.e. %@) is not loaded in the current application.", realObjectClassName);
      else                     NSBeginInformationalAlertSheet(@"Method list not available", @"OK", nil, nil, [self window], nil, NULL, NULL, NULL, @"Sorry, the method list for this object is not available.");

  }
  else cls = [object classOrMetaclass];
  
  while (cls)
  {      
    void *iterator = 0;
    struct objc_method_list *mlist;
    int i,nb;
    BigBrowserCell *cell;
    NSMutableArray *selectorStrings = [NSMutableArray arrayWithCapacity:80];
    //NSColor *txtColor = [NSColor blueColor];
    //NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:txtColor, NSForegroundColorAttributeName, nil];
    NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor whiteColor], NSForegroundColorAttributeName, [NSColor blueColor], NSBackgroundColorAttributeName, nil];

    NSMutableAttributedString *attrStr = [[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %@   ", [cls printString]] attributes:txtDict] autorelease];
    
    [attrStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0,[attrStr length])];

    [matrix addRow];
    cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
    [cell setLeaf:YES];
    [cell setEnabled:NO];
    [cell setAttributedStringValue:attrStr];
    //[matrix setToolTip:[cls printString] forCell:cell];
                 
    /*if ([methodFilterString isEqualToString:@""])
      while ( mlist = class_nextMethodList( cls, &iterator ) )
      {
        for (i = 0; i < mlist->method_count; i++) 
        {
          [selectorStrings addObject:[Compiler stringFromSelector:mlist->method_list[i].method_name]];
        }
      }
    else*/  
      while ( mlist = class_nextMethodList( cls, &iterator ) )  
      {
        for (i = 0; i < mlist->method_count; i++)
        {
          NSString *stringFromSelector = [Compiler stringFromSelector:mlist->method_list[i].method_name];
          if (   (methodFilterStringIsEmpty || containsString(stringFromSelector, methodFilterString, NSCaseInsensitiveSearch)) 
                 && (!doNotShowSelectorsStartingWithUnderscore    || ![stringFromSelector hasPrefix:@"_"])
                 && (!doNotShowSelectorsStartingWithAccessibility || ![stringFromSelector hasPrefix:@"accessibility"])
             )             
            [selectorStrings addObject:stringFromSelector];
        }
      }
    
    [selectorStrings sortUsingFunction:compareMethodsNamesForAlphabeticalOrder context:NULL];
    
    for (i = 0, nb = [selectorStrings count]; i < nb; i++)
    {
      [matrix addRow];
      cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
      [cell setStringValue:[selectorStrings objectAtIndex:i]];
      //if ([[cell stringValue] length] > 18)
      //  [matrix setToolTip:[cell stringValue] forCell:cell];
    }
    
    if (cls == [cls superclass])  // The NSProxy class return itself when asked for its superclass.
                                  // This would result in an iffinite loop. This test fix this.
      cls = nil;   
    else 
      //cls = [cls superclass];
      cls = ((struct {struct objc_class *isa; struct objc_class *super_class;}*)cls)->super_class;
      // This direct access technique is used instead of the -superclass method because this method is broken in the NSProxy hierarchy (does not return the "real" superclass) (Mac OS X 10.1.2).
    
    if (cls)
    {
      // add a blank line
      [matrix addRow];
      cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
      [cell setLeaf:YES];
      [cell setEnabled:NO];
    }
    
  }    
}

#define ADD_OBJECT(OBJECT,LABEL)         NS_DURING [self addObject:(OBJECT)                            withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_OBJECT_NOT_NIL(OBJECT,LABEL) NS_DURING {id object = (OBJECT); if (object) [self addObject:object withLabel:(LABEL) toMatrix:m];} NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER 
#define ADD_OBJECT_NOT_NIL_10_3(OBJECT,LABEL) NS_DURING if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_2) {id object = (OBJECT); if (object) [self addObject:object withLabel:(LABEL) toMatrix:m]; } NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_OBJECT_10_3(OBJECT,LABEL)    NS_DURING if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_2) [self addObject:(OBJECT) withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_OBJECTS(OBJECTS,LABEL)       NS_DURING [self addObjects:(OBJECTS)                          withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_OBJECTS_10_3(OBJECTS,LABEL)  NS_DURING if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_2) [self addObjects:(OBJECTS) withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_BOOL(B,LABEL)                NS_DURING [self addObject:[FSBoolean booleanWithBool:(B)]     withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_BOOL_10_3(B,LABEL)           NS_DURING if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_2) [self addObject:[FSBoolean booleanWithBool:(B)] withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_NUMBER(NUMBER,LABEL)         NS_DURING [self addObject:[Number numberWithDouble:(NUMBER)]  withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_NUMBER_10_3(NUMBER,LABEL)    NS_DURING if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_2) [self addObject:[Number numberWithDouble:(NUMBER)]  withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_SEL(S,LABEL)                 NS_DURING [self addObject:[Block blockWithSelector:(S)]       withLabel:(LABEL) toMatrix:m leaf:YES]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_SEL_NOT_NULL(S,LABEL)        NS_DURING {SEL selector = (S); if (selector != (SEL)0) [self addObject:[Block blockWithSelector:selector] withLabel:(LABEL) toMatrix:m leaf:YES]; } NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_SIZE(SIZE,LABEL)             NS_DURING [self addObject:[NSValue valueWithSize:(SIZE)]      withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_SIZE_10_3(SIZE,LABEL)        NS_DURING if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_2) [self addObject:[NSValue valueWithSize:(SIZE)] withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_RECT(RECT,LABEL)             NS_DURING [self addObject:[NSValue valueWithRect:(RECT)]      withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_POINT(POINT,LABEL)           NS_DURING [self addObject:[NSValue valueWithPoint:(POINT)]    withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_POINTER(POINTER,LABEL)       NS_DURING [self addObject:[Pointer pointerWithCPointer:(POINTER)] withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_RANGE(RANGE,LABEL)           NS_DURING [self addObject:[NSValue valueWithRange:(RANGE)]      withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER
#define ADD_RANGE_10_3(RANGE,LABEL)      NS_DURING if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_2) [self addObject:[NSValue valueWithRange:(RANGE)] withLabel:(LABEL) toMatrix:m]; NS_HANDLER NSLog(@"%@",localException); NS_ENDHANDLER


- (void)fillMatrix:(NSMatrix *)m withObject:(id)o 
{
  BigBrowserCell *cell;
  unsigned i, count;
      
  [o retain]; // (1) To be sure o will not be deallocated as a side effect of the removing of rows
  for (int j = [m numberOfRows]-1; j >= 0; j--) [m removeRow:j]; // Remove all rows. As a side effect, this will supress the selection
  [self addObject:o toMatrix:m indentationLevel:0];
  [o release]; // It's now safe to match the retain in instruction (1)
  
  if (([o isKindOfClass:[NSArray class]] || [o isKindOfClass:[NSDictionary class]] || [o isKindOfClass:[NSSet class]]) 
      && [o count] != 0 && [o count] < 50000 ) // For performance we display the elements only if there are less than 50000 of them
  {  
    [self addLabel:@"" toMatrix:m];
    if ([o isKindOfClass:[NSArray class]])
    {    
      [self addLabel:@"Elements" toMatrix:m];
      for (i=0, count = [o count]; i < count; i++) [self addObject:[o objectAtIndex:i] toMatrix:m indentationLevel:0];
    }
    else if ([o isKindOfClass:[NSDictionary class]])
    {
      NSEnumerator *enumerator = [o keyEnumerator];
      id key,value;
      NSString *objectString;   
      [self addLabel:@"Elements" toMatrix:m];
      while ((key = [enumerator nextObject])) 
      {
        [m addRow];
        cell = [m cellAtRow:[m numberOfRows]-1 column:0];  
        value = [o objectForKey:key];
        [cell setRepresentedObject:value];      
        objectString = [NSString stringWithFormat:@"%@ = %@",printString(key),printString(value)];
        if ([objectString length] > 510) 
          objectString = [[objectString substringWithRange:NSMakeRange(0,500)] stringByAppendingString:@" ..."];
        [cell setStringValue:objectString];
      }
    }
    else if ([o isKindOfClass:[NSSet class]])
    {
      NSEnumerator *enumerator = [o objectEnumerator];
      id elem;
      [self addLabel:@"Elements" toMatrix:m];
      while ((elem = [enumerator nextObject])) [self addObject:elem toMatrix:m indentationLevel:0];
    }
  }
  else if ([o isKindOfClass:[NSResponder class]])
  {
    if ([o isKindOfClass:[NSView class]])
    {
      NSView *view;
      
      /*NSImage *image; 
      NSBrowserCell *cell;
      [self addLabel:@"Preview" toMatrix:m];
      image = [[[NSImage alloc] initWithData:[o dataWithPDFInsideRect:[o bounds]]] autorelease];
      if ([image size].width > 200 || [image size].height > 200)
      {
        [image setScalesWhenResized:YES];
        [image setSize:NSMakeSize(200,200)];
      }  
      [m addRow];
      cell = [m cellAtRow:[m numberOfRows]-1 column:0];  
      [cell setImage:image];
      [cell setLeaf:YES];
      [cell setEnabled:NO];    
      [m addRow]; */
      
      if ([o isKindOfClass:[NSBox class]])
      {
        [self addClassLabel:@"NSBox Info" toMatrix:m];
        ADD_RECT(            [o borderRect]                         ,@"Border rect")
        ADD_OBJECT(objectFromBorderType([o borderType])             ,@"Border type" )
        ADD_OBJECT(objectFromBoxType([o boxType])                   ,@"Box type" )
        ADD_OBJECT(          [o contentView]                        ,@"Content view" )
        ADD_SIZE(            [o contentViewMargins]                 ,@"Content view margins")
        ADD_OBJECT(          [o title]                              ,@"Title" )
        ADD_OBJECT(          [o titleCell]                          ,@"Title cell" )
        ADD_OBJECT(          [o titleFont]                          ,@"Title font" )
        ADD_OBJECT(objectFromTitlePosition([o titlePosition])       ,@"Title position" )
        ADD_RECT(            [o titleRect]                          ,@"Title rect")
      }
      else if ([o isKindOfClass:[NSControl class]])
      {
        if ([o isKindOfClass:[NSBrowser class]])
        {
          [self addClassLabel:@"NSBrowser Info" toMatrix:m];
          ADD_BOOL(          [o acceptsArrowKeys]                   ,@"Accepts arrow keys")                      
          ADD_BOOL(          [o allowsBranchSelection]              ,@"Allows branch selection")                      
          ADD_BOOL(          [o allowsEmptySelection]               ,@"Allows empty selection")                      
          ADD_BOOL(          [o allowsMultipleSelection]            ,@"Allows multiple selection")                      
          ADD_OBJECT(        [o cellPrototype]                      ,@"Cell prototype" )
          ADD_OBJECT_10_3( objectFromBrowserColumnResizingType([o columnResizingType]) ,@"Column resizing type")
          ADD_OBJECT_10_3(   [o columnsAutosaveName]                ,@"Columns autosave name") 
          ADD_OBJECT(        [o delegate]                           ,@"Delegate")
          ADD_SEL(           [o doubleAction]                       ,@"Double action")
          ADD_NUMBER(        [o firstVisibleColumn]                 ,@"First visible column")  
          ADD_BOOL(          [o hasHorizontalScroller]              ,@"Has horizontal scroller")                      
          ADD_BOOL(          [o isLoaded]                           ,@"Is loaded")                      
          ADD_BOOL(          [o isTitled]                           ,@"Is titled")                      
          ADD_NUMBER(        [o lastColumn]                         ,@"Last column")  
          ADD_NUMBER(        [o lastVisibleColumn]                  ,@"Last visible column")  
          ADD_OBJECT(        [o matrixClass]                        ,@"Matrix class")
          ADD_NUMBER(        [o maxVisibleColumns]                  ,@"Max visible columns")  
          ADD_NUMBER(        [o minColumnWidth]                     ,@"Min column width")  
          ADD_NUMBER(        [o numberOfVisibleColumns]             ,@"Number of visible columns" )  
          ADD_OBJECT(        [o path]                               ,@"Path")
          ADD_OBJECT(        [o pathSeparator]                      ,@"Path separator")
          ADD_BOOL_10_3(     [o prefersAllColumnUserResizing]       ,@"Prefers all column user resizing" )                      
          ADD_BOOL(          [o reusesColumns]                      ,@"Reuses columns")                      
          ADD_OBJECTS(       [o selectedCells]                      ,@"Selected cells")
          ADD_NUMBER(        [o selectedColumn]                     ,@"Selected column")  
          ADD_BOOL(          [o sendsActionOnArrowKeys]             ,@"Sends action on arrow keys")                      
          ADD_BOOL(          [o separatesColumns]                   ,@"Separates columns")                      
          ADD_BOOL(          [o takesTitleFromPreviousColumn]       ,@"Takes title from previous column" )                      
          ADD_NUMBER(        [o titleHeight]                        ,@"Title height")  
        }
        else if ([o isKindOfClass:[NSButton class]])
        {
          if ([o isKindOfClass:[NSPopUpButton class]])
          {
            [self addClassLabel:@"NSPopUpButton Info" toMatrix:m];
            ADD_BOOL(          [o autoenablesItems]             ,@"Autoenables Items")
            ADD_NUMBER(        [o indexOfSelectedItem]          ,@"Index of selected item")
            ADD_OBJECTS(       [o itemArray]                    ,@"Item array")    
            ADD_NUMBER(        [o numberOfItems]                ,@"Number of items")
            ADD_OBJECT(        [o objectValue]                  ,@"Object value")
            ADD_OBJECT(objectFromRectEdge([o preferredEdge])    ,@"Preferred edge")
            ADD_BOOL(          [o pullsDown]                    ,@"Pulls down")
            ADD_OBJECT(        [o selectedItem]                 ,@"Selected item")
          }

          [self addClassLabel:@"NSButton Info" toMatrix:m];
          ADD_BOOL(          [o allowsMixedState]                   ,@"Allows mixed state")                      
          ADD_OBJECT_NOT_NIL([o alternateImage]                     ,@"Alternate image" )
          ADD_OBJECT(        [o alternateTitle]                     ,@"Alternate title")
          ADD_OBJECT(        [o attributedAlternateTitle]           ,@"Attributed alternate title")
          ADD_OBJECT(        [o attributedTitle]                    ,@"Attributed title")
          ADD_OBJECT(objectFromBezelStyle([o bezelStyle])           ,@"Bezel style")
          ADD_OBJECT(        [o image]                              ,@"Image")
          ADD_OBJECT(objectFromCellImagePosition([o imagePosition]) ,@"Image position")
          ADD_BOOL(          [o isBordered]                         ,@"Is bordered")                      
          ADD_BOOL(          [o isTransparent]                      ,@"Is transparent" )                      
          ADD_OBJECT(        [o keyEquivalent]                      ,@"Key equivalent")
          ADD_OBJECT(objectFromKeyModifierMask([o keyEquivalentModifierMask]) , @"Key equivalent modifier mask")
          ADD_BOOL(          [o showsBorderOnlyWhileMouseInside]    ,@"Shows border only while mouse inside")                      
          ADD_OBJECT_NOT_NIL([o sound]                              ,@"Sound")
          ADD_OBJECT(objectFromCellStateValue([o state])            ,@"State")
          ADD_OBJECT(        [o title]                              ,@"Title")
        }
        else if ([o isKindOfClass:[NSColorWell class]])
        {
          [self addClassLabel:@"NSColorWell Info" toMatrix:m];
          ADD_OBJECT(        [o color]                              ,@"Color")
          ADD_BOOL(          [o isActive]                           ,@"Is active" )
          ADD_BOOL(          [o isBordered]                         ,@"Is bordered")
        }       
        else if ([o isKindOfClass:[NSImageView class]])
        {
          [self addClassLabel:@"NSImageView Info" toMatrix:m];
          ADD_BOOL_10_3(     [o animates]                           ,@"Animates")
          ADD_OBJECT(        [o image]                              ,@"Image")
          ADD_OBJECT(objectFromImageAlignment([o imageAlignment])   ,@"Image alignment")
          ADD_OBJECT(objectFromImageFrameStyle([o imageFrameStyle]) ,@"Image frame style")
          ADD_OBJECT(objectFromImageScaling([o imageScaling])       ,@"Image scaling")
          ADD_BOOL(          [o isEditable]                         ,@"Is editable")
        }                 
        else if ([o isKindOfClass:[NSMatrix class]])
        {
          [self addClassLabel:@"NSMatrix Info" toMatrix:m];
          ADD_BOOL(          [o allowsEmptySelection]               ,@"Allows empty selection")
          ADD_BOOL(          [o autosizesCells]                     ,@"Autosizes cells")
          ADD_OBJECT(        [o backgroundColor]                    ,@"Background color")
          ADD_OBJECT(        [o cellBackgroundColor]                ,@"Cell background color")
          ADD_OBJECT(        [o cellClass]                          ,@"Cell class")
          ADD_SIZE(          [o cellSize]                           ,@"Cell size");
          ADD_OBJECTS(       [o cells]                              ,@"Cells") 
          ADD_OBJECT(        [o delegate]                           ,@"Delegate")
          ADD_SEL(           [o doubleAction]                       ,@"Double action")
          ADD_BOOL(          [o drawsBackground]                    ,@"Draws background")
          ADD_BOOL(          [o drawsCellBackground]                ,@"Draws cell background")
          ADD_SIZE(          [o intercellSpacing]                   ,@"Intercell spacing")
          ADD_BOOL(          [o isAutoscroll]                       ,@"Is autoscroll")
          ADD_BOOL(          [o isSelectionByRect]                  ,@"Is selection by rect")        
          ADD_OBJECT(        [o keyCell]                            ,@"Key cell")
          ADD_OBJECT(objectFromMatrixMode([(NSMatrix *)o mode])     ,@"Mode")
          ADD_NUMBER(        [o numberOfColumns]                    ,@"Number of columns")  
          ADD_NUMBER(        [o numberOfRows]                       ,@"Number of rows")
          ADD_OBJECT(        [o prototype]                          ,@"Prototype")
          ADD_OBJECTS(       [o selectedCells]                      ,@"Selected cells")
          ADD_NUMBER(        [o selectedColumn]                     ,@"Selected column")  
          ADD_NUMBER(        [o selectedRow]                        ,@"Selected row")  
          ADD_BOOL(          [o tabKeyTraversesCells]               ,@"Tab key traverses cells")                      
        }
        else if ([o isKindOfClass:[NSScroller class]])
        {
          [self addClassLabel:@"NSScroller Info" toMatrix:m];
          ADD_OBJECT(objectFromScrollArrowPosition([o arrowsPosition]),@"Arrows position")
          ADD_OBJECT(objectFromControlSize([o controlSize])         ,@"Control size")
          ADD_OBJECT(objectFromControlTint([o controlTint])         ,@"Control tint")
          ADD_NUMBER(        [o floatValue]                         ,@"Float value")
          ADD_OBJECT(objectFromScrollerPart([o hitPart])            ,@"Hit part")
          ADD_NUMBER(        [o knobProportion]                     ,@"Knob proportion")
          ADD_OBJECT(objectFromUsableScrollerParts([o usableParts]) ,@"Usable parts")
        }                         
        else if ([o isKindOfClass:NSClassFromString(@"NSSegmentedControl")])
        {
          int segmentCount = [o segmentCount];
          [self addClassLabel:@"NSSegmentedControl Info" toMatrix:m];
          
          ADD_NUMBER(        segmentCount                           ,@"Segment count")
          ADD_NUMBER(        [o selectedSegment]                    ,@"Selected segment")

          for (int i = 0; i < segmentCount; i++)
          {
            [self addLabel:@"" toMatrix:m];
            [self addLabel:[NSString stringWithFormat:@"Segment %d",i] toMatrix:m];
            
            if ([o imageForSegment:i])
            {
              [self addLabel:@"Image" toMatrix:m indentationLevel:1];
              [self addObject:[o imageForSegment:i] toMatrix:m indentationLevel:2];
            }
            
            [self addLabel:@"Is enabled" toMatrix:m indentationLevel:1];
            [self addObject:[FSBoolean booleanWithBool:[o isEnabledForSegment:i]] toMatrix:m indentationLevel:2];

            [self addLabel:@"Is selected" toMatrix:m indentationLevel:1];
            [self addObject:[FSBoolean booleanWithBool:[o isSelectedForSegment:i]] toMatrix:m indentationLevel:2];

            if ([o labelForSegment:i])
            {
              [self addLabel:@"Label" toMatrix:m indentationLevel:1];
              [self addObject:[o labelForSegment:i] toMatrix:m indentationLevel:2];
            }
            
            if ([o menuForSegment:i])
            {
              [self addLabel:@"Menu" toMatrix:m indentationLevel:1];
              [self addObject:[o menuForSegment:i] toMatrix:m indentationLevel:2];
            }
                        
            if ([o widthForSegment:i] != 0)
            {
              [self addLabel:@"Width" toMatrix:m indentationLevel:1];
              [self addObject:[Number numberWithDouble:[o widthForSegment:i]] toMatrix:m indentationLevel:2];
            }
          }
        }
        else if ([o isKindOfClass:[NSSlider class]])
        {
          [self addClassLabel:@"NSSlider Info" toMatrix:m];
          ADD_BOOL(          [o allowsTickMarkValuesOnly]           ,@"Allows tick mark values only")   
          ADD_NUMBER(        [o altIncrementValue]                  ,@"Alt increment value")  
          ADD_NUMBER(        [(NSSlider*)o isVertical]              ,@"Is vertical")  
          ADD_NUMBER(        [o knobThickness]                      ,@"Knob thickness")  
          ADD_NUMBER(        [o maxValue]                           ,@"Max value")  
          ADD_NUMBER(        [o minValue]                           ,@"Min value")  
          ADD_NUMBER(        [o numberOfTickMarks]                  ,@"Number of tick marks")
          ADD_OBJECT(objectFromTickMarkPosition([o tickMarkPosition], [(NSSlider*)o isVertical] == 1),@"Tick mark position")
          ADD_OBJECT(        [o title]                              ,@"title")
        }
        else if ([o isKindOfClass:[NSTableView class]])
        {
          if ([o isKindOfClass:[NSOutlineView class]])
          {
            [self addClassLabel:@"NSOutlineView Info" toMatrix:m];
            ADD_BOOL(          [o autoresizesOutlineColumn]         ,@"Autoresizes outline column")
            ADD_BOOL(          [o autosaveExpandedItems]            ,@"Autosave expanded items")
            ADD_BOOL(          [o indentationMarkerFollowsCell]     ,@"Indentation marker follows cell")
            ADD_NUMBER(        [o indentationPerLevel]              ,@"Indentation per level")  
            ADD_OBJECT(        [o outlineTableColumn]               ,@"Outline table column")
          }
          
          [self addClassLabel:@"NSTableView Info" toMatrix:m];
          ADD_BOOL(          [o allowsColumnReordering]             ,@"Allows column reordering")
          ADD_BOOL(          [o allowsColumnResizing]               ,@"Allows column resizing")
          ADD_BOOL(          [o allowsColumnSelection]              ,@"Allows column selection")
          ADD_BOOL(          [o allowsEmptySelection]               ,@"Allows empty selection")
          ADD_BOOL(          [o allowsMultipleSelection]            ,@"Allows multiple selection")
          ADD_BOOL(          [o autoresizesAllColumnsToFit]         ,@"Autoresizes all columns to fit" )
          ADD_OBJECT_NOT_NIL([o autosaveName]                       ,@"Autosave name")       
          ADD_BOOL(          [o autosaveTableColumns]               ,@"Autosave table columns")
          ADD_OBJECT(        [o backgroundColor]                    ,@"Background color")         
          ADD_OBJECT(        [o cornerView]                         ,@"Corner view")
          ADD_OBJECT(        [o dataSource]                         ,@"Data source")
          ADD_OBJECT(        [o delegate]                           ,@"Delegate")
          ADD_SEL(           [o doubleAction]                       ,@"Double action")
          ADD_OBJECT(        [o gridColor]                          ,@"Grid color")
          ADD_OBJECT_10_3(objectFromGridStyleMask([o gridStyleMask]),@"Grid style mask")
          ADD_OBJECT(        [o headerView]                         ,@"Header view")   
          ADD_OBJECT(        [o highlightedTableColumn]             ,@"Highlighted table column")
          ADD_SIZE(          [o intercellSpacing]                   ,@"Intercell spacing")
          ADD_NUMBER(        [o numberOfColumns]                    ,@"Number of columns")  
          ADD_NUMBER(        [o numberOfRows]                       ,@"Number of rows")  
          ADD_NUMBER(        [o numberOfSelectedColumns]            ,@"Number of selected columns")  
          ADD_NUMBER(        [o numberOfSelectedRows]               ,@"Number of selected rows")  
          ADD_NUMBER(        [o rowHeight]                          ,@"Row height")  
          ADD_NUMBER(        [o selectedColumn]                     ,@"Selected column")  
          ADD_OBJECT_10_3(   [o selectedColumnIndexes]              ,@"Selected column indexes")  
          ADD_NUMBER(        [o selectedRow]                        ,@"Selected row")  
          ADD_OBJECT_10_3(   [o selectedRowIndexes]                 ,@"Selected row indexes")  
          ADD_OBJECTS_10_3(  [o sortDescriptors]                    ,@"Sort descriptors")  
          ADD_OBJECTS(       [o tableColumns]                       ,@"Table columns")
          ADD_BOOL_10_3(     [o usesAlternatingRowBackgroundColors] ,@"Uses alternating row background colors" )
          ADD_BOOL(          [o verticalMotionCanBeginDrag]         ,@"Vertical motion can begin drag"  )
        }
        else if ([o isKindOfClass:[NSStepper class]])
        {
          [self addClassLabel:@"NSStepper Info" toMatrix:m];
          ADD_BOOL(          [o autorepeat]                         ,@"Autorepeat")   
          ADD_NUMBER(        [o increment]                          ,@"Increment")  
          ADD_NUMBER(        [o maxValue]                           ,@"Max value")  
          ADD_NUMBER(        [o minValue]                           ,@"Min value")  
          ADD_BOOL(          [o valueWraps]                         ,@"Value wraps")           
        }      
        else if ([o isKindOfClass:[NSTextField class]])
        {
          if ([o isKindOfClass:[NSComboBox class]]) 
          {
            [self addClassLabel:@"NSComboBox Info" toMatrix:m];
            if ([o usesDataSource]) ADD_OBJECT([o dataSource]       ,@"Data source")         
            ADD_BOOL(        [o hasVerticalScroller]                ,@"Has vertical scroller")
            ADD_NUMBER(      [o indexOfSelectedItem]                ,@"Index of selected item")  
            ADD_SIZE(        [o intercellSpacing]                   ,@"Intercell spacing")
            ADD_BOOL_10_3(   [o isButtonBordered]                   ,@"Is button bordered")
            ADD_NUMBER(      [o itemHeight]                         ,@"Item height")  
            ADD_NUMBER(      [o numberOfItems]                      ,@"Number of items")  
            ADD_NUMBER(      [o numberOfVisibleItems]               ,@"Number of visible items")  
            if (![o usesDataSource] && [o indexOfSelectedItem] != -1) 
              ADD_OBJECT(    [o objectValueOfSelectedItem]          ,@"Object value of selected item")         
            if (![o usesDataSource]) 
              ADD_OBJECTS(   [o objectValues]                       ,@"Object values")    
            ADD_BOOL(        [o usesDataSource]                     ,@"Uses data source")                   
          }
          else if ([o isKindOfClass:NSClassFromString(@"NSSearchField")])
          {
            if ([[o recentSearches] count] != 0 || [o recentsAutosaveName] != nil) 
              [self addClassLabel:@"NSSearchField Info" toMatrix:m];
            ADD_OBJECTS(     [o recentSearches]                     ,@"Recent searches")    
            ADD_OBJECT_NOT_NIL([o recentsAutosaveName]              ,@"Recents autosave name")    
          }
                    
          [self addClassLabel:@"NSTextField Info" toMatrix:m];
          ADD_BOOL(          [o allowsEditingTextAttributes]        ,@"Allows editing text attributes")
          ADD_OBJECT(        [o backgroundColor]                    ,@"Background color")         
          ADD_OBJECT(objectFromTextFieldBezelStyle([o bezelStyle])  ,@"Bezel style")
          ADD_OBJECT(        [o delegate]                           ,@"Delegate")
          ADD_BOOL(          [o drawsBackground]                    ,@"Draws background")
          ADD_BOOL(          [o importsGraphics]                    ,@"Imports graphics")
          ADD_BOOL(          [o isBezeled]                          ,@"Is bezeled")
          ADD_BOOL(          [o isBordered]                         ,@"Is bordered")
          ADD_BOOL(          [o isEditable]                         ,@"Is editable")
          ADD_BOOL(          [o isSelectable]                       ,@"Is selectable")
          ADD_OBJECT(        [o textColor]                          ,@"Text color")
        }  

        [self addClassLabel:@"NSControl Info" toMatrix:m];
        
        ADD_SEL(             [o action]                             ,@"Action")
        ADD_OBJECT(          objectFromTextAlignment([o alignment]) ,@"Alignment")
        ADD_OBJECT(          [o cell]                               ,@"Cell")
        ADD_OBJECT_NOT_NIL(  [o currentEditor]                      ,@"Current editor")
        ADD_OBJECT(          [o font]                               ,@"Font")
        ADD_OBJECT(          [o formatter]                          ,@"Formatter")
        ADD_BOOL(            [o ignoresMultiClick]                  ,@"Ignores multiclick")
        ADD_BOOL(            [o isContinuous]                       ,@"Is continuous")
        ADD_BOOL(            [o isEnabled]                          ,@"Is enabled")  
        if ([o currentEditor] == nil) ADD_OBJECT([o objectValue]    ,@"Object value") // To avoid side-effects, we only call objectValue if the control is not being edited, which is determined with the currentEditor call.
        ADD_BOOL(            [o refusesFirstResponder]              ,@"Refuses first responder")
        ADD_OBJECT(          [o selectedCell]                       ,@"Selected cell")
        ADD_NUMBER(          [o selectedTag]                        ,@"Selected tag")
        ADD_OBJECT(          [o target]                             ,@"Target")
      }
      else if ([o isKindOfClass:[NSClipView class]])
      {
        [self addClassLabel:@"NSClipView Info" toMatrix:m];
        ADD_OBJECT(          [o backgroundColor]                    ,@"Background color")         
        ADD_BOOL(            [o copiesOnScroll]                     ,@"Copies on scroll")
        ADD_OBJECT(          [o documentCursor]                     ,@"Document cursor")
        ADD_RECT(            [o documentRect]                       ,@"Document rect")
        ADD_OBJECT(          [o documentView]                       ,@"Document view")
        ADD_RECT(            [o documentVisibleRect]                ,@"Document visible rect")
        ADD_BOOL(            [o drawsBackground]                    ,@"Draws background")
      }
      else if ([o isKindOfClass:[NSMovieView class]])
      {
        [self addClassLabel:@"NSMovieView Info" toMatrix:m];
        ADD_BOOL(            [o isControllerVisible]                ,@"Is controller visible")
        ADD_BOOL(            [o isEditable]                         ,@"Is editable")
        ADD_BOOL(            [o isMuted]                            ,@"Is muted")
        ADD_BOOL(            [o isPlaying]                          ,@"Is playing")
        ADD_OBJECT(objectFromQTMovieLoopMode([o loopMode])          ,@"Loop mode")        
        ADD_OBJECT(          [o movie]                              ,@"Movie")
        
        {
          void *movieController = [o movieController];
          if (movieController)
            ADD_OBJECT([Pointer pointerWithCPointer:movieController],@"Movie controler")
        }
        
        ADD_RECT(            [o movieRect]                          ,@"Movie rect")
        ADD_BOOL(            [o playsEveryFrame]                    ,@"Plays every frame")
        ADD_BOOL(            [o playsSelectionOnly]                 ,@"Plays selection only")
        ADD_NUMBER(          [o rate]                               ,@"Rate")
        ADD_NUMBER(          [o volume]                             ,@"Volume")
      }
      else if ([o isKindOfClass:[NSScrollView class]])
      {
        [self addClassLabel:@"NSScrollView Info" toMatrix:m];
        ADD_BOOL_10_3(       [o autohidesScrollers]                 ,@"Autohides scrollers")
        ADD_OBJECT(          [o backgroundColor]                    ,@"Background color")         
        ADD_OBJECT(          objectFromBorderType([o borderType])   ,@"Border type")
        ADD_SIZE(            [o contentSize]                        ,@"Content size")
        ADD_OBJECT(          [o contentView]                        ,@"Content view")
        ADD_OBJECT(          [o documentCursor]                     ,@"Document cursor")
        ADD_OBJECT(          [o documentView]                       ,@"Document view")
        ADD_RECT(            [o documentVisibleRect]                ,@"Document visible rect")
        ADD_BOOL(            [o drawsBackground]                    ,@"Draws background")
        ADD_BOOL(            [o hasHorizontalRuler]                 ,@"Has horizontal ruler")
        ADD_BOOL(            [o hasHorizontalScroller]              ,@"Has horizontal scroller")
        ADD_BOOL(            [o hasVerticalRuler]                   ,@"Has vertical ruler")
        ADD_BOOL(            [o hasVerticalScroller]                ,@"Has vertical scroller")
        ADD_NUMBER(          [o horizontalLineScroll]               ,@"Horizontal line scroll")
        ADD_NUMBER(          [o horizontalPageScroll]               ,@"Horizontal page scroll")
        ADD_OBJECT(          [o horizontalRulerView]                ,@"Horizontal ruler view")
        ADD_OBJECT(          [o horizontalScroller]                 ,@"Horizontal scroller")
        ADD_NUMBER(          [o lineScroll]                         ,@"Line scroll")
        ADD_NUMBER(          [o pageScroll]                         ,@"Page scroll")
        ADD_BOOL(            [o rulersVisible]                      ,@"Ruller visible")
        ADD_BOOL(            [o scrollsDynamically]                 ,@"Scrolls dynamically")
        ADD_NUMBER(          [o verticalLineScroll]                 ,@"Vertical line scroll")
        ADD_NUMBER(          [o verticalPageScroll]                 ,@"Vertical page scroll")
        ADD_OBJECT(          [o verticalRulerView]                  ,@"Vertical ruler view")
        ADD_OBJECT(          [o verticalScroller]                   ,@"Vertical scroller")
      }
      else if ([o isKindOfClass:[NSTabView class]])
      {
        [self addClassLabel:@"NSTabView Info" toMatrix:m];
        ADD_BOOL(            [o allowsTruncatedLabels]              ,@"Allows truncated labels")
        ADD_RECT(            [o contentRect]                        ,@"Content rect")
        ADD_OBJECT(          objectFromControlSize([o controlSize]) ,@"Control size")
        ADD_OBJECT(          objectFromControlTint([o controlTint]) ,@"Control tint")
        ADD_OBJECT(          [o delegate]                           ,@"Delegate")
        ADD_BOOL(            [o drawsBackground]                    ,@"Draws background")
        ADD_OBJECT(          [o font]                               ,@"Font")
        ADD_SIZE(            [o minimumSize]                        ,@"Minimum size")
        ADD_OBJECT(          [o selectedTabViewItem]                ,@"Selected tab view item")        
        ADD_OBJECTS(         [o tabViewItems]                       ,@"Tab view items")
        ADD_OBJECT(          objectFromTabViewType([o tabViewType]) ,@"Tab view type")
      }
      else if ([o isKindOfClass:[NSTableHeaderView class]])
      {
        [self addClassLabel:@"NSTableHeaderView Info" toMatrix:m];
        ADD_OBJECT(          [o tableView]                          ,@"Table view") 
      }
      else if ([o isKindOfClass:[NSText class]])
      {
        if ([o isKindOfClass:[NSTextView class]])
        {
          [self addClassLabel:@"NSTextView Info" toMatrix:m];
          ADD_OBJECTS(       [o acceptableDragTypes]                ,@"Acceptable drag types")         
          ADD_BOOL(          [o acceptsGlyphInfo]                   ,@"Accepts glyph info")
          ADD_BOOL_10_3(     [o allowsDocumentBackgroundColorChange],@"Allows document background color change")
          ADD_BOOL(          [o allowsUndo]                         ,@"Allows undo")
          ADD_OBJECT_NOT_NIL_10_3([o defaultParagraphStyle]         ,@"Default paragraph style")         
          ADD_OBJECT(        [o insertionPointColor]                ,@"Insertion point color")
          ADD_BOOL(          [o isContinuousSpellCheckingEnabled]   ,@"Is continuous spell checking enabled")
          ADD_OBJECT_NOT_NIL([o layoutManager]                      ,@"Layout manager")
          ADD_OBJECT_NOT_NIL_10_3([o linkTextAttributes]            ,@"Link text attributes")
          ADD_OBJECT_NOT_NIL([o markedTextAttributes]               ,@"Marked text attributes")
          ADD_RANGE(        [o rangeForUserCharacterAttributeChange],@"Range for user character attribute change")
          ADD_RANGE_10_3(    [o rangeForUserCompletion]             ,@"Range for user completion")
          ADD_RANGE(        [o rangeForUserParagraphAttributeChange],@"Range for user paragraph attribute change")
          ADD_RANGE(        [o rangeForUserTextChange],@"Range for user text change")
          ADD_OBJECTS(       [o readablePasteboardTypes]            ,@"Readable pasteboard types")         
          ADD_OBJECT(        [o selectedTextAttributes]             ,@"Selected text attributes")
          ADD_OBJECT(objectFromSelectionAffinity([o selectionAffinity]),@"Selection affinity")
          ADD_OBJECT(objectFromSelectionGranularity([o selectionGranularity]),@"Selection granularity")
          ADD_BOOL(          [o shouldDrawInsertionPoint]           ,@"Should draw insertion point")
          ADD_BOOL(          [o smartInsertDeleteEnabled]           ,@"Smart insert delete enabled")
          ADD_NUMBER(        [o spellCheckerDocumentTag]            ,@"Spell checker document tag")
          ADD_OBJECT(        [o textContainer]                      ,@"Text container")
          ADD_SIZE(          [o textContainerInset]                 ,@"Text container inset")
          ADD_POINT(         [o textContainerOrigin]                ,@"Text container origin")
          ADD_OBJECT(        [o textStorage]                        ,@"Text storage")
          ADD_OBJECT(        [o typingAttributes]                   ,@"Typing attributes")
          ADD_BOOL_10_3(     [o usesFindPanel]                      ,@"Uses find panel")
          ADD_BOOL(          [o usesFontPanel]                      ,@"Uses font panel")
          ADD_BOOL(          [o usesRuler]                          ,@"Uses ruler")
          ADD_OBJECT(        [o writablePasteboardTypes]            ,@"Writable pasteboard types")
        }
        
        [self addClassLabel:@"NSText Info" toMatrix:m];
        ADD_OBJECT(          objectFromTextAlignment([o alignment]) ,@"Alignment")
        ADD_OBJECT(          [o backgroundColor]                    ,@"Background color")         
        ADD_OBJECT_NOT_NIL(  [o delegate]                           ,@"Delegate")         
        ADD_BOOL(            [o drawsBackground]                    ,@"Draws background")
        ADD_OBJECT(          [o font]                               ,@"Font")
        ADD_BOOL(            [o importsGraphics]                    ,@"Imports graphics")
        ADD_BOOL(            [o isEditable]                         ,@"Is editable")
        ADD_BOOL(            [o isFieldEditor]                      ,@"Is field editor")
        ADD_BOOL(            [o isHorizontallyResizable]            ,@"Is horizontally resizable")
        ADD_BOOL(            [o isRichText]                         ,@"Is rich text")
        ADD_BOOL(            [o isRulerVisible]                     ,@"Is ruler visible")
        ADD_BOOL(            [o isSelectable]                       ,@"Is selectable")
        ADD_BOOL(            [o isVerticallyResizable]              ,@"Is vertically resizable")
        ADD_SIZE(            [o maxSize]                            ,@"Max size")
        ADD_SIZE(            [o minSize]                            ,@"Min size")
        ADD_RANGE(           [o selectedRange]                      ,@"Selected range")
        ADD_OBJECT(          [o string]                             ,@"String")
        ADD_OBJECT_NOT_NIL(  [o textColor]                          ,@"Text color")
        ADD_BOOL(            [o usesFontPanel]                      ,@"Uses font panel")
      }

      [self addClassLabel:@"NSView Info" toMatrix:m];
      ADD_OBJECT(objectFromAutoresizingMask([o autoresizingMask])   ,@"Autoresizing mask")      
      ADD_BOOL(              [o autoresizesSubviews]                ,@"Autoresizes subviews")
      ADD_RECT(              [o bounds]                             ,@"Bounds")
      ADD_NUMBER(            [o boundsRotation]                     ,@"Bounds rotation")      
      ADD_BOOL_10_3(         [o canBecomeKeyView]                   ,@"Can become key view")
      ADD_BOOL_10_3(         [o canDraw]                            ,@"Can draw") 
      ADD_OBJECT_NOT_NIL(    [o enclosingScrollView]                ,@"Enclosing scroll view") 
      ADD_RECT(              [o frame]                              ,@"Frame")
      ADD_NUMBER(            [o frameRotation]                      ,@"Frame rotation")
      ADD_OBJECT_10_3(objectFromFocusRingType([o focusRingType])    ,@"Focus ring type")
      ADD_NUMBER(            [o gState]                             ,@"gState")
      ADD_NUMBER(            [o heightAdjustLimit]                  ,@"Height adjust limit") 
      ADD_BOOL(              [o isFlipped]                          ,@"Is flipped")
      ADD_BOOL_10_3(         [o isHidden]                           ,@"Is hidden") 
      ADD_BOOL_10_3(         [o isHiddenOrHasHiddenAncestor]        ,@"Is hidden or has hidden ancestor" ) 
      ADD_BOOL(              [o isOpaque]                           ,@"Is opaque")
      ADD_BOOL(              [o isRotatedFromBase]                  ,@"Is rotated from base")
      ADD_BOOL(              [o isRotatedOrScaledFromBase]          ,@"Is rotated or scaled from base")
      ADD_BOOL(              [o mouseDownCanMoveWindow]             ,@"Mouse down can move window")      
      ADD_BOOL(              [o needsDisplay]                       ,@"Needs display")
      ADD_BOOL(              [o needsPanelToBecomeKey]              ,@"Needs panel to become key")
      ADD_OBJECT(            [o nextKeyView]                        ,@"Next key view")
      ADD_OBJECT(            [o nextValidKeyView]                   ,@"Next valid key view")
      ADD_OBJECT(            [o opaqueAncestor]                     ,@"Opaque ancestor")
      ADD_BOOL(              [o postsBoundsChangedNotifications]    ,@"Posts bounds changed notifications")
      ADD_BOOL(              [o postsFrameChangedNotifications]     ,@"Posts frame changed notifications")
      ADD_OBJECTS(           [o subviews]                           ,@"Subviews")
      ADD_OBJECT(            [o previousKeyView]                    ,@"Previous key view")
      ADD_OBJECT(            [o previousValidKeyView]               ,@"Previous valid key view")
      ADD_OBJECT(            [o printJobTitle]                      ,@"Print job title")
      ADD_BOOL(              [o shouldDrawColor]                    ,@"Should draw color")
  
      if ([o superview]) [self addLabel:@"Superviews" toMatrix:m];
      view = o;
      while (view = [view superview]) [self addObject:view toMatrix:m];
      
      ADD_NUMBER(            [o tag]                                ,@"Tag")
      ADD_OBJECT(            [o toolTip]                            ,@"Tool tip")
      ADD_RECT(              [o visibleRect]                        ,@"Visible rect")
      ADD_BOOL_10_3(         [o wantsDefaultClipping]               ,@"Wants default clipping") 
      ADD_NUMBER(            [o widthAdjustLimit]                   ,@"Width adjust limit") 
      ADD_OBJECT(            [o window]                             ,@"Window")
    }
    else if ([o isKindOfClass:[NSApplication class]])
    { 
      [self addClassLabel:@"NSApplication Info" toMatrix:m];
      ADD_OBJECT_NOT_NIL(    [o applicationIconImage]               ,@"Application icon image") 
      ADD_OBJECT_NOT_NIL(    [o context]                            ,@"Context") 
      ADD_OBJECT_NOT_NIL(    [o currentEvent]                       ,@"Current event") 
      ADD_OBJECT_NOT_NIL(    [o delegate]                           ,@"Delegate") 
      ADD_BOOL(              [o isActive]                           ,@"Is active")
      ADD_BOOL(              [o isHidden]                           ,@"Is hidden")
      ADD_BOOL(              [o isRunning]                          ,@"Is running")
      ADD_OBJECT_NOT_NIL(    [o keyWindow]                          ,@"Key window") 
      ADD_OBJECT_NOT_NIL(    [o mainMenu]                           ,@"Main menu") 
      ADD_OBJECT_NOT_NIL(    [o mainWindow]                         ,@"Main window") 
      ADD_OBJECT_NOT_NIL(    [o modalWindow]                        ,@"Modal window") 
      ADD_OBJECTS(           [o orderedDocuments]                   ,@"Ordered documents") 
      ADD_OBJECTS(           [o orderedWindows]                     ,@"Ordered windows") 
      ADD_OBJECT_NOT_NIL(    [o servicesMenu]                       ,@"Services menu") 
      ADD_OBJECT_NOT_NIL(    [o servicesProvider]                   ,@"Services provider") 
      ADD_OBJECTS(           [o windows]                            ,@"Windows")       
      ADD_OBJECT_NOT_NIL(    [o windowsMenu]                        ,@"Windows menu") 
    }
    else if ([o isKindOfClass:[NSDrawer class]])
    { 
      [self addClassLabel:@"NSDrawer Info" toMatrix:m];
      ADD_SIZE(              [o contentSize]                        ,@"Content size")            
      ADD_OBJECT(            [o contentView]                        ,@"Content view") 
      ADD_OBJECT(            [o delegate]                           ,@"Delegate") 
      ADD_OBJECT(objectFromRectEdge([o edge])                       ,@"Edge")
      ADD_NUMBER(            [o leadingOffset]                      ,@"Leading offset") 
      ADD_SIZE(              [o maxContentSize]                     ,@"Max content size")
      ADD_SIZE(              [o minContentSize]                     ,@"Min content size")
      ADD_OBJECT(            [o parentWindow]                       ,@"Parent window") 
      ADD_OBJECT(objectFromRectEdge([o preferredEdge])              ,@"Preferred edge")
      ADD_OBJECT(objectFromDrawerState([o state])                   ,@"State")
      ADD_NUMBER(            [o trailingOffset]                     ,@"Trailing offset")       
    }
    else if ([o isKindOfClass:[NSWindow class]])
    { 
      [self addClassLabel:@"NSWindow Info" toMatrix:m];
      ADD_BOOL(              [o acceptsMouseMovedEvents]            ,@"Accepts mouse moved events")
      ADD_BOOL_10_3(         [o allowsToolTipsWhenApplicationIsInactive] ,@"Allows tool tips when application is inactive")
      ADD_NUMBER(            [o alphaValue]                         ,@"Alpha value") 
      ADD_BOOL(              [o areCursorRectsEnabled]              ,@"Are cursor rects enabled")
      ADD_SIZE(              [o aspectRatio]                        ,@"Aspect ratio")            
      ADD_OBJECT_NOT_NIL(    [o attachedSheet]                      ,@"Attached sheet")
      ADD_OBJECT(            [o backgroundColor]                    ,@"Background color") 
      ADD_OBJECT(objectFromBackingStoreType([o backingType])        ,@"Backing type")
      ADD_BOOL(              [o canBecomeKeyWindow]                 ,@"Can become key window")
      ADD_BOOL(              [o canBecomeMainWindow]                ,@"Can become main window")
      ADD_BOOL(              [o canHide]                            ,@"Can hide")
      ADD_BOOL(              [o canStoreColor]                      ,@"Can store color")
      ADD_OBJECTS(           [o childWindows]                       ,@"Child windows")
      ADD_SIZE_10_3(         [o contentAspectRatio]                 ,@"Content aspect ratio")
      ADD_SIZE_10_3(         [o contentMaxSize]                     ,@"Content max size")
      ADD_SIZE_10_3(         [o contentMinSize]                     ,@"Content min size")
      ADD_SIZE_10_3(         [o contentResizeIncrements]            ,@"Content resize increments")
      ADD_OBJECT(            [o contentView]                        ,@"Content view")
      ADD_OBJECT_NOT_NIL(    [o deepestScreen]                      ,@"Deepest screen")
      ADD_OBJECT(            [o defaultButtonCell]                  ,@"Default button cell")
      ADD_OBJECT(            [o delegate]                           ,@"Delegate")
      ADD_NUMBER(            [o depthLimit]                         ,@"Depth limit") 
      ADD_OBJECT(            [o deviceDescription]                  ,@"Device description")
      ADD_OBJECTS(           [o drawers]                            ,@"Drawers")
      ADD_OBJECT(            [o firstResponder]                     ,@"First responder")
      ADD_RECT(              [o frame]                              ,@"Frame")
      ADD_OBJECT_NOT_NIL(    [o frameAutosaveName]                  ,@"Frame autosave name")
      // Call to gState fails when the window in miniaturized
      //ADD_NUMBER(            [o gState]                             ,@"gState") 
      ADD_BOOL(              [o hasDynamicDepthLimit]               ,@"Has dynamic depth limit")
      ADD_BOOL(              [o hasShadow]                          ,@"Has shadow")
      ADD_BOOL(              [o hidesOnDeactivate]                  ,@"Hides on deactivate")
      ADD_BOOL(              [o ignoresMouseEvents]                 ,@"Ignores mouse events")
      ADD_OBJECT(            [o initialFirstResponder]              ,@"initial first responder")
      ADD_BOOL(              [o isAutodisplay]                      ,@"Is autodisplay")
      ADD_BOOL(              [o isDocumentEdited]                   ,@"Is document edited")
      ADD_BOOL(              [o isExcludedFromWindowsMenu]          ,@"Is exclude from windowsmenu")
      ADD_BOOL(              [o isFlushWindowDisabled]              ,@"Is flush window disabled")
      ADD_BOOL(              [o isMiniaturized]                     ,@"Is miniaturized")
      ADD_BOOL(              [o isMovableByWindowBackground]        ,@"Is movable by window background")
      ADD_BOOL(              [o isOneShot]                          ,@"Is oneShot")
      ADD_BOOL(              [o isOpaque]                           ,@"Is opaque")
      ADD_BOOL(              [o isReleasedWhenClosed]               ,@"Is released when closed")
      ADD_BOOL(              [o isSheet]                            ,@"Is sheet")
      ADD_BOOL(              [o isVisible]                          ,@"Is visible")
      ADD_BOOL(              [o isZoomed]                           ,@"Is zoomed")
      ADD_OBJECT(objectFromSelectionDirection([o keyViewSelectionDirection]), @"Key view selection direction")
      ADD_OBJECT(objectFromWindowLevel([o level])                   , @"Level")
      ADD_SIZE(              [o maxSize]                            ,@"Max size")
      ADD_SIZE(              [o minSize]                            ,@"Min size")
      ADD_OBJECT_NOT_NIL(    [o miniwindowImage]                    ,@"Miniwindow image")
      ADD_OBJECT(            [o miniwindowTitle]                    ,@"Miniwindow title")
      ADD_OBJECT_NOT_NIL(    [o parentWindow]                       ,@"Parent window")
      ADD_OBJECT_NOT_NIL(    [o representedFilename]                ,@"Represented filename")
      ADD_SIZE(              [o resizeIncrements]                   ,@"Resize increments")
      ADD_OBJECT(            [o screen]                             ,@"Screen")
      ADD_BOOL(              [o showsResizeIndicator]               ,@"Shows resize indicator")
      ADD_OBJECT(objectFromWindowMask([o styleMask])                ,@"Style mask")
      ADD_OBJECT(            [o title]                              ,@"Title")
      ADD_OBJECT_NOT_NIL(    [o toolbar]                            ,@"Toolbar")
      ADD_BOOL(              [o viewsNeedDisplay]                   ,@"Views need display")
      ADD_OBJECT_NOT_NIL(    [o windowController]                   ,@"Window controller")
      ADD_NUMBER(            [o windowNumber]                       ,@"Window number") 
      ADD_BOOL(              [o worksWhenModal]                     ,@"Works when modal")
    }
    else if ([o isKindOfClass:[NSWindowController class]])
    { 
      [self addClassLabel:@"NSWindowController Info" toMatrix:m];
      ADD_OBJECT(            [o document]                           ,@"Document")
      ADD_BOOL(              [o isWindowLoaded]                     ,@"Is window loaded")
      ADD_OBJECT(            [o owner]                              ,@"Owner")
      ADD_BOOL(              [o shouldCascadeWindows]               ,@"Should cascade windows")
      ADD_BOOL(              [o shouldCloseDocument]                ,@"Should close document")
      if ([o isWindowLoaded]) 
        ADD_OBJECT(          [o window]                             ,@"Window")
      ADD_OBJECT(            [o windowFrameAutosaveName]            ,@"Window frame autosave name")
      ADD_OBJECT(            [o windowNibName]                      ,@"Window nib name")
      ADD_OBJECT(            [o windowNibPath]                      ,@"Window nib path")
    }
    
    [self addClassLabel:@"NSResponder Info" toMatrix:m];
    ADD_BOOL(                [o acceptsFirstResponder]              ,@"Accepts first responder")
    ADD_OBJECT(              [o menu]                               ,@"Menu")
    
    NSResponder *responder;
    if ([o nextResponder]) [self addLabel:@"Next Responders" toMatrix:m];
    responder = o;
    while (responder = [responder nextResponder]) [self addObject:responder toMatrix:m indentationLevel:1];
    
    ADD_OBJECT(              [o undoManager]                        ,@"Undo Manager")
  }
  else if ([o isKindOfClass:[NSCell class]])
  {
    if ([o isKindOfClass:[NSActionCell class]])
    {
      if ([o isKindOfClass:[NSButtonCell class]])
      {
        if ([o isKindOfClass:[NSMenuItemCell class]])
        {
          if ([o isKindOfClass:[NSPopUpButtonCell class]])
          {
            [self addClassLabel:@"NSPopUpButtonCell Info" toMatrix:m];
            ADD_BOOL(          [o altersStateOfSelectedItem]    ,@"Alters state of selected item")
            ADD_OBJECT(objectFromPopUpArrowPosition([o arrowPosition]),@"Arrow position")
            ADD_BOOL(          [o autoenablesItems]             ,@"Autoenables Items")
            ADD_NUMBER(        [o indexOfSelectedItem]          ,@"Index of selected item")
            ADD_OBJECTS(       [o itemArray]                    ,@"Item array")    
            ADD_NUMBER(        [o numberOfItems]                ,@"Number of items")
            ADD_OBJECT(        [o objectValue]                  ,@"Object value")
            ADD_OBJECT(objectFromRectEdge([o preferredEdge])    ,@"Preferred edge")
            ADD_BOOL(          [o pullsDown]                    ,@"Pulls down")
            ADD_OBJECT(        [o selectedItem]                 ,@"Selected item")
            ADD_BOOL(          [o usesItemFromMenu]             ,@"Uses item from menu")
          }
        
          [self addClassLabel:@"NSMenuItemCell Info" toMatrix:m];
          if ([[o menuItem] image]) 
            ADD_NUMBER(      [o imageWidth]                   ,@"Image width")
          ADD_BOOL(          [o isHighlighted]                ,@"Is highlighted")
          if (![[[o menuItem] keyEquivalent] isEqualToString:@""])
            ADD_NUMBER(      [o keyEquivalentWidth]           ,@"Key equivalent width")
          ADD_OBJECT(        [o menuItem]                     ,@"Menu item")
          ADD_OBJECT_NOT_NIL([o menuView]                     ,@"Menu view")
          ADD_BOOL(          [o needsDisplay]                 ,@"Needs display")
          ADD_BOOL(          [o needsSizing]                  ,@"Needs sizing")
          ADD_NUMBER(        [o stateImageWidth]              ,@"State image width")
          ADD_NUMBER(        [o titleWidth]                   ,@"Title width")
        }
      
        [self addClassLabel:@"NSButtonCell Info" toMatrix:m];
        ADD_OBJECT_NOT_NIL(  [o alternateImage]                     ,@"Alternate image")
        ADD_OBJECT(          [o alternateTitle]                     ,@"Alternate title")
        ADD_OBJECT(          [o attributedAlternateTitle]           ,@"Attributed alternate title")
        ADD_OBJECT(          [o attributedTitle]                    ,@"Attributed title")
        ADD_OBJECT(objectFromBezelStyle([o bezelStyle])             ,@"Bezel style")
        ADD_OBJECT(objectFromGradientType([o gradientType])         ,@"Gradient type")
        ADD_OBJECT(objectFromCellMask([o highlightsBy])             ,@"Highlights by")
        ADD_BOOL(            [o imageDimsWhenDisabled]              ,@"Image dims when disabled")
        ADD_OBJECT(objectFromCellImagePosition([o imagePosition])   ,@"Image position")
        ADD_BOOL(            [o isTransparent]                      ,@"Is transparent")
        ADD_OBJECT_NOT_NIL(  [o keyEquivalentFont]                  ,@"Key equivalent font")
        ADD_OBJECT(objectFromKeyModifierMask([o keyEquivalentModifierMask]) , @"Key equivalent modifier mask")
        ADD_BOOL(            [o showsBorderOnlyWhileMouseInside]    ,@"Shows border only while mouse inside")                      
        ADD_OBJECT(objectFromCellMask([o showsStateBy])             ,@"Shows state by")
        ADD_OBJECT_NOT_NIL(  [o sound]                              ,@"Sound")
        ADD_OBJECT(          [o title]                              ,@"Title")
      }
      else if ([o isKindOfClass:[NSFormCell class]])
      {
        [self addClassLabel:@"NSFormCell Info" toMatrix:m];
        ADD_OBJECT(          [o attributedTitle]                    ,@"Attributed title")
        ADD_OBJECT(objectFromTextAlignment([o titleAlignment])      ,@"Title alignment")
        ADD_OBJECT(          [o titleFont]                          ,@"Title font")
        ADD_NUMBER(          [o titleWidth]                         ,@"Title width")
      }
      else if ([o isKindOfClass:[NSClassFromString(@"NSSegmentedCell") class]])
      {
        int segmentCount = [o segmentCount];
        [self addClassLabel:@"NSSegmentedCell Info" toMatrix:m];
        
        ADD_NUMBER(          segmentCount                           ,@"Segment count")
        ADD_NUMBER(          [o selectedSegment]                    ,@"Selected segment")
        ADD_OBJECT(objectFromSegmentSwitchTracking([o trackingMode]),@"Tracking mode")

        for (int i = 0; i < segmentCount; i++)
        {
          [self addLabel:@"" toMatrix:m];
          [self addLabel:[NSString stringWithFormat:@"Segment %d",i] toMatrix:m];
          
          if ([o imageForSegment:i])
          {
            [self addLabel:@"Image" toMatrix:m indentationLevel:1];
            [self addObject:[o imageForSegment:i] toMatrix:m indentationLevel:2];
          }
          
          [self addLabel:@"Is enabled" toMatrix:m indentationLevel:1];
          [self addObject:[FSBoolean booleanWithBool:[o isEnabledForSegment:i]] toMatrix:m indentationLevel:2];

          [self addLabel:@"Is selected" toMatrix:m indentationLevel:1];
          [self addObject:[FSBoolean booleanWithBool:[o isSelectedForSegment:i]] toMatrix:m indentationLevel:2];

          if ([o labelForSegment:i])
          {
            [self addLabel:@"Label" toMatrix:m indentationLevel:1];
            [self addObject:[o labelForSegment:i] toMatrix:m indentationLevel:2];
          }
          
          if ([o menuForSegment:i])
          {
            [self addLabel:@"Menu" toMatrix:m indentationLevel:1];
            [self addObject:[o menuForSegment:i] toMatrix:m indentationLevel:2];
          }
          
          [self addLabel:@"Tag" toMatrix:m indentationLevel:1];
          [self addObject:[Number numberWithDouble:[o tagForSegment:i]] toMatrix:m indentationLevel:2];
          
          if ([o toolTipForSegment:i])
          {
            [self addLabel:@"Tool tip" toMatrix:m indentationLevel:1];
            [self addObject:[o toolTipForSegment:i] toMatrix:m indentationLevel:2];
          }
          
          if ([o widthForSegment:i] != 0)
          {
            [self addLabel:@"Width" toMatrix:m indentationLevel:1];
            [self addObject:[Number numberWithDouble:[o widthForSegment:i]] toMatrix:m indentationLevel:2];
          }
        }
      }
      else if ([o isKindOfClass:[NSSliderCell class]])
      {
        [self addClassLabel:@"NSSliderCell Info" toMatrix:m];
        ADD_BOOL(          [o allowsTickMarkValuesOnly]           ,@"Allows tick mark values only")   
        ADD_NUMBER(        [o altIncrementValue]                  ,@"Alt increment value")  
        ADD_NUMBER(        [(NSSliderCell*)o isVertical]          ,@"Is vertical")  
        ADD_NUMBER(        [o knobThickness]                      ,@"Knob thickness")  
        ADD_NUMBER(        [o maxValue]                           ,@"Max value")  
        ADD_NUMBER(        [o minValue]                           ,@"Min value")  
        ADD_NUMBER(        [o numberOfTickMarks]                  ,@"Number of tick marks")
        ADD_OBJECT_10_3(objectFromSliderType([o sliderType])      ,@"Slider type")
        ADD_OBJECT(objectFromTickMarkPosition([o tickMarkPosition], [(NSSliderCell*)o isVertical] == 1),@"Tick mark position")
        ADD_RECT(          [o trackRect]                          ,@"Track rect")
      }
      else if ([o isKindOfClass:[NSStepperCell class]])
      {
        [self addClassLabel:@"NSStepperCell Info" toMatrix:m];
        ADD_BOOL(          [o autorepeat]                         ,@"Autorepeat")   
        ADD_NUMBER(        [o increment]                          ,@"Increment")  
        ADD_NUMBER(        [o maxValue]                           ,@"Max value")  
        ADD_NUMBER(        [o minValue]                           ,@"Min value")  
        ADD_BOOL(          [o valueWraps]                         ,@"Value wraps")           
      }
      else if ([o isKindOfClass:[NSTextFieldCell class]])
      {
        if ([o isKindOfClass:[NSComboBoxCell class]]) 
        {
          [self addClassLabel:@"NSComboBoxCell Info" toMatrix:m];
          if ([o usesDataSource]) ADD_OBJECT([o dataSource]       ,@"Data source")         
          ADD_BOOL(        [o hasVerticalScroller]                ,@"Has vertical scroller")
          ADD_NUMBER(      [o indexOfSelectedItem]                ,@"Index of selected item")  
          ADD_SIZE(        [o intercellSpacing]                   ,@"Intercell spacing")
          ADD_BOOL_10_3(   [o isButtonBordered]                   ,@"Is button bordered")
          ADD_NUMBER(      [o itemHeight]                         ,@"Item height")  
          ADD_NUMBER(      [o numberOfItems]                      ,@"Number of items")  
          ADD_NUMBER(      [o numberOfVisibleItems]               ,@"Number of visible items")  
          if (![o usesDataSource] && [o indexOfSelectedItem] != -1) 
            ADD_OBJECT(    [o objectValueOfSelectedItem]          ,@"Object value of selected item")         
          if (![o usesDataSource]) 
            ADD_OBJECTS(   [o objectValues]                       ,@"Object values")    
          ADD_BOOL(        [o usesDataSource]                     ,@"Uses data source")                   
        }
        else if ([o isKindOfClass:NSClassFromString(@"NSSearchFieldCell")])
        {
          [self addClassLabel:@"NSSearchFieldCell Info" toMatrix:m];
          ADD_OBJECT(      [o cancelButtonCell]                   ,@"Cancel button cell")         
          ADD_NUMBER(      [o maximumRecents]                     ,@"Maximum recents")          
          ADD_OBJECTS(     [o recentSearches]                     ,@"Recent searches")    
          ADD_OBJECT_NOT_NIL([o recentsAutosaveName]              ,@"Recents autosave name")   
          ADD_OBJECT(      [o searchButtonCell]                   ,@"Search button cell")         
          ADD_OBJECT_NOT_NIL([o searchMenuTemplate]               ,@"Search menu template")   
          ADD_BOOL(        [o sendsWholeSearchString]             ,@"Sends whole search string")
        }
                  
        [self addClassLabel:@"NSTextFieldCell Info" toMatrix:m];
        ADD_OBJECT(        [o backgroundColor]                    ,@"Background color")         
        ADD_OBJECT(objectFromTextFieldBezelStyle([o bezelStyle])  ,@"Bezel style")
        ADD_BOOL(          [o drawsBackground]                    ,@"Draws background")
        ADD_OBJECT_NOT_NIL_10_3([o placeholderAttributedString]   ,@"Placeholder attributed string")
        ADD_OBJECT_NOT_NIL_10_3([o placeholderString]             ,@"Placeholder string")        
        ADD_OBJECT(        [o textColor]                          ,@"Text color")
      }
    }  
    else if ([o isKindOfClass:[NSBrowserCell class]])
    {
      [self addClassLabel:@"NSBrowserCell Info" toMatrix:m];
      ADD_OBJECT_NOT_NIL(    [o alternateImage]                     ,@"Alternate image")
      ADD_BOOL(              [o isLeaf]                             ,@"Is leaf")
      ADD_BOOL(              [o isLoaded]                           ,@"Is loaded")      
    }
    else if ([o isKindOfClass:[NSImageCell class]])
    {
      [self addClassLabel:@"NSImageCell Info" toMatrix:m];
      ADD_OBJECT(objectFromImageAlignment([o imageAlignment])       ,@"Image alignment")
      ADD_OBJECT(objectFromImageScaling([o imageScaling])           ,@"Image scaling")
    }
    else if ([o isKindOfClass:[NSTextAttachmentCell class]])
    {
      [self addClassLabel:@"NSTextAttachmentCell Info" toMatrix:m];
      ADD_OBJECT(            [o attachment]                         ,@"Attachment")
      ADD_POINT(             [o cellBaselineOffset]                 ,@"Cell baseline offset")
      ADD_SIZE(              [o cellSize]                           ,@"Cell size")
      ADD_BOOL(              [o wantsToTrackMouse]                  ,@"Wants to track mouse")      
    }

    [self addClassLabel:@"NSCell Info" toMatrix:m];
    ADD_BOOL(                [o acceptsFirstResponder]              ,@"Accepts first responder")
    ADD_SEL_NOT_NULL(        [o action]                             ,@"Action")
    ADD_OBJECT(              objectFromTextAlignment([o alignment]) ,@"Alignment")
    ADD_BOOL(                [o allowsEditingTextAttributes]        ,@"Allows editing text attributes")
    ADD_BOOL(                [o allowsMixedState]                   ,@"Allows mixed state")
    //ADD_OBJECT(              [o attributedStringValue]              ,@"Attributed string value")
    ADD_SIZE(                [o cellSize]                           ,@"Cell size")
    ADD_OBJECT(objectFromControlSize([o controlSize])               ,@"Control size")
    ADD_OBJECT(objectFromControlTint([o controlTint])               ,@"Control tint")
    ADD_OBJECT_NOT_NIL(      [o controlView]                        ,@"Control view")
    ADD_OBJECT(objectFromCellEntryType([o entryType])               ,@"Entry type")
    ADD_OBJECT_10_3(objectFromFocusRingType([o focusRingType])      ,@"Focus ring type")
    ADD_OBJECT(              [o font]                               ,@"Font")
    ADD_OBJECT_NOT_NIL(      [o formatter]                          ,@"Formatter")
    ADD_OBJECT_NOT_NIL(      [o image]                              ,@"Image")
    if ([(NSCell *)o type] == NSTextCellType) ADD_BOOL([o importsGraphics]    ,@"Imports graphics")
    ADD_BOOL(                [o isBezeled]                          ,@"Is bezeled")
    ADD_BOOL(                [o isBordered]                         ,@"Is bordered")
    ADD_BOOL(                [o isContinuous]                       ,@"Is continuous")
    ADD_BOOL(                [o isEditable]                         ,@"Is editable")
    ADD_BOOL(                [o isEnabled]                          ,@"Is enabled") 
    ADD_BOOL(                [o isHighlighted]                      ,@"Is highlighted")
    ADD_BOOL(                [o isOpaque]                           ,@"Is opaque")
    ADD_BOOL(                [o isScrollable]                       ,@"Is scrollable")
    ADD_BOOL(                [o isSelectable]                       ,@"Is selectable")
    if ([[o keyEquivalent] length]!=0) ADD_OBJECT([o keyEquivalent] ,@"Key equivalent")
    ADD_OBJECT_NOT_NIL(      [o menu]                               ,@"Menu")
    if ([[o mnemonic] length]!=0) ADD_OBJECT([o mnemonic]           ,@"Mnemonic")
    if ([o mnemonicLocation]!=NSNotFound) ADD_NUMBER([o mnemonicLocation],@"Mnemonic location")
    ADD_OBJECT(objectFromCellStateValue([o nextState])              ,@"Next state") 
    //ADD_OBJECT(              [o objectValue]                        ,@"Object value")
    ADD_BOOL(                [o refusesFirstResponder]              ,@"Refuses first responder")
    ADD_OBJECT_NOT_NIL(      [o representedObject]                  ,@"Represented object")
    ADD_BOOL(                [o sendsActionOnEndEditing]            ,@"Sends action on end editing")
    ADD_BOOL(                [o showsFirstResponder]                ,@"Shows first responder")
    ADD_OBJECT(objectFromCellStateValue([o state])                  ,@"State") 
    ADD_NUMBER(              [o tag]                                ,@"Tag")
    ADD_OBJECT_NOT_NIL(      [o target]                             ,@"Target")
    ADD_OBJECT(objectFromCellType([(NSCell *)o type])               ,@"Type")
    ADD_BOOL(                [o wraps]                              ,@"Wraps")    
  }
  else if ([o isKindOfClass:NSClassFromString(@"NSController")])
  {
    if ([o isKindOfClass:NSClassFromString(@"NSObjectController")])
    {
      if ([o isKindOfClass:NSClassFromString(@"NSArrayController")])
      {
        [self addClassLabel:@"NSArrayController Info" toMatrix:m];
        ADD_BOOL(            [o avoidsEmptySelection]               ,@"Avoids empty selection")
        ADD_BOOL(            [o canInsert]                          ,@"Can insert")
        ADD_BOOL(            [o canSelectNext]                      ,@"Can select next")
        ADD_BOOL(            [o canSelectPrevious]                  ,@"Can select previous")
        ADD_BOOL(            [o preservesSelection]                 ,@"Preserves selection")
        if ([o selectionIndex] != NSNotFound) ADD_NUMBER([o selectionIndex], @"Selection index")
        ADD_OBJECT(          [o selectionIndexes]                   ,@"Selection indexes")
        ADD_BOOL(            [o selectsInsertedObjects]             ,@"Selects inserted Objects")
        ADD_OBJECTS(         [o sortDescriptors]                    ,@"Sort descriptors")
      }
    
      [self addClassLabel:@"NSObjectController Info" toMatrix:m];
      ADD_BOOL(              [o automaticallyPreparesContent]       ,@"Automatically prepares content")
      ADD_BOOL(              [o canAdd]                             ,@"Can add")
      ADD_BOOL(              [o canRemove]                          ,@"Can remove")
      ADD_OBJECT(            [o content]                            ,@"Content")
      ADD_BOOL(              [o isEditable]                         ,@"Is editable")
      ADD_OBJECT(            [o objectClass]                        ,@"Object class")
      ADD_OBJECTS(           [o selectedObjects]                    ,@"Selected objects")
      ADD_OBJECT(            [o selection]                          ,@"Selection")
    }
    else if ([o isKindOfClass:NSClassFromString(@"NSUserDefaultsController")])
    {
      [self addClassLabel:@"NSUserDefaultsController Info" toMatrix:m];
      ADD_BOOL(              [o appliesImmediately]                 ,@"Applies immediately")
      ADD_OBJECT(            [o defaults]                           ,@"Defaults")
      ADD_OBJECT(            [o initialValues]                      ,@"Initial values")
      ADD_OBJECT(            [o values]                             ,@"Values")
    }

    [self addClassLabel:@"NSController Info" toMatrix:m];
    ADD_BOOL(                [o isEditing]                          ,@"Is editing")
  }
  else if ([o isKindOfClass:[NSEvent class]])
  {
    NSEventType type = [(NSEvent *)o type];
    [self addClassLabel:@"NSEvent Info" toMatrix:m];
    
    if (type == NSLeftMouseDown || type == NSLeftMouseUp || type == NSRightMouseDown || type == NSRightMouseUp || type == NSOtherMouseDown || type == NSOtherMouseUp)
      ADD_NUMBER(            [o buttonNumber]                       ,@"Button number")
    if (type == NSKeyDown || type == NSKeyUp)
    {
      ADD_OBJECT(            [(NSEvent *)o characters]              ,@"Characters")
      ADD_OBJECT(            [o charactersIgnoringModifiers]        ,@"Characters ignoring modifiers")
    }
    if (type == NSLeftMouseDown || type == NSLeftMouseUp || type == NSRightMouseDown || type == NSRightMouseUp || type == NSOtherMouseDown || type == NSOtherMouseUp)
      ADD_NUMBER(            [o clickCount]                         ,@"Click count")
    if (type == NSAppKitDefined || type == NSSystemDefined || type == NSApplicationDefined)
    {
      ADD_NUMBER(            [o data1]                              ,@"Data1")
      ADD_NUMBER(            [o data2]                              ,@"Data2")
    }
    if (type == NSMouseMoved || type == NSLeftMouseDragged || type == NSRightMouseDragged || type == NSOtherMouseDragged || type == NSScrollWheel)
    {
      ADD_NUMBER(            [o deltaX]                              ,@"Delta x")
      ADD_NUMBER(            [o deltaY]                              ,@"Delta y")
      ADD_NUMBER(            [o deltaZ]                              ,@"Delta z")
    }
    if (type == NSLeftMouseDown || type == NSLeftMouseUp || type == NSRightMouseDown || type == NSRightMouseUp || type == NSOtherMouseDown || type == NSOtherMouseUp || type == NSMouseMoved || type == NSLeftMouseDragged || type == NSRightMouseDragged || type == NSOtherMouseDragged || type == NSScrollWheel || type == NSMouseEntered || type == NSMouseExited || type == NSCursorUpdate)
      ADD_NUMBER(            [o eventNumber]                         ,@"Event number")
    if (type == NSKeyDown)
      ADD_BOOL(              [o isARepeat]                           ,@"Is a repeat")
    if (type == NSKeyDown || type == NSKeyUp)
      ADD_NUMBER(            [o keyCode]                             ,@"Key code") 
    if (type == NSLeftMouseDown || type == NSLeftMouseUp || type == NSRightMouseDown || type == NSRightMouseUp || type == NSOtherMouseDown || type == NSOtherMouseUp || type == NSMouseMoved || type == NSLeftMouseDragged || type == NSRightMouseDragged || type == NSOtherMouseDragged || type == NSScrollWheel)
      ADD_POINT(             [o locationInWindow]                    ,@"Location in window")
    ADD_OBJECT(objectFromKeyModifierMask([o modifierFlags])          ,@"Modifier flags")
    if (type == NSLeftMouseDown || type == NSLeftMouseUp || type == NSRightMouseDown || type == NSRightMouseUp || type == NSOtherMouseDown || type == NSOtherMouseUp || type == NSMouseMoved || type == NSLeftMouseDragged || type == NSRightMouseDragged || type == NSOtherMouseDragged || type == NSScrollWheel)
      ADD_NUMBER(            [o pressure]                            ,@"Pressure")
    if (type == NSAppKitDefined || type == NSSystemDefined || type == NSApplicationDefined)
      ADD_NUMBER(            [o subtype]                              ,@"Subtype")
    ADD_NUMBER(              [o timestamp]                            ,@"Timestamp")
    if (type == NSMouseEntered || type == NSMouseExited || type == NSCursorUpdate)
      ADD_NUMBER(            [o trackingNumber]                       ,@"Tracking number")
    ADD_OBJECT(objectFromEventType([(NSEvent *)o type])               ,@"Type")
    if (type == NSMouseEntered || type == NSMouseExited || type == NSCursorUpdate)
      ADD_POINTER(           [o userData]                             ,@"User data")
    if (type != NSPeriodic)
      ADD_OBJECT(            [o window]                               ,@"Window")
  }
  else if ([o isKindOfClass:[NSMenuItem class]])
  {
    [self addClassLabel:@"NSMenuItem Info" toMatrix:m];
    
    ADD_SEL(                 [o action]                             ,@"Action")
    ADD_OBJECT_NOT_NIL_10_3( [o attributedTitle]                    ,@"Attributed title")
    ADD_BOOL(                [o hasSubmenu]                         ,@"Has submenu")
    ADD_OBJECT_NOT_NIL(      [o image]                              ,@"Image")
    ADD_NUMBER_10_3(         [o indentationLevel]                   ,@"Indentation level")
    ADD_BOOL_10_3(           [o isAlternate]                        ,@"Is alternate")
    ADD_BOOL(                [o isEnabled]                          ,@"Is enabled")
    ADD_BOOL(                [o isSeparatorItem]                    ,@"Is separatorItem")
    ADD_OBJECT(              [o keyEquivalent]                      ,@"Key equivalent")
    ADD_OBJECT(objectFromKeyModifierMask([o keyEquivalentModifierMask]),@"Key equivalent modifier mask")
    ADD_OBJECT(              [o menu]                               ,@"Menu")
    ADD_OBJECT_NOT_NIL(      [o mixedStateImage]                    ,@"Mixed state image")
    ADD_OBJECT_NOT_NIL(      [o offStateImage]                      ,@"Off state image")
    ADD_OBJECT_NOT_NIL(      [o onStateImage]                       ,@"On state image")
    ADD_OBJECT_NOT_NIL(      [o representedObject]                  ,@"Represented object")
    ADD_OBJECT(objectFromCellStateValue([o state])                  ,@"State") 
    ADD_OBJECT_NOT_NIL(      [o submenu]                            ,@"Submenu")
    ADD_NUMBER(              [o tag]                                ,@"Tag")
    ADD_OBJECT_NOT_NIL(      [o target]                             ,@"Target")
    ADD_OBJECT(              [o title]                              ,@"Title")
    ADD_OBJECT_NOT_NIL_10_3( [o toolTip]                            ,@"Tool tip")
    ADD_OBJECT(              [o userKeyEquivalent]                  ,@"User key equivalent")
  }
  else if ([o isKindOfClass:[NSMenu class]])
  {
    [self addClassLabel:@"NSMenu Info" toMatrix:m];
    ADD_OBJECT_NOT_NIL(      [o attachedMenu]                       ,@"Attached menu")
    ADD_BOOL(                [o autoenablesItems]                   ,@"Autoenables Items")
    ADD_OBJECT_NOT_NIL_10_3( [o delegate]                           ,@"Delegate")    
    ADD_BOOL(                [o isAttached]                         ,@"Is attached")
    ADD_BOOL(                [o isTornOff]                          ,@"Is torn off")
    ADD_OBJECTS(             [o itemArray]                          ,@"Items" )
    ADD_BOOL(                [o menuChangedMessagesEnabled]         ,@"Menu changed messages enabled")
    ADD_OBJECT_NOT_NIL(      [o supermenu]                          ,@"Supermenu")
    ADD_OBJECT(              [o title]                              ,@"Title")    
  }
  else if ([o isKindOfClass:[NSTabViewItem class]])
  {
    [self addClassLabel:@"NSTabViewItem Info" toMatrix:m];
    ADD_OBJECT(              [o color]                              ,@"Color")
    ADD_OBJECT(              [(NSTabViewItem *)o identifier]        ,@"Identifier")    
    ADD_OBJECT(              [o initialFirstResponder]              ,@"Initial first responder")
    ADD_OBJECT(              [o label]                              ,@"Label")
    ADD_OBJECT(              objectFromTabState([o tabState])       ,@"Tab state")
    ADD_OBJECT(              [o tabView]                            ,@"Parent tab view")
    ADD_OBJECT(              [o view]                               ,@"View")
  }
  else if ([o isKindOfClass:[NSTextContainer class]])
  {
    [self addClassLabel:@"NSTextContainer Info" toMatrix:m];
    ADD_SIZE(                [o containerSize]                      ,@"Container size")
    ADD_BOOL(                [o heightTracksTextView]               ,@"Height tracks text view")
    ADD_BOOL(                [o isSimpleRectangularTextContainer]   ,@"Is simple rectangular text container")
    ADD_OBJECT_NOT_NIL(      [o layoutManager]                      ,@"Layout manager")    
    ADD_NUMBER(              [o lineFragmentPadding]                ,@"Line fragment padding")
    ADD_OBJECT_NOT_NIL(      [o textView]                           ,@"Text view")    
    ADD_BOOL(                [o widthTracksTextView]                ,@"Width tracks text view")
  }  
  else if ([o isKindOfClass:[NSToolbar class]])
  {
    [self addClassLabel:@"NSToolbar Info" toMatrix:m];
    ADD_BOOL(                [o allowsUserCustomization]            ,@"Allows user customization")
    ADD_BOOL(                [o autosavesConfiguration]             ,@"Autosaves configuration")
    ADD_OBJECT(              [o configurationDictionary]            ,@"Configuration dictionary")
    ADD_BOOL(                [o customizationPaletteIsRunning]      ,@"Customization palette is running")
    ADD_OBJECT(              [o delegate]                           ,@"Delegate")
    ADD_OBJECT(objectFromToolbarDisplayMode([o displayMode])        ,@"Display mode")
    ADD_OBJECT(              [(NSToolbar*)o identifier]             ,@"Identifier")
    ADD_BOOL(                [o isVisible]                          ,@"Is visible")
    ADD_OBJECTS(             [o items]                              ,@"Items")
    ADD_OBJECT_NOT_NIL_10_3( [o selectedItemIdentifier]             ,@"Selected item identifier")
    ADD_OBJECT(objectFromToolbarSizeMode([o sizeMode])              ,@"Identifier")
    ADD_OBJECTS(             [o visibleItems]                       ,@"Visible items")
  }
  else if ([o isKindOfClass:[NSToolbarItem class]])
  {
    [self addClassLabel:@"NSToolbarItem Info" toMatrix:m];
    ADD_SEL(                 [o action]                             ,@"Action")
    ADD_BOOL(                [o allowsDuplicatesInToolbar]          ,@"Allows duplicates in toolbar")
    ADD_OBJECT(              [o image]                              ,@"Image")
    ADD_BOOL(                [o isEnabled]                          ,@"Is enabled")
    ADD_OBJECT(              [(NSToolbarItem*)o itemIdentifier]     ,@"Item identifier")
    ADD_OBJECT(              [o label]                              ,@"Label")
    ADD_SIZE(                [o maxSize]                            ,@"Max size")
    ADD_OBJECT_NOT_NIL(      [o menuFormRepresentation]             ,@"Menu form representation")
    ADD_SIZE(                [o minSize]                            ,@"Min size")
    ADD_OBJECT(              [o paletteLabel]                       ,@"Palette label")
    ADD_NUMBER(              [o tag]                                ,@"Tag")        
    ADD_OBJECT(              [o target]                             ,@"Target")
    ADD_OBJECT(              [o toolbar]                            ,@"Toolbar")
    ADD_OBJECT_NOT_NIL(      [o toolTip]                            ,@"Tool tip")    
    ADD_OBJECT(              [o view]                               ,@"View")
  }
  else if ([o isKindOfClass:[NSTableColumn class]])
  {
    [self addClassLabel:@"NSTableColumn Info" toMatrix:m];
    ADD_OBJECT(              [o dataCell]                           ,@"Data cell")  
    ADD_OBJECT(              [o headerCell]                         ,@"Header cell")  
    ADD_OBJECT(              [(NSTableColumn*)o identifier]         ,@"Identifier")
    ADD_BOOL(                [o isEditable]                         ,@"Is editable")
    ADD_BOOL(                [o isResizable]                        ,@"Is resizable")
    ADD_NUMBER(              [o maxWidth]                           ,@"Max width")        
    ADD_NUMBER(              [o minWidth]                           ,@"Min width")        
    ADD_OBJECT_NOT_NIL_10_3( [o sortDescriptorPrototype]            ,@"Sort descriptor prototype")  
    ADD_OBJECT(              [o tableView]                          ,@"Table view")
    ADD_NUMBER(              [o width]                              ,@"Width")        
  }    

  [m sizeToCells];     // The NSMatrix doc advise to do that after calling addRow
  [m setNeedsDisplay]; // The NSMatrix doc advise to do that after calling addRow
}

- (void)filter
{
  int i,j,columnCount,rowCount;
  Class NSAttributedStringClass = [NSAttributedString class];
  
  for (i = 1, columnCount = [browser lastColumn]+1; i < columnCount; i+=2)
  {
    NSMatrix *methodMatrix = [browser matrixInColumn:i];
    //NSMatrix *objectMatrix = [browser matrixInColumn:i-1];
    int selectedRow = [methodMatrix selectedRow];
    NSString *classNameForSelectedRow = nil; // init to nil to avoid a compiler warning
    NSString *selectedMethod = nil;          // init to nil to avoid a compiler warning
    
    if (selectedRow != -1)
    {
      selectedMethod = [[methodMatrix cellAtRow:selectedRow column:0] stringValue];
      for (j = selectedRow-1; ![[[methodMatrix cellAtRow:j column:0] objectValue] isKindOfClass:NSAttributedStringClass] ; j--);
      classNameForSelectedRow = [[methodMatrix cellAtRow:j column:0] stringValue];
    } 
    
    /*id object = [[browser loadedCellAtRow:0 column:i-1] representedObject];
    [object retain];    
    for (j = [objectMatrix numberOfRows]-1; j >= 0; j--) [objectMatrix removeRow:j];
    [self fillMatrix:objectMatrix withObject:object];
    [object release];*/
    
    for (j = [methodMatrix numberOfRows]-1; j >= 0; j--) [methodMatrix removeRow:j];
    [self fillMatrix:methodMatrix withMethodsForObject:[[browser selectedCellInColumn:i-1] representedObject]];
    
    if (selectedRow != -1)
    {
      for (j = 0, rowCount = [methodMatrix numberOfRows]; j < rowCount; j++)
      {
        NSCell *cell = [methodMatrix cellAtRow:j column:0];
        if ([[cell objectValue] isKindOfClass:NSAttributedStringClass] &&  [[cell stringValue] isEqualToString:classNameForSelectedRow])
        { 
          j++;
          break;
        }  
      }
      while (1)
      { 
        if (j == rowCount)
        { 
          [methodMatrix addRow];
          [[methodMatrix cellAtRow:j column:0] setStringValue:selectedMethod];
          [methodMatrix selectCellAtRow:j column:0];
          [methodMatrix scrollCellToVisibleAtRow:j column:0];
          break;
        }
        else if ([[[methodMatrix cellAtRow:j column:0] stringValue] compare:selectedMethod] == NSOrderedSame && ![[[methodMatrix cellAtRow:j column:0] objectValue] isKindOfClass:NSAttributedStringClass])
        {
          [methodMatrix selectCellAtRow:j column:0];
          [methodMatrix scrollCellToVisibleAtRow:j column:0];
          break;
        }
        else if ([[[methodMatrix cellAtRow:j column:0] stringValue] compare:selectedMethod] == NSOrderedDescending) 
        {
          [methodMatrix insertRow:j];
          [[methodMatrix cellAtRow:j column:0] setStringValue:selectedMethod];
          [methodMatrix selectCellAtRow:j column:0];
          [methodMatrix scrollCellToVisibleAtRow:j column:0];
          break;
        }
        else if ([[[methodMatrix cellAtRow:j column:0] objectValue] isKindOfClass:NSAttributedStringClass])
        {
          // Insert at j-1 to preserve the empty line before the line with the class name.
          [methodMatrix insertRow:j-1];
          [[methodMatrix cellAtRow:j-1 column:0] setStringValue:selectedMethod];
          [methodMatrix selectCellAtRow:j-1 column:0];
          [methodMatrix scrollCellToVisibleAtRow:j-1 column:0];
          break;
        }
        j++;
      }
    }     
  } 
  [browser tile];
} 

- (void)filterAction:(id)sender
{  
  [self setMethodFilterString:[sender stringValue]];
  [self filter];
}

- (id)initWithFrame:(NSRect)frameRect
{
  if ([super initWithFrame:frameRect])
  { 
    float baseWidth  = NSWidth([self bounds]);
    float baseHeight = NSHeight([self bounds]);
    float fontSize;
    // NSButton *kvButton; // jg added
  
    fontSize = systemFontSize();
  
    //browser = [[NSBrowser alloc] initWithFrame:NSMakeRect(0,20,baseWidth,baseHeight-57)]; 
    browser = [[NSBrowser alloc] initWithFrame:NSMakeRect(0,fontSize+8,baseWidth,baseHeight-(fontSize+8))];
    //[browser setMatrixClass:[BigBrowserMatrix class]];
    [browser setCellClass:[BigBrowserCell class]];
    [browser setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];  
    [browser setHasHorizontalScroller:YES];
    [browser setMinColumnWidth:135+(fontSize*6)];
    [browser setTakesTitleFromPreviousColumn:NO];
    [browser setTitled:NO];
    [browser setTarget:self];
    [browser setDoubleAction:@selector(doubleClickAction:)];
    [[browser cellPrototype] setFont:[NSFont systemFontOfSize:fontSize]];
    [browser setDelegate:self];
    
    if ([browser respondsToSelector:@selector(setColumnResizingType:)]) [browser setColumnResizingType:2];
    
    if ([browser respondsToSelector:@selector(setColumnsAutosaveName:)]) [browser setColumnsAutosaveName:@"Object browser columns autosave configuration"];

    //statusBar = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,baseWidth,20)];
    statusBar = [[NSTextField alloc] initWithFrame:NSMakeRect(0,1,baseWidth,fontSize+4)];
    
    [statusBar setSelectable:NO];
    [statusBar setEditable:NO];
    [statusBar setBackgroundColor:[NSColor windowBackgroundColor]];
    [statusBar setBezeled:NO];
    [statusBar setAutoresizingMask:NSViewWidthSizable | NSViewMaxYMargin];
    [statusBar setFont:[NSFont systemFontOfSize:fontSize]];
    
    [self addSubview:browser];  
    [self addSubview:statusBar];

    isBrowsingWorkspace = YES;
    
    methodFilterString = @"";
    
    matrixes = [[NSMutableSet alloc] init];
    
    return self;
  }
  return nil;
}

- (void) inspectObjectAction:(id)sender
{
  inspect([self selectedObject], interpreter, nil);
}

- (void)menuWillSendAction:(NSNotification *)notification;
{
  NSMenuItem *item = [[notification userInfo] objectForKey: @"MenuItem"];
  selectedView = [item retain];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
  int row, column;
  NSPoint baseMouseLocation = [[self window]  convertScreenToBase:[NSEvent mouseLocation]];
  NSView *view = [self hitTest:[[self superview] convertPoint:baseMouseLocation fromView:nil]];

  if ([view isKindOfClass:[NSMatrix class]] && [(NSMatrix *)view getRow:&row column:&column forPoint:[view convertPoint:baseMouseLocation fromView:nil]])
  {
    [statusBar setStringValue:[[(NSMatrix *)view cellAtRow:row column:column] stringValue]];
  }
  else [statusBar setStringValue:@""];
    
  [super mouseMoved:theEvent];
}

- (void) nameObjectAction:(id)sender
{
  float fontSize = systemFontSize(); 
  int baseWidth  = 230;
  int baseHeight = 15+fontSize+9+60;
  NSWindow *nameSheet;
  NSTextField *field;
  NSButton *nameButton;
  NSButton *cancelButton;

  if ([self selectedObject] == nil) 
  {
    NSBeep();
    return;
  }
  
  nameSheet = [[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,baseWidth,baseHeight) styleMask:NSTitledWindowMask|NSClosableWindowMask backing:NSBackingStoreBuffered defer:NO];
  [nameSheet setMinSize:NSMakeSize(130,80)];
   
  field = [[[NSTextField alloc] initWithFrame:NSMakeRect(20,baseHeight-(15+fontSize+9),baseWidth-40,fontSize+10)] autorelease];
  [field setFont:[NSFont systemFontOfSize:fontSize]];
  [field setTarget:self];
  [field setAction:@selector(okNameSheetAction:)];
  [field setFormatter:[[[FSIdentifierFormatter alloc] init] autorelease]];
  
  [[nameSheet contentView] addSubview:field];

  nameButton = [[[NSButton alloc] initWithFrame:NSMakeRect(baseWidth/2,13,95,30)] autorelease];
  [nameButton setBezelStyle:1];
  [nameButton setTitle:@"Name"];   
  [nameButton setAction:@selector(performClick:)]; // Will make field to send its action message
  [nameButton setTarget:field];
  [nameButton setKeyEquivalent:@"\r"];
  [[nameSheet contentView] addSubview:nameButton];
      
  cancelButton = [[[NSButton alloc] initWithFrame:NSMakeRect(baseWidth/2-95,13,95,30)] autorelease];
  [cancelButton setBezelStyle:1];
  [cancelButton setTitle:@"Cancel"];   
  [cancelButton setAction:@selector(cancelNameSheetAction:)];
  [cancelButton setTarget:self];
  [[nameSheet contentView] addSubview:cancelButton];
   
  [NSApp beginSheet:nameSheet modalForWindow:[self window] modalDelegate:self didEndSelector:NULL contextInfo:NULL];
  [field selectText:nil];
}

-(void)okNameSheetAction:(id)sender
{
  if ([[sender stringValue] length] == 0)
  {
    [NSApp endSheet:[sender window]];
    [[sender window] close];
  }
    else if ([Compiler isValidIdentifier:[sender stringValue]])
  {
    [interpreter setObject:[self selectedObject] forIdentifier:[sender stringValue]];
    [NSApp endSheet:[sender window]];
    [[sender window] close];
  }
  else
  {
    // don't close the sheet
    NSRunAlertPanel(@"Malformed Name", @"Sorry, an F-Script identifier must start with an alphabetic, non-accentuated, character or with an underscore (i.e. \"_\") and must only contains non-accentuated alphanumeric characters and underscores", @"OK", nil, nil,nil);
    [[sender window] makeFirstResponder:sender];
  }  
}

-(id) selectedObject 
{
  int selectedColumn;
  
  if ([browser lastColumn] == 0) return nil;
  else
  {
    selectedColumn = [browser selectedColumn];
  
    if (((float)selectedColumn)/2 != (int)(selectedColumn/2) )
      return [[browser selectedCellInColumn:selectedColumn-1] representedObject];
    else  
      return [[browser selectedCellInColumn:selectedColumn] representedObject];
  }          
}

- (void) selectMethodNamed:(NSString *)methodName
{
  int methodColumn, i, count;
  NSArray *methodCells;
  
  if ( ((float)[browser lastColumn] )/2 == (int)([browser lastColumn] /2) )
    methodColumn = [browser lastColumn]-1;
  else
    methodColumn = [browser lastColumn];

  methodCells  = [[browser matrixInColumn:methodColumn] cells];

  i = 0;
  count = [methodCells count];
  
  if (count == 0 && [methodName isEqualToString:@"applyBlock:"]) // may happend if the selected object is a proxy to an object in an app not linked against the F-Script framework.
  {
    NSMatrix *matrix = [browser matrixInColumn:methodColumn];
    
    [matrix addRow];
    [[matrix cellAtRow:0 column:0] setStringValue:@"applyBlock:"];
    [[matrix cellAtRow:0 column:0] setEnabled:NO];
    count = 1;
    methodCells  = [[browser matrixInColumn:methodColumn] cells];
  }
  
  while (i < count && ![[[methodCells objectAtIndex:i] stringValue] isEqualToString:methodName]) i++;
  
  if (i < count) 
    [browser selectRow:i inColumn:methodColumn];
  else
  {
    NSString *oldMethodFilterString = methodFilterString;
    methodFilterString = @"";
    [self filter];
    [self selectMethodNamed:methodName];
    methodFilterString = oldMethodFilterString;
    [self filter];
  }
}

- (void) selectView:(id)dummy
{
  // Part of this code borowed from Nicholas Riley's F-Script Anywhere
  
  NSImage    *image = [[[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForImageResource:@"SelectViewCursor"]] autorelease];
  NSCursor   *cursor = [[NSCursor alloc] initWithImage:image hotSpot:NSMakePoint(8,8)];
  NSEvent    *event;
  NSView     *view;
  //NSMenu     *viewHierarchyMenu;
  //NSMenuItem *item;
      
  [cursor push];
  
  selectedView = nil;
  
  [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(menuWillSendAction:) name: NSMenuWillSendActionNotification object: nil];
  
  do event = [NSApp nextEventMatchingMask:~0 untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES];
  while ([event type] != NSLeftMouseDown && selectedView == nil);
  
  [[NSNotificationCenter defaultCenter] removeObserver: self name: NSMenuWillSendActionNotification object: nil];
  
  [cursor pop];
  
  if (selectedView == nil)
    view = [[[[event window] contentView] superview] hitTest:[event locationInWindow]];
  else
    view = selectedView;
  /*viewHierarchyMenu = [[[NSMenu alloc] initWithTitle: @""] autorelease];
  
  while (view)
  {
    item = [viewHierarchyMenu addItemWithTitle: NSStringFromClass([view class])
                                        action: @selector(viewSelected:)
                                 keyEquivalent: @""];
    [item setTarget: self];
    [item setRepresentedObject:view];
    view = [view superview];
  }  
  
  [viewHierarchyMenu addItem: [NSMenuItem separatorItem]];
  item = [viewHierarchyMenu addItemWithTitle: NSStringFromClass([[event window] class])
                                      action: @selector(viewSelected:)
                               keyEquivalent: @""];
  [item setTarget: self];
  [item setRepresentedObject:[event window]];

  [NSMenu popUpContextMenu: viewHierarchyMenu withEvent: event forView: view];*/
  
  [self setRootObject:view];
  [selectedView release];
  [[self window] performSelector:@selector(makeKeyAndOrderFront:) withObject:nil afterDelay:0];    
} 

- (void) selectViewAction:(id)sender 
{
  [self performSelector:@selector(selectView:) withObject:nil afterDelay:0]; 
}

- (void) selfAction:(id)sender
{
  [self sendMessage:@selector(self) withArguments:nil];
}

- (void) sendMessage:(SEL)selector withArguments:(Array *)arguments // You can pass nil for "arguments"
{
  // Simulate the user invoking a method on the selected object through the browser.
  
  NSString *methodName = [Compiler stringFromSelector:selector];
  id selectedObject;

  if ((selectedObject = [self validSelectedObject]) == nil)
  {
    NSBeep();
    return;
  }
  
  if (![selectedObject respondsToSelector:selector] && selector != @selector(applyBlock:)/* Account for a proxy to an object in an app not linket against F-Script framework */)
  {
    NSBeginInformationalAlertSheet(@"Inavlid message", @"OK", nil, nil, [self window], nil, NULL, NULL, NULL, @"The selected object doesn't responds to \"%@\".", methodName);
    return;
  }
  
  if (arguments && [arguments count] > 0) [browser setDelegate:nil];
  
  [self selectMethodNamed:methodName];
  
  if (arguments && [arguments count] > 0)
  {
    [browser setDelegate:self];
    [self sendMessageTo:selectedObject selectorString:methodName arguments:arguments putResultInMatrix:[browser matrixInColumn:[browser lastColumn]]];
  }

  [browser scrollColumnToVisible:[browser lastColumn]];
  [browser scrollColumnsLeftBy:1]; // Workaround for the call above to scrollColumnToVisible: not working as expected.
  //[browser tile];
}

- (void)sendMessageAction:(id)sender
{
  NSString *selectedString = [[browser selectedCell] stringValue];
  id selectedObject = [[browser selectedCellInColumn:[browser selectedColumn]-1] representedObject];
  NSForm *f = [[[[sender window] contentView] subviews] objectAtIndex:0];
  int nbarg = [f numberOfRows];
  Array *arguments = [Array arrayWithCapacity:nbarg]; // Array instead of NSMutableArray in order to support nil
  int i;

  for (i = 0; i < nbarg; i++)
  {
    NSFormCell *cell = [f cellAtIndex:i];
    NSString *argumentString = [cell stringValue];
    FSInterpreterResult *result = [interpreter execute:argumentString];

    if ([result isOk])
      [arguments addObject:[result result]];
    else
    {
      NSMutableString *errorArgumentString = [NSString stringWithFormat:@"Argument %d %@", i+1, [result errorMessage]];

      [result inspectBlocksInCallStack];
      [f selectTextAtIndex:i];
      NSRunAlertPanel(@"ERROR", errorArgumentString, @"OK", nil, nil,nil);

      // An alternative for displaying the error message in a more Smalltalk-like way. Not yet functionnal.
      /*
        NSMutableString *errorArgumentString = [NSMutableString stringWithString:argumentString];
       NSBeep();
       [errorArgumentString insertString:[result errorMessage] atIndex:[result errorRange].location];
       [cell setStringValue:errorArgumentString];
       [cell selectWithFrame:NSMakeRect(0,0,[cell cellSize].width,[cell cellSize].height) inView:[cell controlView] editor:[f currentEditor] delegate:self start:[result errorRange].location length:[result errorRange].length]; */

      break;
    }
  }

  if (i == nbarg) // There were no error evaluating the arguments
  {
    BOOL success; 
    NSMatrix *matrix = [browser matrixInColumn:[browser lastColumn]];
    //NSBrowserCell *cell;

    //[[sender window] orderOut:nil];
    //[NSApp endSheet:[sender window]];
    //[[sender window] close];
    
    success = [self sendMessageTo:selectedObject selectorString:selectedString arguments:arguments putResultInMatrix:matrix];
    /*if (cell = [matrix cellAtRow:0 column:0])
    {
      [browser setTitle:printString([[cell representedObject] classOrMetaclass]) ofColumn:[browser lastColumn]];
    }*/

    //[[sender window] orderOut:nil];
    if (success)
    {
      [NSApp endSheet:[sender window]];
      [[sender window] close];
      [browser tile];
    }  
  }
}

- (BOOL) sendMessageTo:(id)receiver selectorString:(NSString *)selectorStr arguments:(Array *)arguments putResultInMatrix:(NSMatrix *)matrix
{ 
  int nbarg = [arguments count];
  id args[nbarg+2]; 
  SEL selector = [Compiler selectorFromString:selectorStr];
  int i;
  id result = nil; // To avoid a warning "might be used uninitialized"
  NSString *errorString = nil;
  NSDictionary *userInfo = nil;
  NSArray *blockStack;
    
  if ([receiver isKindOfClass:[NewlyAllocatedObjectHolder class]]) receiver = [receiver object];      
  args[0] = receiver;
  args[1] = (id)selector;
  for (i = 0; i < nbarg; i++) args[i+2] = [arguments objectAtIndex:i];
  
  NS_DURING
  
    result = sendMsgNoPattern(receiver, selector, selectorStr, nbarg+2, args,[MsgContext msgContext]);
  
  NS_HANDLER
  
    // errorString = [NSString stringWithFormat:@"%@ : %@",[localException name], [localException reason]];
    errorString =  [[[localException reason] retain] autorelease]; // to be sure it stay alive during the rest of the current method
    userInfo = [[[localException userInfo] retain] autorelease]; // to be sure it stay alive during the rest of the current method
    
  NS_ENDHANDLER
  
  if (errorString)
  {
    if (userInfo && (blockStack = [userInfo objectForKey:@"blockStack"]) )
    {
      inspectBlocksInCallStack(blockStack);
    }   
    
    NSRunAlertPanel(@"ERROR", errorString, @"OK", nil, nil,nil);
    return NO;
  }
  else 
  {
    if (selector == @selector(alloc) || selector == @selector(allocWithZone:))
      result = [NewlyAllocatedObjectHolder newlyAllocatedObjectHolderWithObject:result];

    [self fillMatrix:matrix withObject:result];
    return YES;
  }
}

-(void)setInterpreter:(FSInterpreter *)theInterpreter
{
  [theInterpreter retain];
  [interpreter release];
  interpreter = theInterpreter;
}

-(void)setMethodFilterString:(NSString *)theMethodFilterString
{
  [theMethodFilterString retain];
  [methodFilterString release];
  methodFilterString = theMethodFilterString;
}

-(void)setRootObject:(id)theRootObject 
{
  [theRootObject retain];
  [rootObject release]; 
  rootObject = theRootObject;
  isBrowsingWorkspace = NO;
  [browser loadColumnZero];
  //[browser displayColumn:0]; // may be unnecessary
} 
  
- (void)setTitleOfLastColumn:(NSString *)title
{
  [browser setTitle:title ofColumn:[[[self subviews] objectAtIndex:0] lastColumn]];
}

- (void)updateAction:(id)sender
{
  int i, nb;
    
  for (i = 0, nb = [browser lastColumn]+1; i < nb; i +=2)
  {
    NSMatrix *matrix = [browser matrixInColumn:i];
    int selectedRow = [matrix selectedRow];
    id object = [[matrix cellAtRow:0 column:0] representedObject];
    
    if ((isBrowsingWorkspace && i == 0) || (selectedRow != 0 && ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSSet class]])) )
    {
      int j = 0;
      int numberOfRows;
      id selectedElement = [[matrix cellAtRow:selectedRow column:0] representedObject];
        
      [selectedElement retain]; // (1) To ensure selectedElement will not be deallocated as a side effect of the following fillMatrix:withObject: message  

      if (isBrowsingWorkspace && i == 0)
        [self fillMatrixForWorkspaceBrowsing:matrix]; // As a side effect, this will supress the selection
      else
        [self fillMatrix:matrix withObject:object]; // As a side effect, this will supress the selection

      //if (i == nb-2) [browser setLastColumn:i];
      
      // Since the collection may have been modified, we search for  
      // the element of the collection that was selected (if still in the collection)
      // in order to re-install the selection
      numberOfRows = [matrix numberOfRows];
      while (1)
      {
        if (selectedRow+j >= numberOfRows && selectedRow-j < 0) break;
        else if (selectedRow+j < numberOfRows && [[matrix cellAtRow:selectedRow+j column:0] representedObject] == selectedElement)
        {
          [matrix selectCellAtRow:selectedRow+j column:0];
          break;
        }
        else if (selectedRow-j >= 0 && [[matrix cellAtRow:selectedRow-j column:0] representedObject] == selectedElement)
        {
          [matrix selectCellAtRow:selectedRow-j column:0];
          break;
        }
        else
          j++;
      }
      [selectedElement release]; // We can now match the retain in (1)
    }
    else
    {
      [self fillMatrix:matrix withObject:object];    // As a side effect, this will supress the selection
      [matrix selectCellAtRow:selectedRow column:0]; // I reinstall the selection
    }
  }
  [[self window] display]; // To display the changes. Is there an other way ?
}

- (id) validSelectedObject
{
  id selectedObject = [self selectedObject];

  // We test wether the selectedObject object is valid (an invalid proxy will raise when sent -respondsToSelector:)
  NS_DURING
    [selectedObject respondsToSelector:@selector(class)];
  NS_HANDLER
    NS_VALUERETURN(nil, id);
  NS_ENDHANDLER
  
  return selectedObject;
}

- (void) workspaceAction:(id)sender
{
  [self browseWorkspace]; 
}

//- (BOOL) isOpaque{return YES;}
@end