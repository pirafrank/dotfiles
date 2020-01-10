# run it as:
# python base64_to_binary.py audio.txt output.mp3 > /dev/null

import sys, os, time, base64

timestr = time.strftime("%Y%m%d-%H%M")

text = "";

with open(sys.argv[1],'r') as input:
	text=input.read()
	input.close()

# adding missing padding (if any!) at the end
text += "=" * ((4 - len(text) % 4) % 4)
print(text)

decoded = base64.b64decode(text)
with open(sys.argv[2], 'wb') as audio:
	audio.write(decoded)
	#print("\nDone.\n")
