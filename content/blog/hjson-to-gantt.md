+++
Description = ""
date = "2016-10-15T10:00:00+01:00"
title = "Generating a Gantt chart from HJSON input"

+++

This blog post is a slight departure from the normal topics here. Worry not, 
we'll return to discussing Verilog, Chisel, and low-level software work soon.
I wrote a quick script to help serve a need (producing a Gantt chart) and 
thought perhaps others would find it useful.

There are a wide range of online services to help produce and maintain Gantt 
charts, but none quite offered what I was looking for. I want something open 
source, easy to use, and where the underlying data is human readable and can 
be version controlled. The 
[python-gantt](http://xael.org/pages/python-gantt-en.html) library formed an 
excellent starting point for generating a Gantt chart in SVG, but I thought it 
was worth trying to support a slightly less verbose input format.

Enter [hjson](http://hjson.org/), which aims to be a superset of json with 
much more forgiving syntax. This has its disadvantages, but it does seem to 
work well as a concise and easy to edit data format. A quick python script to 
parse an hjson input to produce a Gantt chart and we're away. One feature I do 
like is the use of [fuzzy matching](https://github.com/amjith/fuzzyfinder) for 
project references and dependencies. Again, this makes it easy to hack on by 
hand. In the example below, I'm able to use "mftr widgets" to refer to the 
"Manufacture widgets" task.

Example input:

		{
			projects: [
				{
					name: Project Alpha
					color: green
				}
			]

			tasks: [
				{
					name: Design widget
					begin: 2016-10-14
					duration: 7,
					people: Farquaad
					project: alpha
				}
				{
					name: Set up widget production line
					begin: 2016-10-19
					duration: 6
					people: Zack
					project: alpha
				}
				{
					name: Manufacture widgets
					duration: 7
					people: Carrie
					deps: ["design widget", "widget prod line"]
					project: alpha
				}
			]

			milestones: [
				{
					name: Widgets start shipping
					start: 2016-10-30
					deps: ["mftr widgets"]
					project: alpha
				}
			]
		}

Example output (`./hjson_to_gantt --begin-date 2016-10-10 --end-date 2016-11-13 example.hjson --name example`):

<img src="/blog/2016/gantt_example_weekly.png" alt="Example Gantt chart" style="width: 900px">

[hjson_to_gantt is available on Github](https://github.com/lowRISC/hjson_to_gantt).

_Alex Bradbury_
