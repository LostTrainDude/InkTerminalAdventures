//////////////////////////////////////////////////////
// MISSION_TAPE_1 (M_TAPE_1)
//////////////////////////////////////////////////////


=== mission_tape_1
>>> TITLE: {get_title(M_TAPE_1)}
You received a distress signal from a nearby sector, not so far from our current course. Official procedure would require to, at least, attempt answering the call.

    + [Try to trace the distress signal]
    -> trace_signal
    
    + [Ignore it / MORALE--]
    -> go_back
        

= trace_signal
It comes from quite a small ship, unregistered, suitable for just a single person. Probably stolen or used for illegal purposes.

    + [Try getting in touch]
    -> radio
    
    + [Board the ship right away]
    -> board


= radio
>>> GLITCH: START
As you try to get in touch, you are greeted by a prerecorded message: a song. It's slow, heavily distorted and repetitive, executed in loop as if it was a mantra.<>
<br><br>Judging by the quality, it sounds like the transmission comes from a tape eroded by wear.<>
<br><br>You sense a kind of disturbance in your comms.

    + [Board the ship]
    >>> GLITCH: STOP
    -> board
    
    + [Don't stray further from your course / MORALE--]
    >>> GLITCH: STOP
    -> go_back


= board
The interior of the cockpit is quite bare, abandoned and silent. The only light comes from outer space through the front window and a blinking terminal, scribbling data.
<br><br>In front of it, the pilot's chair and, mostly hidden by its backrest, a lifeless body, arms dangling, covered in a full spacesuit.

    + [Get closer]
    -> pilot

    + [Reconsider]
    -> reconsider
    
= reconsider
{radio == false:{once:>>> GLITCH: START}}

You don't feel like staying in there and as you go help yourself to the exit, your comms system receives {radio:that song again.|a song.<br><br>It's slow, heavily distorted and repetitive, executed in loop as if it was a mantra. Judging by the quality, it sounds like the transmission comes from a tape eroded by wear.} You hesitate for a moment.

    + [Get closer to the pilot's chair]
    -> pilot
    
    + [Go back to your ship]
    -> go_back    


= pilot
{radio == false:{once:>>> GLITCH: START}}

{stopping:
    - As you get close, you realize that the spacesuit is empty inside, as if it was filled with air. It's otherwise intact and it doesn't show any sign of misfunction.<>
    On the spacesuit's chest, a cassette tape player. The "Play" button is on.
    
    - The empty spacesuit lies on the pilot's chair. The cassette player {stop: has now stopped playing{remove_cassette: and it has no cassette inside}}.

}<> {reconsider && !stop:The disturbance is getting stronger.}

    + {!stop} [Press the "Stop" button on the cassette player] -> stop
    + {stop && !remove_cassette} [Remove the cassette tape from the player] -> remove_cassette
    + [Examine the terminal] -> terminal
    + {stop && remove_cassette} [Go back to your ship] -> finale


= stop
>>> GLITCH: STOP

{As the audio track stops, so does the uneaseness you were feeling along with the disturbance in your comms system.|Now that the disturbance has stopped, here there is just silence, and a spacesuit with no one inside.}

    + [Remove the cassette tape from the player] -> remove_cassette
    + [Examine the terminal] -> terminal
    

= terminal
The display is showing a flow of data, repeated{stop:, and that stopped flowing as you hit stopped the cassette tape from playing|and endless}.
    
    + [Examine the pilot] -> pilot
    + {!stop} [Press the "Stop" button on the cassette player] -> stop
    + {stop && !remove_cassette} [Remove the cassette tape from the player] -> remove_cassette
    + {stop && remove_cassette} [Go back to your ship] -> finale


= remove_cassette
The cassette has no label. You easily store it in one of the pockets of your suit.

    + [Examine the terminal]
    -> terminal
    
    + [Go back to your ship]
    -> finale
    

= finale
~process_outcome(M_TAPE_1, POSITIVE)
You eventually leave the vessel and go back to your ship, with a cassette tape in your pocket and a mystery on your mind.
    
    + [OK] -> hub


= go_back
~process_outcome(M_TAPE_1, NEGATIVE)
We won't stray from our course, then, and we'll try to remove any track of this event from our logs.

    + [OK] -> hub


//////////////////////////////////////////////////////
// MISSION_TAPE_2 (M_TAPE_2)
//////////////////////////////////////////////////////


=== mission_tape_2
>>> TITLE: {get_title(M_TAPE_2)}
As soon as you jump out of hyperspace, you are greeted by a call request from a nearby ship
    
    + [Answer]
    -> answer
    
    + [Ignore]
    -> ignore


= answer
"Captain," the voice on the other end sounds simultaneously familiar and absolutely impossible to frame in time and space, "You carry something very important, with you".<>
<br><br>Then, an almost surreal silence, as if they are expecting you to understand what they are referring to.

    + (cassette_tape) ["The cassette tape?"]
    "Yes, the message," their answer is uttered with a tangible trepidation, "It is crucial, for us, Voidfarers, to be able to carry it forward."

        + + [Accept to deliver the tape]
        -> accept_delivery
        
        + + [Refuse their request]
        -> refuse_delivery

    + [Ask for explanations]
    -> explanations("\"You have met our brother, who preceded us into the Void\", their voice is only just grazed by a noticeable sadness.", 0)


= explanations(text, index)
{text}

- (top)
~index++
{index >= 7:
    ~index = 0
}

{index:
    -0:
        {asked_suit == false:
            * (asked_suit) [Ask about the empty suit]
            -> explanations("\"They stepped into the Void,\" answers back the voice, \"That's what you couldn't see.\"", -1)
        -else:
            -> top
        }
    -1:
        {asked_message == false:
            * (asked_message) [Ask about the message]
            -> explanations("\"The Void speaks to us, through the music,\" explains the voice, \"A universal mantra that bears life, death and everything in between.\"", -1)
        -else:
            -> top
        }
    -2:
        {asked_void == false:
            * (asked_void) [Ask about the Void]
            -> explanations("\"What is the Void, exactly, we do not know,\" they tell you, \"That's why our search continues.\"", -1)
        -else:
            -> top
        }
    -3:
        {asked_tape == false && answer.cassette_tape == false:
            * (asked_tape) [Ask about the cassette tape]
            -> explanations("\"Yes, the message,\" their answer is uttered with a tangible trepidation, \"It is crucial, for us, Voidfarers, to be able to carry it forward.\"", -1)
        -else:
            -> top
        }
    -4:
        {asked_voidfarer == false:
            * (asked_voidfarer) [Ask about the Voidfarers]
            -> explanations("\"We follow the Void, chasing the song of the Universe.\"", -1)
        -else:
            -> top
        }
    -5:
        {meeting == false:        
            * [Accept to deliver the tape]
            -> accept_delivery
        -else:
            * [Hand over the cassette]
            -> hand_over
        }
    -6:
        {meeting == false:
            * [Refuse their request]
            -> refuse_delivery
        -else:
            -> top
        }
}

+ [< BROWSE OPTIONS >] -> explanations(text, index)


= accept_delivery
{refuse_delivery.reconsider:
    "We thank you, Captain," the voice murmures in relief, "we humbly ask for permission to approach your vessel. We are unarmed and mean no harm."
- else:
    "Then we humbly ask for permission to approach your vessel, Captain," the voice asks calmly, "We are unarmed and mean no harm."
}   

    + ["We will wait for you"]
    + ["Let's do this quickly"]
    
- -> meeting


= refuse_delivery
"Your words sadden us, Captain, it is no small thing that what you're carrying, although to most would seem useless." firmly states the voice.<>
<br><br>"We ask you to reconsider."

    + (reconsider) [Reconsider]
    -> accept_delivery

    + [Confirm your decision]
    >>> GLITCH: START
    "Then so be it." These are the last words you hear before an immediate, almost surreal silence follows them. A sensation grows in you, then disspates, shortly after.
    
        + + [Get back to your trip]
        >>> GLITCH: STOP
        ~process_outcome(M_TAPE_2, NEGATIVE)
        -> hub


= meeting
In a brief span of time your two ships reach each other. You walk up to the entrance, in anticipation, along with some of your crewmates. As the door opens, you see this figure, entirely covered in a spacesuit. <>
Inside, you can barely see a shadow.<>
<br><br>"Captain..."

    + [Greet the figure]
    "We do not wish to stay more than it's due," they politely cut short, "but please accept our gratitude, on behalf of all the Voidfarer."

        + + [Hand over the cassette]
        -> hand_over

        + + [Ask for {explanations == true:more} explanations]
        {explanations == false:
            -> explanations("\"You have met our brother, who preceded us into the Void\", their voice is only just grazed by a noticeable sadness.", 0)
        -else:
            -> explanations("\"Ask further, Captain.\", they allow, gently.", 0)
        }

    + (early_exit) [Just hand over the cassette]
    -> hand_over
    
    ~process_outcome(M_TAPE_2, POSITIVE)
    -> hub


= hand_over
{meeting.early_exit:
    "We thank you, Captain," the figure slightly bows in gratitude, "please accept our gratitude on behalf of all the Voidfarer."<>
}
    They collect the tape, then proceed to leave.<br><br>You are left without a cassette tape{explanations == false:, a lot of questions,} and a deeper mystery on your mind.
    
    + [Better resume our trip]
    ~process_outcome(M_TAPE_2, POSITIVE)
    -> hub


= ignore
>>> GLITCH: START
You ignore the message and after a while, and for a while, you feel once again a disturbance in your communication system.

    + [Ok] -> hub