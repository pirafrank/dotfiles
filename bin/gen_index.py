#!/usr/bin/env python2

#################################################################
#
# index generator
# generate index.html with links to files in the same folder
#
# use case: access files in a folder (e.g. dir with PDFs files)
# from browser and avoid turning directory listing on in your
# webserver.
#
# @Author
# Francesco Pira <dev@fpira.com>
#
# @License
# Released under the terms of GNU GPLv3
# Full license here https://www.gnu.org/licenses/gpl-3.0.en.html
#
#################################################################

import os
import sys
import urllib

if len(sys.argv) != 2:
    print "Usage: ./gen_index [path]"
    sys.exit()
else:
    path = sys.argv[1]
    if path.endswith('/'): path = path[:-1] # removing the last slash if any
    print "path is: "+path

print "start working..."

title = path.split('/')[-1] # the web page title will be the directory name
file_list = [file for file in os.listdir(path) if os.path.isfile(os.path.join(path, file))] # saving file list
rubbish = ['index.html','thumbs.db','desktop.ini','.DS_Store']

with open(path+'/index.html', 'w+') as f:
    f.write("<html>\n<head>\n")
    # making the web page responsive
    f.write("<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0' />")
    f.write("<title>"+title+"</title>\n</head>\n<body style=\"text-align:center;\"><br>")
    for file in file_list:
        # exclude unix/linux hidden and dumb system files and index itself
        if not file.startswith('.') and file not in rubbish:
            # creating links with encoded web safe urls
            f.write("<a href=\""+urllib.quote(file, safe='')+"\">"+file+"</a><br>\n")
    f.write("</body>\n</html>")
    f.close()
print "done!"
