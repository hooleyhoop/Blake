#
#  rb_main.rb
#  LineCount
#
#  Created by steve hooley on 01/11/2008.
#  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'
require 'find'

# add the following line:
include OSX

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
    require( File.basename(path) )
  end
end

#recursively process the contents
def processDir ( aDir )

	print ("In #{aDir} \n")

	lineCount = 0

	# lets get the contents of dir BlakeRoot
	Find.find(aDir) do |path|  
		# is this a diercty? a '.h'? a '.m'?, a '.c'?, a '.mm'?
		if FileTest.directory?(path)
			if File.basename(path)==".svn" || File.basename(path)=="build"
				Find.prune       # Don't look any further into this directory.
			end
		else
			if File.extname(path)==".hhhhh" || File.extname(path)==".m"|| File.extname(path)==".c"|| File.extname(path)==".mm"
				print (File.basename(path)+"\n")
				File.open( path, 'r' ) do |file|
				
					# scan file lines
				   file.each_line do |line|
					  # select non blank, non comment-only line
					  lineCount += 1 unless line =~ /^\s*(#|\Z)/
				   end
			   
				end
			end
		end

	end

	print ("Total LineCount is #{lineCount}\n")

	#	isDirectory = false
	#	fm.fileExistsAtPath_isDirectory( fPath, isDirectory )
	#	if(isDirectory=="YES")
	#		print (isDirectory)
	#	end

		
		
		
#		fileExtension = fPath.pathExtension
#		if(fileExtension.length>0) 
#			print fPath.pathExtension + "\n"
#		end
#
#	end
#    - (NSArray *)directoryContentsAtPath:(NSString *)path

end

if $0 == __FILE__ then
    rb_main_init
	
	# lets get the path to Blake Root
    fm = OSX::NSFileManager.defaultManager
    path = OSX::NSBundle.mainBundle.bundlePath
    pathBits = path.pathComponents
    countOfPathBits = pathBits.count

    i=0
    reconstructedPathBlakeRoot=''
    while i<countOfPathBits-4
        reconstructedPathBlakeRoot = reconstructedPathBlakeRoot + pathBits[i] + '/'
        i=i+1
    end
	
	#recursively process the contents
	processDir( reconstructedPathBlakeRoot )

    OSX.NSApplicationMain(0, nil)
end
