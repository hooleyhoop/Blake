(*
	SmartString 1.7
	
	Copyright 1994-2007 by Jon Pugh <jonpugh@frostbitefalls.com>
	Jon's Home Page <http://www.seanet.com/~jonpugh/>
	
	The best way to use this script is to load it from disk when you compile 
	but check for updates when you run, like so:
	
	-- the alias follows the file if it's moved or renamed
	property ssFile : alias "YourDisk:Folder1:Folder2:SmartString"
	-- the modification date is burned in at compile time
	property ssDate : modification date of (info for ssFile)
	-- the script object is loaded at compile time too
	property ss : load script ssFile
	-- at run time check the mod date
	set modDate to modification date of (info for ssFile)
	-- if newer then load a new copy
	if modDate > ssDate then
		set SmartString to load script ssFile
		-- remember the date for the newly loaded file
		set ssDate to modDate
		--display dialog "I'm loaded"
	end if
	tell ss's SmartString
		setString("Your text here")
		-- do stuff
	end tell
		
	SmartString is an AppleScript script object which knows how to perform numerous operations
	on strings.  The complete list of operations are:
	
	newString(aString) --> script object factory method

	getString() --> string (only reads)
	setString(aString) --> string
	setList(aList, seperator) --> string
	on convertListToString(aList, delim) --> string (only reads)

	subString(x, y) --> string (only reads)
	beforeString(subString) --> string (only reads)
	afterString(subString) --> string (only reads)
	betweenStrings(afterThis, beforeThis) --> string (only reads)

	appendString(aString) --> string
	prependString(aString) --> string
	insertBefore(subString, thisString) --> string
	insertAfter(subString, thisString) --> string

	deleteCharacters(x, y) --> string
	deleteString(subString) --> string
	deleteBefore(beforeString) --> string
	deleteAfter(afterString) --> string
	deleteBetween(beforeThis, afterThis) --> string

	keepBefore(beforeString) --> string
	keepAfter(afterString) --> string
	keepBetween(beforeThis, afterThis) --> string
	replaceString(subString, withString) --> string
	replaceStrings(subString, withString) --> string
	replaceBetween(frontTag, rearTag, newValue) --> string

	getTokens(delim) --> list (only reads)
	setTokens(aList, delim) --> string
	beforeToken(token, delim) --> string (only reads)
	afterToken(token, delim) --> string (only reads)
	getTokenRange(startIndex, endIndex, delim) --> list (only reads)
	deleteTokenRange(startIndex, endIndex, delim) --> string
	keepTokenRange(startIndex, endIndex, delim) --> string
	deleteTokensAfter(token, delim) --> string
	keepTokensAfter(token, delim) --> string

	firstToken(delim) --> string (only reads)
	deleteFirstToken(delim) --> string
	keepFirstToken(delim) --> string

	lastToken(delim) --> string (only reads)
	deleteLastToken(delim) --> string
	keepLastToken(delim) --> string

	NthToken(n, delim) --> string (only reads)
	deleteNthToken(n, delim) --> string
	keepNthToken(n, delim) --> string

	trimWhitespace() --> string
	uppercase() --> string
	lowercase() --> string
*)

script SmartString
	
	property parent : AppleScript
	property theString : ""
	
	on newString(aString) --> script object factory method
		copy me to anObject
		anObject's setString(aString)
		return anObject
	end newString
	
	on getString() --> string (only reads)
		return theString
	end getString
	
	on setString(aString) --> string
		set theString to aString as string
	end setString
	
	on setList(aList, seperator) --> string
		set theString to convertListToString(aList, seperator)
	end setList
	
	on subString(x, y) --> string (only reads)
		return text x thru y of theString
	end subString
	
	on beforeString(aString) --> string (only reads)
		set foo to offset of aString in theString
		if foo = 0 then
			return ""
		else if foo = 1 then
			return ""
		else
			return text 1 thru (foo - 1) of theString
		end if
	end beforeString
	
	on afterString(aString) --> string (only reads)
		set foo to offset of aString in theString
		if foo = 0 then
			return ""
		else
			copy foo + (length of aString) to foo
			if foo > length of theString then
				return ""
			else
				return text foo thru -1 of theString
			end if
		end if
	end afterString
	
	on betweenStrings(afterThis, beforeThis) --> string (only reads)
		set savedString to theString
		keepAfter(afterThis)
		keepBefore(beforeThis)
		set tempString to theString
		setString(savedString)
		return tempString
	end betweenStrings
	
	on appendString(aString) --> string
		set theString to theString & aString
	end appendString
	
	on prependString(aString) --> string
		set theString to aString & theString
	end prependString
	
	on replaceString(thisStr, thatStr) -- syntax forgivenness so you don't have to remember if there is or isn't an s
		replaceStrings(thisStr, thatStr) -- expecting only a single replacement could be considered here, but we're not that subtle yet
	end replaceString
	
	on replaceStrings(thisStr, thatStr) --> string
		set oldDelim to AppleScript's text item delimiters
		set AppleScript's text item delimiters to thisStr
		set theList to text items of theString
		set AppleScript's text item delimiters to thatStr
		set theString to theList as string
		set AppleScript's text item delimiters to oldDelim
		return theString
	end replaceStrings
	
	on deleteString(aString) --> string
		set foo to offset of aString in theString
		if foo ­ 0 then
			set theString to beforeString(aString) & afterString(aString) as string
		end if
		return theString
	end deleteString
	
	on replaceBetween(frontTag, rearTag, newValue) --> string
		set t1 to beforeString(frontTag)
		deleteBefore(frontTag)
		deleteString(frontTag)
		deleteBefore(rearTag)
		set theString to {t1, frontTag, newValue, theString} as string
	end replaceBetween
	
	on insertBefore(beforeStr, thisStr) --> string
		set theString to {beforeString(beforeStr), thisStr, beforeStr, afterString(beforeStr)} as string
	end insertBefore
	
	on insertAfter(afterStr, thisStr) --> string
		set theString to {beforeString(afterStr), afterStr, thisStr, afterString(afterStr)} as string
	end insertAfter
	
	on deleteBefore(beforeStr) --> string
		set theString to beforeStr & afterString(beforeStr)
	end deleteBefore
	
	on deleteAfter(afterStr) --> string
		set theString to beforeString(afterStr) & afterStr
	end deleteAfter
	
	on deleteBetween(afterThis, beforeThis) --> string
		set theString to {beforeString(beforeThis), beforeThis, afterThis, afterString(afterThis)} as string
	end deleteBetween
	
	on keepBefore(beforeStr) --> string
		set theString to beforeString(beforeStr)
	end keepBefore
	
	on keepAfter(afterStr) --> string
		set theString to afterString(afterStr)
	end keepAfter
	
	on keepBetween(afterThis, beforeThis) --> string
		set theString to betweenStrings(afterThis, beforeThis)
	end keepBetween
	
	on deleteCharacters(x, y) --> string
		if x > 1 then
			set a to text 1 thru (x - 1) of theString
		else
			set a to ""
		end if
		if y < length of theString then
			set b to text (y + 1) thru -1 of theString
		else
			set b to ""
		end if
		set theString to a & b
	end deleteCharacters
	
	on convertListToString(aList, delim) --> string (only reads)
		set oldSep to AppleScript's text item delimiters
		set AppleScript's text item delimiters to delim
		set aString to aList as string
		set AppleScript's text item delimiters to oldSep
		return aString
	end convertListToString
	
	on getTokens(delim) --> list (only reads)
		set oldDelim to AppleScript's text item delimiters
		set AppleScript's text item delimiters to delim
		set theList to text items of theString
		set AppleScript's text item delimiters to oldDelim
		return theList
	end getTokens
	
	on setTokens(aList, delim) --> string
		set theString to convertListToString(aList, delim)
	end setTokens
	
	on firstToken(delim) --> string (only reads)
		return NthToken(1, delim)
	end firstToken
	
	on lastToken(delim) --> string
		return NthToken(-1, delim)
	end lastToken
	
	on NthToken(n, delim) --> string
		if n = 0 then error "Cannot get delim zero"
		set t to getTokens(delim)
		if t = {} then return ""
		set numItems to number of items of t
		if n > numItems then error "Cannot get delim " & n & ", only " & numItems & " of tokens"
		return item n of t
	end NthToken
	
	on deleteNthToken(n, delim) --> string
		if n = 0 then error "Cannot delete token zero"
		set aList to getTokens(delim)
		set m to number of items of aList
		if n = 1 then
			set aList to items 2 thru m of aList
		else if n < 0 then
			set aList to items 1 thru (m + n) of aList
		else if n = m then
			set aList to items 1 thru (m - 1) of aList
		else
			set aList to (items 1 thru (n - 1) of aList) & (items (n + 1) thru m of aList)
		end if
		set oldDelim to AppleScript's text item delimiters
		set AppleScript's text item delimiters to delim
		try
			set theString to aList as string
		on error theMsg number theNum
			set AppleScript's text item delimiters to oldDelim
			error theMsg number theNum
		end try
		set AppleScript's text item delimiters to oldDelim
		return theString
	end deleteNthToken
	
	on deleteFirstToken(delim) --> string
		deleteNthToken(1, delim)
	end deleteFirstToken
	
	on deleteLastToken(delim) --> string
		deleteNthToken(-1, delim)
	end deleteLastToken
	
	on keepFirstToken(delim) --> string
		setString(NthToken(1, delim))
	end keepFirstToken
	
	on keepLastToken(delim) --> string
		setString(NthToken(-1, delim))
	end keepLastToken
	
	on keepNthToken(n, delim) --> string
		setString(NthToken(n, delim))
	end keepNthToken
	
	on getTokenRange(startIndex, endIndex, delim) --> list (only reads)
		set theList to getTokens(delim)
		-- check parameter constraints
		set n to number of items of theList
		if abs(startIndex) > n or startIndex = 0 then error "Bad startIndex in getTokenRange"
		if abs(endIndex) > n or endIndex = 0 then error "Bad endIndex in getTokenRange"
		if startIndex > endIndex then error "startIndex > endIndex in getTokenRange"
		-- return sub-list
		return items startIndex thru endIndex of theList
	end getTokenRange
	
	on deleteTokenRange(startIndex, endIndex, delim) --> string
		set theList to getTokens(delim)
		-- check parameter constraints
		set n to number of items of theList
		if abs(startIndex) > n or startIndex = 0 then error "Bad startIndex in deleteTokenRange"
		if abs(endIndex) > n or endIndex = 0 then error "Bad endIndex in deleteTokenRange"
		if startIndex > endIndex then error "startIndex > endIndex in deleteTokenRange"
		if startIndex < 0 then set startIndex to n + startIndex + 1
		if endIndex < 0 then set endIndex to n + endIndex + 1
		-- return sub-lists
		if startIndex = 1 then
			if endIndex = n then
				set theList to {}
			else
				set theList to items (endIndex + 1) thru n of theList
			end if
		else if endIndex = n then
			set theList to items 1 thru (startIndex - 1) of theList
		else
			set theList to (items 1 thru (startIndex - 1) of theList) & (items (endIndex + 1) thru n of theList)
		end if
		setTokens(theList, delim)
	end deleteTokenRange
	
	on keepTokenRange(startIndex, endIndex, delim) --> string
		set theList to getTokenRange(startIndex, endIndex, delim)
		setTokens(theList, delim)
	end keepTokenRange
	
	on beforeToken(token, delim) --> string (only reads)
		set theList to getTokens(delim)
		set n to number of items of theList
		repeat with i from 2 to n
			if item i of theList = token then
				set aList to items 1 thru (i - 1) of theList
				return convertListToString(aList, delim)
			end if
		end repeat
		return ""
	end beforeToken
	
	on afterToken(token, delim) --> string (only reads)
		set theList to getTokens(delim)
		set n to number of items of theList
		repeat with i from 1 to (n - 1)
			if item i of theList = token then
				set aList to items (i + 1) thru n of theList
				return convertListToString(aList, delim)
			end if
		end repeat
		return ""
	end afterToken
	
	on deleteTokensAfter(token, delim) --> string
		
	end deleteTokensAfter
	
	on keepTokensAfter(token, delim) --> string
		
	end keepTokensAfter
	
	on trimWhitespace() --> string
		set twoReturns to return & return
		repeat while theString contains twoReturns
			replaceString(twoReturns, return)
		end repeat
		set twoTabs to tab & tab
		repeat while theString contains twoTabs
			replaceString(twoTabs, tab)
		end repeat
		set twoSpaces to "  "
		repeat while theString contains twoSpaces
			replaceString(twoSpaces, space)
		end repeat
		if length of theString > 1 then
			repeat while character 1 of theString = tab or character 1 of theString = space
				set theString to text 2 thru -1 of theString
			end repeat
			repeat while last character of theString = tab or last character of theString = space
				set theString to text 1 thru -2 of theString
			end repeat
		end if
		return theString
	end trimWhitespace
	
	on uppercase() --> string
		local newString
		set newString to ""
		repeat with c in characters of theString
			set a to ASCII number contents of c
			if a > 96 and a < 123 then
				set a to a - 32
				set newString to newString & (ASCII character a)
			else
				set newString to newString & c
			end if
		end repeat
		set theString to newString
	end uppercase
	
	on lowercase() --> string
		set newString to ""
		repeat with c in characters of theString
			set a to ASCII number contents of c
			if a > 64 and a < 91 then
				set a to a + 32
				set newString to newString & (ASCII character a)
			else
				set newString to newString & c
			end if
		end repeat
		set theString to newString
	end lowercase
	
	on abs(n)
		if n < 0 then
			return -n
		else
			return n
		end if
	end abs
	
end script
