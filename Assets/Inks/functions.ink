//////////////////////////////////////////////////////
// GENERIC FUNCTIONS
//////////////////////////////////////////////////////

// Creates a planet name on the fly
=== function planet_name()
~ return "{~Alpha|Beta|Gamma|Delta|Epsilon|Zeta|Eta|Theta|Iota|K|Lambda|M|N|X|Omicron|Pi|Rho|Sigma|Tau|Ypsilon|Phi|Chi|Psi|Omega}-{RANDOM(1, 999)}"



//////////////////////////////////////////////////////
// MISSIONS FUNCTIONS
//////////////////////////////////////////////////////

// Returns the count of all the missions existing in the game
=== function allMissionsCount()
~ return LIST_COUNT(LIST_ALL(allMissions))

// Returns a list of all the "open" missions in the game
=== function get_open_missions()
~ return LIST_RANGE(allMissions, LIST_MIN(allMissions), LIST_MAX(allMissions))

// Loops through all "open" missions and forms a new list of
// available missions by checking whether their prerequisites
// are met or not
=== function get_available_missions(ref list, currentIndex)
{currentIndex < allMissionsCount():
    {allMissions ? allMissions(currentIndex):
            {dbStorylets(allMissions(currentIndex), "prereq"):
                ~list += allMissions(currentIndex)
            }
        }
    ~currentIndex++
    ~get_available_missions(list, currentIndex)
}



//////////////////////////////////////////////////////
// EVENTS FUNCTIONS
//////////////////////////////////////////////////////

// Retrns the count of all the events existing in the game
=== function allEventsCount()
~ return LIST_COUNT(LIST_ALL(allEvents))

// Returns a list of all the "open" events in the game
=== function get_open_events()
~ return LIST_RANGE(allEvents, LIST_MIN(allEvents), LIST_MAX(allEvents))

// Loops through all "open" events and forms a new list of
// available events by checking whether their prerequisites
// are met or not
=== function get_available_events(ref list, currentIndex)
{currentIndex < allEventsCount():
    {allEvents ? allEvents(currentIndex):
            {dbStorylets(allEvents(currentIndex), "prereq"):
                ~list += allEvents(currentIndex)
            }
        }
    ~currentIndex++
    ~get_available_events(list, currentIndex)
}

=== function reset_repeatable_events(currentIndex)
{currentIndex < allEventsCount():
    {is_repeatable(allEvents(currentIndex)):
        {debugMode: RESET {allEvents(currentIndex)}}
        ~allEvents += allEvents(currentIndex)
    }
    ~currentIndex++
    ~reset_repeatable_events(currentIndex)
}



//////////////////////////////////////////////////////
// GENERIC STORYLETS FUNCTIONS
//////////////////////////////////////////////////////

// Gets the title of a mission or event
=== function get_title(id)
~ return dbStorylets(id, "title")

// Checks whether all prerequisites for a given mission or event are met
=== function check_prerequisites(id)
~ return dbStorylets(id, "prereq")

=== function get_random_divert(list)
~ return dbStorylets(LIST_RANDOM(list), "divert")

=== function get_priority(id)
~ return dbStorylets(id, "priority")

=== function is_repeatable(id)
~ return dbStorylets(id, "repeatable")

CONST POSITIVE = true
CONST NEGATIVE = false

// Executes the outcomes for a given mission
=== function process_outcome(id, positiveOrNegative)
{positiveOrNegative:
    ~ dbStorylets(id, "outcome")
- else:
    ~ dbStorylets(id, "outcome_negative")
}


// Gets the element of a list that has the highest priority
=== function get_highest_priority(ref highestPriorityElement, list)
{LIST_COUNT(list) > 0:
    ~ temp element = pop(list)
    ~ temp highestPriority = get_priority(highestPriorityElement)
    ~ temp elementPriority = get_priority(element)

    {highestPriority < elementPriority:
        ~highestPriorityElement = element
    }
    
    ~get_highest_priority(highestPriorityElement, list)
}



//////////////////////////////////////////////////////
// LIST FUNCTIONS
//////////////////////////////////////////////////////

// Returns the top-most element of a list
=== function pop(ref list) 
    ~ temp el = LIST_MIN(list)
    ~ list -= el
    ~ return el 

//////////////////////////////////////////////////////
// MATH FUNCTIONS
//////////////////////////////////////////////////////

// Returns the absolute value of a number
=== function abs(x)
~ return x * ((x>0) - (x<0))

// Increases or decreases a variable value making sure
// it stays in the 0 - 100 range
=== function alter(ref x, amount)
{
    - x + amount < 0:
        ~ x = 0
    - x + amount > 100:
        ~ x = 100
    - else:
        ~ x += amount
}