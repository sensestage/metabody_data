# General concept:

For each data source we create a description - one for the overall program, what does it do. Then for each of the messages, we create a detailed description of what the message conveys: a textual description of the kind of data, how it is calculated, and if possible a video that demonstrates how the data is created.


## Global description
Describes how the program/patch creates the data. What data it receives (video/sensor data, etc) and how it processes the data.

## Description per message that is sent out

* osc-tag (e.g. `/activityNormal`)
* data range (e.g. `[ 0, 1]`, floating point, continous data)
* update rate (e.g. each frame (25 fps), or trigger whenever event occurs)
* description of what the data does (e.g. this is a measure for the activity in the  video image/of the body)
* calculation method of the data (e.g. finds the silhouet of the body in the image, and calculates the number of pixels changed between frames, normalized by the total number of pixels).
* link to a screencast that demonstrates the data's behaviour
* link to a set of data that can be played back

## Recording the screencast and/or example data set

Tools:

* <a href="https://github.com/sensestage/SC-OSCFileLog" target="_blank">OSCFileLog in SC</a>
* <a href="https://github.com/sensestage/videorecosc" target="_blank">videorecosc/videoplayosc</a>
* SenseWorld quark in SC
* LogRecording.scd and LogPlayback.scd in SuperCollider folder
* screencast capture within this package

