AWK GChat parser
################

Companion code for this post: http://evanmuehlhausen.com/analyze-gchat-transcripts-in-awk/

To run it::

    gawk -f parse_gchat.awk transcript.txt


You should see::

    me:  59 words  (59%),  290 characters  (58%)
    Jose: 41 words  (41%),  207 characters  (41%)
    exchanges: 14
    duration: 20 minutes
    dead_time: 6 minutes

To run it on your own transcript, pull up the chat log in Gmail,
press print and then cut and pasted it into a text file::

    gawk -f parse_gchat.awk my_transcript.txt


