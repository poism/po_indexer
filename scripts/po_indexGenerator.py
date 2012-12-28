import os #used to split path and filename

src_file = os.path.join(os.path.dirname(__file__),"..","tmp/src_index.txt")
write_file = os.path.join(os.path.dirname(__file__),"..","tmp/index.json")

def streamLines(src_file,write_file):
        f = open(src_file)
	id = 0
        while True:
                line = f.readline()
                if line:
			id = fileInfo(line,id,write_file)
                if not line:
			writeJsonWrap(write_file,'close')
                        f.close()
                        break
                #yield line             


def fileInfo(line,id,write_file):
        startPos = line.find('./')
        endPos = line.find('\n')
        size = line[:startPos]
        path, fileName = os.path.split(line[startPos-1:])
        #type = fileName[fileName.find('.'):]
        #title = fileName[:fileName.find('.')]   
	if (nonExcludedFileType(fileName)):
		id = id + 1
		writeJson(write_file,id,path,fileName,size)

	return id


def nonExcludedFileType(fileName):
	fileName = fileName.strip()
	if (fileName == 'Thumbs.db'):
		return False
	else:
		return True
	
def writeJson(write_file,id,path,fileName,size):
	if (id != 0):
		write_file.write(',\n')

	write_file.write('{ "id":"'+str(id)+'" , "file":"'+str(fileName).strip()+'" , "path":"'+str(path).strip()+'" , "size":"'+str(size).strip()+'" }')

def writeJsonWrap(write_file,do):
	if (do == 'start'):
		write_file.write("{'files': [\n")
	else:
		write_file.write("\n]}")
		write_file.close()

def init_poIndex(src_file,write_file):
	write_file = open(write_file,'w')
	writeJsonWrap(write_file,'start')
	streamLines(src_file,write_file)

init_poIndex(src_file,write_file)

