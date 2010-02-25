/*
 *  MIDocumentProtocols.h
 *  Mori
 *
 *  Created by Jesse Grosjean on 6/10/05.
 *  Copyright 2005 Hog Bay Software. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>

typedef enum _MIAttributeSummaryType {
    MIAttributeNoneSummaryType = 1,
    MIAttributeTotalSummaryType = 2,
    MIAttributeMinimumSummaryType = 3,
    MIAttributeMaximumSummaryType = 4,
    MIAttributeAverageLeavesSummaryType = 5,
    MIAttributeHiddenSummaryType = 6,
    MIAttributeStateSummaryType = 7
} MIAttributeSummaryType;

typedef enum _MIFetchRequestType {
    MICoreDataFetchRequest = 1,
    MISearchKitFetchRequest = 2,
    MISpotlightFetchRequest = 3
} MIFetchRequestType;

typedef enum _MISearchKitIndex {
    MISearchKitIndexAll = 1,
    MISearchKitIndexTitle = 2,
} MISearchKitIndex;

typedef enum _MIColorLabelType {
    MINoneColorLabel = 0,
    MIRedColorLabel,
    MIOrangeColorLabel,
    MIYellowColorLabel,
    MIGreenColorLabel,
    MIBlueColorLabel,
    MIPurpleColorLabel,
    MIGrayColorLabel
} MIColorLabelType;

// basic class protocols

@protocol MIContentIndexProtocol;
@protocol MIEntryProtocol;
@protocol MIEntryDataProtocol;
@protocol MIEntryDataDelegateProtocol;
@protocol MIAttributeDescriptionProtocol;
@protocol MIAttributeDescriptionDelegateProtocol;
@protocol MIEntryLiveFetchRequestProtocol;
@protocol MIPasteboardControllerProtocol;
@protocol MIImportControllerProtocol;
@protocol MIExportControllerProtocol;
@protocol MIDocumentProtocol;

@interface NSObject (MIDocumentProtocols)

+ (id <MIPasteboardControllerProtocol>)sharedPasteboardController;
+ (id <MIImportControllerProtocol>)sharedImportController;
+ (id <MIExportControllerProtocol>)sharedExportController;
+ (NSArray *)minimumEntryCover:(NSArray *)entries;
+ (id)insertNewEntryInDocument:(id <MIDocumentProtocol>)document;
+ (id)insertNewEntryInDocument:(id <MIDocumentProtocol>)document withAttributesFromURL:(NSURL *)url;
+ (id)insertNewEntryInDocument:(id <MIDocumentProtocol>)document withEntryData:(id <MIEntryDataProtocol>)entryData;
+ (id)insertNewAttributeDescriptionInDocument:(id <MIDocumentProtocol>)document key:(NSString *)key dataType:(NSAttributeType)dataType summaryType:(int)summaryType isUserDefined:(BOOL)isUserDefined error:(NSError **)error;
+ (NSDictionary *)plistReferenceRepresentation:(NSArray *)entries;
+ (NSArray *)loadPlistReferenceRepresentation:(NSDictionary *)plistReferenceRepresentation;
+ (NSDictionary *)plistCopyRepresentation:(NSArray *)entries;
+ (NSArray *)loadPlistCopyRepresentation:(NSDictionary *)plistCopyRepresentation document:(id <MIDocumentProtocol>)document;
+ (NSPredicate *)predicate:(NSPredicate *)filterPredicate includingOnlyDescendentsOf:(id <MIEntryProtocol>)ancestor;
+ (NSPredicate *)predicate:(NSPredicate *)filterPredicate excludingDescendentsOf:(id <MIEntryProtocol>)ancestor;
+ (NSColor *)colorForColorLabel:(MIColorLabelType)colorLabelType;
+ (NSMenu *)colorLabelMenu;

@end

@protocol MIDocumentProtocol <NSObject>

- (BOOL)isClosing;
- (NSPersistentDocument *)selfAsPersistentDocument;
- (id <MIContentIndexProtocol>)contentIndex;

- (id)userStateForKey:(NSString *)key;
- (void)setUserState:(id)plistObject forKey:(NSString *)key;

- (NSString *)stringIdForEntry:(id <MIEntryProtocol>)entry;
- (id <MIEntryProtocol>)entryForStringID:(NSString *)stringID;

- (NSSet *)userInvisibleEntries;
- (void)markEntriesInvisible:(NSArray *)entries;
- (NSSet *)userVisibleChanges;

- (void)rescheduleAutosaveIfNeeded;

@end

@protocol MIContentIndexProtocol <NSObject>

- (NSManagedObject *)selfAsManagedObject;
- (id <MIDocumentProtocol>)document;
- (id <MIEntryProtocol>)root;
- (id <MIEntryProtocol>)trash;
- (NSSet *)attributeDescriptions;
//- (NSSet *)summarizingAttributeDescriptions;
- (id <MIAttributeDescriptionProtocol>)attributeDescriptionForKey:(NSString *)key;
- (void)addAttributeDescriptionsObject:(id <MIAttributeDescriptionProtocol>)anAttributeDescription;
- (void)removeAttributeDescriptionsObject:(id <MIAttributeDescriptionProtocol>)anAttributeDescription;

- (void)emptyTrash;

- (NSArray *)entriesWithTitle:(NSString *)title;
- (NSArray *)executeCoreDataFetchRequest:(NSFetchRequest *)fetchRequest;
- (NSArray *)executeSearchKitFetchRequest:(NSString *)queryString;
- (NSArray *)executeSpotlightFetchRequest:(NSFetchRequest *)fetchRequest;
- (id <MIEntryLiveFetchRequestProtocol>)createLiveFetchRequestOfType:(MIFetchRequestType)fetchRequestType;

@end

#define MIContentIndexWillAddAttributeDescription @"MIContentIndexWillAddAttributeDescription"
#define MIContentIndexDidAddAttributeDescription @"MIContentIndexDidAddAttributeDescription"
#define MIContentIndexWillRemoveAttributeDescription @"MIContentIndexWillRemoveAttributeDescription"
#define MIContentIndexDidRemoveAttributeDescription @"MIContentIndexDidRemoveAttributeDescription"

@protocol MIEntryProtocol <NSObject, NSCopying>

- (NSManagedObject *)selfAsManagedObject;
- (id <MIDocumentProtocol>)document;
- (id <MIEntryProtocol>)parent;
- (unsigned int)position;
- (NSImage *)icon;
- (void)invalidateIcon;
- (id <MIEntryDataProtocol>)entryData;

- (unsigned int)countOfOrderedChildren;
- (unsigned int)indexOfObjectInOrderedChildren:(id <MIEntryProtocol>)anEntry;
- (id <MIEntryProtocol>)objectInOrderedChildrenAtIndex:(unsigned int)index;
- (void)insertObject:(id <MIEntryProtocol>)node inOrderedChildrenAtIndex:(unsigned int)index;
- (void)insertOrderedChildren:(NSArray *)childrenToAdd atIndexes:(NSIndexSet *)indexes;
- (void)addOrderedChild:(id <MIEntryProtocol>)anEntry;
- (void)removeObjectFromOrderedChildrenAtIndex:(unsigned int)index;
- (void)removeOrderedChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)removeOrderedChild:(id <MIEntryProtocol>)anEntry;
- (BOOL)isValidOrderedChildren:(NSArray *)potentialChildren;

// danger does not handle aliases. use non-private methods unless you have specific reason to use these private ones. (ie writing importer)
- (void)privateInsertOrderedChildren:(NSArray *)entriesToAdd indexes:(NSIndexSet *)indexes;
- (void)privateRemoveOrderedChildrenAtIndexes:(NSIndexSet *)indexes;

- (void)addChildren:(NSSet *)childrenToAdd;
- (void)removeChildren:(NSSet *)childrenToRemove;

- (BOOL)isRoot;
- (BOOL)isLeaf;
- (BOOL)isDetached;
- (BOOL)isUserVisible;
- (BOOL)isAnchored;
- (BOOL)isEntryAncestor:(id <MIEntryProtocol>)entry;
- (BOOL)isAnyEntryAncestor:(NSArray *)entries;
- (BOOL)isEntryDecendent:(id <MIEntryProtocol>)entry;

- (id <MIEntryProtocol>)root;
- (id <MIEntryProtocol>)firstAncestorWithContentType:(NSString *)contentType;

- (id <MIEntryProtocol>)firstChild:(NSPredicate *)predicate;
- (id <MIEntryProtocol>)lastChild:(NSPredicate *)predicate;
- (id <MIEntryProtocol>)childAfter:(id <MIEntryProtocol>)entry predicate:(NSPredicate *)predicate;
- (id <MIEntryProtocol>)childBefore:(id <MIEntryProtocol>)entry predicate:(NSPredicate *)predicate;
- (id <MIEntryProtocol>)previousSibling:(NSPredicate *)predicate;
- (id <MIEntryProtocol>)nextSibling:(NSPredicate *)predicate;
- (id <MIEntryProtocol>)previousAlias;
- (id <MIEntryProtocol>)nextAlias;

- (void)removeFromParent;

- (BOOL)isJoined;
- (BOOL)isJoinedWith:(id <MIEntryProtocol>)entry;
- (BOOL)isAliased;
- (NSSet *)joinedEntries;
- (id <MIEntryProtocol>)createJoinedEntry;

- (void)shiftUp:(NSPredicate *)predicate;
- (BOOL)canShiftUp:(NSPredicate *)predicate;
- (void)shiftDown:(NSPredicate *)predicate;
- (BOOL)canShiftDown:(NSPredicate *)predicate;
- (void)shiftRight:(NSPredicate *)predicate;
- (BOOL)canShiftRight:(NSPredicate *)predicate;
- (void)shiftLeft:(NSPredicate *)predicate;
- (BOOL)canShiftLeft:(NSPredicate *)predicate;
- (void)promote:(NSPredicate *)predicate;
- (BOOL)canPromote:(NSPredicate *)predicate;
- (void)demote:(NSPredicate *)predicate;
- (BOOL)canDemote:(NSPredicate *)predicate;

- (NSEnumerator *)ancestorEnumerator:(NSPredicate *)predicate;
- (NSEnumerator *)reverseAncestorEnumerator:(NSPredicate *)predicate;
- (NSEnumerator *)siblingEnumerator:(NSPredicate *)predicate;
- (NSEnumerator *)childEnumerator:(NSPredicate *)predicate;
- (NSEnumerator *)breadthFirstEnumerator:(NSPredicate *)predicate;
- (NSEnumerator *)depthFirstEnumerator:(NSPredicate *)predicate;
- (NSEnumerator *)rowOrderEnumerator:(NSPredicate *)predicate;

@end

@protocol MIEntryDataProtocol <NSObject>

- (id <MIDocumentProtocol>)document;
- (NSManagedObject *)selfAsManagedObject;
- (NSNumber *)locked;
- (void)setLocked:(NSNumber *)newLocked;
- (NSString *)contentType;
- (void)setContentType:(NSString *)newContentType;
- (NSString *)title;
- (void)setTitle:(NSString *)newTitle;
- (NSDate *)creationDate;
- (void)setCreationDate:(NSDate *)newDate;
- (NSDate *)modificationDate;
- (void)setModificationDate:(NSDate *)newDate;
- (NSNumber *)state;
- (void)setState:(NSNumber *)newState;
- (NSNumber *)label;
- (void)setLabel:(NSNumber *)newLabel;
- (NSDate *)lastUsedDate;
- (void)setLastUsedDate:(NSDate *)newLastUsedDate;
- (NSDate *)dueDate;
- (void)setDueDate:(NSDate *)newDueDate;
- (NSArray *)keywords;
- (void)setKeywords:(NSArray *)newKeywords;
- (NSNumber *)starRating;
- (void)setStarRating:(NSNumber *)newStarRating;
- (NSString *)comment;
- (void)setComment:(NSString *)newComment;

- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key;	
- (id)valueForAttributeDescription:(id <MIAttributeDescriptionProtocol>)attributeDescription;
- (void)setValue:(id)value forAttributeDescription:(id <MIAttributeDescriptionProtocol>)attributeDescription;

- (NSMutableDictionary *)transientAttributes;

- (NSNumber *)hasText;
- (NSTextStorage *)textStorage; // if you edit textStorage directly make sure to put appropriate undo's on textStorageUndoManager
- (void)setTextStorageContent:(id)text;
- (NSUndoManager *)textStorageUndoManager;

- (NSSet *)joinedEntries;
- (void)invalidateJoinedEntryIcons;

- (BOOL)isFetchRequest;
- (void)setIsFetchRequest:(BOOL)newIsFetchRequest;
- (NSString *)fetchQueryString;
- (void)setFetchQueryString:(NSString *)fetchQueryString; // use with searchkit only, ignored by coredata and spotlight
- (NSPredicate *)fetchPredicate;
- (void)setFetchPredicate:(NSPredicate *)predicate; // used by coredata and spotlight, ignored by searchkit
- (NSNumber *)usesSortDescriptors;
- (void)setUsesSortDescriptors:(NSNumber *)newUsesSortDescriptors;
- (NSArray *)fetchSortDescriptors;
- (void)setFetchSortDescriptors:(NSArray *)fetchSortDescriptors; // used by coredata and spotlight, ignored by searchkit
- (NSNumber *)usesFetchLimit;
- (void)setUsesFetchLimit:(NSNumber *)newUsesFetchLimit;
- (NSNumber *)fetchLimit;
- (void)setFetchLimit:(NSNumber *)fetchLimit;
- (NSNumber *)includeEntriesFromTrash;
- (void)setIncludeEntriesFromTrash:(NSNumber *)includeEntriesFromTrash;
- (MIFetchRequestType)fetchRequestType;
- (void)setFetchRequestType:(MIFetchRequestType)fetchRequestType;
- (id <MIEntryLiveFetchRequestProtocol>)createLiveFetchRequestForJoinedEntry:(id <MIEntryProtocol>)entry;
- (NSArray *)executeFetchRequest;
- (void)postFetchRequestChangedNotification;

- (id <MIEntryDataDelegateProtocol>)delegate;
- (NSImage *)iconForEntry:(id <MIEntryProtocol>)joinedEntry;

@end

#define MIEntryDataFetchRequestChangedNotification @"MIEntryDataFetchRequestChangedNotification"

// entry data delegates are how entries are customized (it trash). see also MIUserInterfaceEntryDataDelegateProtocol in MIUserInterfaceProtocols.h
// in the standard case that protocol also needs to be implemented by delegate.
@protocol MIEntryDataDelegateProtocol <NSObject>

- (BOOL)isDelegateForContentType:(NSString *)contentType;
- (BOOL)isValidParent:(id <MIEntryProtocol>)potentialParent forEntry:(id <MIEntryProtocol>)joinedEntry;
- (BOOL)isValidOrderedChild:(id <MIEntryProtocol>)potentialChild forEntry:(id <MIEntryProtocol>)joinedEntry;
- (BOOL)isAnchored:(id <MIEntryProtocol>)joinedEntry; // can't be copied, cut, deleted or archived
- (NSImage *)iconForEntry:(id <MIEntryProtocol>)joinedEntry;
- (void)parentChangedForEntry:(id <MIEntryProtocol>)joinedEntry;
- (void)childrenChangedForEntry:(id <MIEntryProtocol>)joinedEntry;
- (void)awakeFromFetch:(id <MIEntryDataProtocol>)entryData;
- (void)willSave:(id <MIEntryDataProtocol>)entryData;
- (void)didSave:(id <MIEntryDataProtocol>)entryData;
- (void)attributeValueChanged:(id <MIEntryDataProtocol>)entryData key:(NSString *)key newValue:(id)newValue oldValue:(id)oldValue;

@end

@protocol MIAttributeDescriptionProtocol <NSObject>

- (NSString *)key;
- (NSAttributeType)dataType;
- (MIAttributeSummaryType)summaryType;
- (BOOL)isUserDefined;
- (NSDictionary *)userInfo;
- (void)setUserInfo:(NSDictionary *)newUserInfo;

- (BOOL)includeInFullTextIndex;
- (BOOL)includeInSpotlightIndex;

- (void)guiObjectsForAttribute:(NSString **)outName cell:(NSCell **)outCell tableColumn:(NSTableColumn **)outTableColumn;
- (id <MIAttributeDescriptionDelegateProtocol>)delegate;

@end

@protocol MIAttributeDescriptionDelegateProtocol <NSObject>

- (BOOL)isDelegateForAttributeDescription:(id <MIAttributeDescriptionProtocol>)attributeDescription;
- (BOOL)includeInFullTextIndex:(id <MIAttributeDescriptionProtocol>)attributeDescription;
- (BOOL)includeInSpotlightIndex:(id <MIAttributeDescriptionProtocol>)attributeDescription;
- (void)indexValueFromEntryData:(id <MIEntryDataProtocol>)entryData fullTextIndex:(NSMutableString *)fullTextIndex spotlightIndex:(NSMutableDictionary *)spotlightIndex attributeDescription:(id <MIAttributeDescriptionProtocol>)attributeDescription;
- (void)guiObjectsForAttribute:(NSString **)outName cell:(NSCell **)outCell tableColumn:(NSTableColumn **)outTableColumn attributeDescription:(id <MIAttributeDescriptionProtocol>)attributeDescription;

@end

@protocol MIEntryLiveFetchRequestProtocol <NSObject>

- (MIFetchRequestType)fetchRequestType;
- (MISearchKitIndex)searchKitIndex;
- (void)setSearchKitIndex:(MISearchKitIndex)newFetchRequestFields;
	
- (NSString *)queryString;
- (void)setQueryString:(NSString *)queryString;
- (SKSearchType)searchType;
- (void)setSearchType:(SKSearchType)searchType;
- (NSPredicate *)predicate;
- (void)setPredicate:(NSPredicate *)predicate;
- (NSPredicate *)filterPredicate;
- (void)setFilterPredicate:(NSPredicate *)filterPredicate;
- (NSArray *)sortDescriptors;
- (void)setSortDescriptors:(NSArray *)descriptors;
- (NSNumber *)fetchLimit;
- (void)setFetchLimit:(NSNumber *)newFetchLimit;
- (NSArray *)matchingRangesInString:(NSString *)string attributeDescription:(id <MIAttributeDescriptionProtocol>)attributeDescription;

- (BOOL)startQuery;
- (void)stopQuery;
- (BOOL)isStarted;
- (BOOL)isGathering;
- (BOOL)isStopped;

- (NSArray *)results;
- (unsigned)resultCount;
- (id <MIEntryProtocol>)resultAtIndex:(unsigned)idx;
- (BOOL)computesRelevanceScoreForResults;
- (NSNumber *)resultRelevanceAtIndex:(unsigned)idx;

@end

@protocol MIImportControllerProtocol <NSObject>

- (void)runImportSheetForWindow:(NSWindow *)window document:(id <MIDocumentProtocol>)document;
- (NSArray *)supportedUTIs;
- (NSArray *)supportedPathExtensions; // XXX shouldn't be neccessary, but I can't always get supportedUTIs to do what I want.
- (NSArray *)importURLs:(NSArray *)urls document:(id <MIDocumentProtocol>)document error:(NSError **)error;

@end

@protocol MIEntryImportProtocol <NSObject>

- (NSArray *)supportedUTIs;
- (NSArray *)supportedPathExtensions; // XXX shouldn't be neccessary, but I can't always get supportedUTIs to do what I want.
- (NSArray *)importURL:(NSURL *)url document:(id <MIDocumentProtocol>)document error:(NSError **)error;

@end

@protocol MIExportControllerProtocol <NSObject>

- (void)runExportSheetForWindow:(NSWindow *)window entries:(NSArray *)entries;
- (NSPopUpButton *)accessoryView;
- (NSArray *)supportedUTIs;
- (BOOL)exportEntries:(NSArray *)entries url:(NSURL *)url uti:(NSString *)uti error:(NSError **)error;

@end

@protocol MIEntryExportProtocol <NSObject>

- (NSArray *)supportedUTIs;
- (NSString *)descriptionForUTI:(NSString *)uti;
- (BOOL)exportEntries:(NSArray *)entries url:(NSURL *)url uti:(NSString *)uti error:(NSError **)error;

@end

@protocol MIPasteboardControllerProtocol <NSObject>

- (BOOL)writeEntryReferences:(NSArray *)entries toPasteboard:(NSPasteboard *)pboard;
- (NSArray *)readEntryReferencesFromPasteboard:(NSPasteboard *)pboard;
- (BOOL)writeEntryCopies:(NSArray *)entries toPasteboard:(NSPasteboard *)pboard;
- (NSArray *)readEntryCopiesFromPasteboard:(NSPasteboard *)pboard document:(id <MIDocumentProtocol>)document;

- (NSDragOperation)dragOperationForInfo:(id <NSDraggingInfo>)info destinationDocument:(NSDocument *)destinationDocument;
- (BOOL)writeItems:(NSArray *)items operation:(NSDragOperation)operation toPasteboard:(NSPasteboard *)pboard;
- (void)pasteboard:(NSPasteboard *)sender provideDataForType:(NSString *)type;
- (BOOL)readItems:(NSDragOperation)operation fromPasteboard:(NSPasteboard *)pboard item:(id <MIEntryProtocol>)parentItem childIndex:(int)childIndex;

@end

#pragma mark pasteboard types

#define MIEntryReferencesPboardFormat @"MIEntryReferencesPboardFormat"
#define MIEntryCopiesPboardFormat @"MIEntryCopiesPboardFormat"