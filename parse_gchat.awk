#Time display line
# e.g. 3:22 PM 
match($0, /^([0-9]+):([0-9]+) ([AP]M) $/, arr) {
    # store time
    if(out[3] ~ /PM/){
        arr[1] += 12
    }
    # Put into standard form
    date_spec = "2013 01 01 " arr[1] " " arr[2] " 0" 
    date = mktime(date_spec)
    if (first_time > 0){
        last_time = date
    }
    else {
       first_time = date 
    }
    # Don't count as chat content
    next
}
# Dead time line
# e.g. 5 minutes
match($0, /^([0-9]+) minutes/, out) {
    dead_time += out[1]
    # Don't count as chat content
    next
}

#Speaker change line
# e.g. me: I love cats
/^[A-za-z]+: / { 
    speaker = $1
    if (speaker !~ /^me/){
        other_speaker = $1
    }
    changes++

    # Remove the name of the speaker from the line
    sub($1 FS, ""); 
}

# Anything left but blank lines are chat content
$0 !~ /^[ ]+$/{
    words[speaker] += NF
    chars[speaker] += split($0, junk, "")
}

END { 
    # Get duration in minutes
    duration = (last_time - first_time) / 60
    my_share_words = sprintf("%d", 100 * (words["me:"] / (words["me:"] + words[other_speaker])))
    my_share_chars = sprintf("%d", 100 * (chars["me:"] / (chars["me:"] + chars[other_speaker])))
    their_share_words = sprintf("%d", 100 * (words[other_speaker] / (words["me:"] + words[other_speaker])))
    their_share_chars = sprintf("%d", 100 * (chars[other_speaker] / (chars["me:"] + chars[other_speaker])))

    #The first change should not count as an exchange
    exchanges = --changes

    # Print zero if there was no dead time
    if( ! dead_time){
        dead_time = 0
    }

    print "me: ",
     words["me:"] " words ",
     "("my_share_words"%), ",
     chars["me:"] " characters ",
     "("my_share_chars"%)\n",
     other_speaker,
     words[other_speaker] " words ",
     "("their_share_words"%), ",
     chars[other_speaker] " characters ",
     "("their_share_chars"%)\n",
     "exchanges: "exchanges "\n",
     "duration: "duration " minutes\n",
     "dead_time: "dead_time " minutes\n"
}
