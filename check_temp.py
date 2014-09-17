#! /usr/bin/env python

# Modified by Zhanglei
# Date: 2014.07.14

# For this plugin you will need lm-sensors package. 
# For ubuntu - $sudo apt-get install lm-sensors hddtemp
# Use this plugin only if you have the above package otherwise it will not work
import sys
import commands
import re

def temp():
	cmd = 'sensors | grep Core'
	(status, output) = commands.getstatusoutput(cmd)
	if status:
		sys.stderr.write(output)
		sys.exit(3)
	try:
		match = re.search('\d+.\d',output)
		ans = match.group()
	except:
		print 'item not found'
		exit(3)
	if ans < '74':
		print 'Normal temperature:', ans, '\xb0C'
		exit(0)
	elif ans > '74' and ans < '84':
		print 'Warning - Hot:', ans, '\xb0C'
		exit(1)
	elif ans >= '84':
		print 'Critical Temperature:', ans, '\xb0C'
		exit(2)
	else:
		print 'Unknown'
		exit(3)

def main():
	temp()
	

if __name__ == "__main__":
	main()
