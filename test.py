import os
for subdir, dirs, files in os.walk("./"):
    for file in files:
        '''if file.startswith("fail-") and file.endswith(".mc"):
            f1 = open(file,'r')
            sentences = f1.readlines()
            f2 = open(file[:-3]+".gbl", 'w')
            for sentence in sentences:
                f2.write(sentence)
            f2.close()'''
                #elif file.startswith("test-") and file.endswith(".mc"):
        if file.endswith(".mc"):
            f1 = open(file,'r')
            sentences = f1.readlines()
            f2 = open(file[:-3]+".gbl", 'w')
            if not sentences[0].startswith("class"):
                f2.write("class mymain extends Main{\n")
            for sentence in sentences:
                f2.write(sentence)
            if not sentences[0].startswith("class"):
                f2.write("}")
            f2.close()