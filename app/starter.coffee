# Cross-platform application starter
if typeof $ != 'undefined'
	$(->req('initialize'))
else
	req('initialize')