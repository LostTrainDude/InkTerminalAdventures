INCLUDE functions.ink
INCLUDE missions.ink
INCLUDE databases.ink
INCLUDE debug.ink
INCLUDE events.ink

VAR debugMode = false

//////////////////////////////////////////////////////
// TRACKING VARIABLES
//////////////////////////////////////////////////////

VAR jumps = 0
VAR eventsSinceLastMission = -1



//////////////////////////////////////////////////////
// RESOURCES VARIABLES
//////////////////////////////////////////////////////

VAR fuel = 100
VAR food = 100
VAR morale = 100
VAR status = 100



//////////////////////////////////////////////////////
// STORYLETS RELATED LISTS
//////////////////////////////////////////////////////

// The missions evaluating "true" are to be considered "open"
LIST allMissions = (M_TAPE_1), M_TAPE_2, M_NULL

// The events evaluating "true" are to be considered "open"
LIST allEvents = E_PARTY, E_FOOD_SUPPLIES, E_ROLLIES, E_ASTEROID_FIELD, E_NULL



//////////////////////////////////////////////////////
// MAIN LOOP
//////////////////////////////////////////////////////

-> start
=== start
>>> TITLE: A new beginning
This is what we've been waiting for. Full clearance to leave and traverse the universe.
What are we waiting for, exactly?

    + [Let's go!] -> hub

=== hub
// Build a list of all available events
~ temp availableEvents = ()
{get_available_events(availableEvents, 1)}

// IF there are no events available reset those who are resettable
// then try again
{LIST_COUNT(availableEvents) == 0:
    ~ reset_repeatable_events(1)
    {get_available_events(availableEvents, 1)}
}

// Build a list of all available missions
~ temp availableMissions = ()
{get_available_missions(availableMissions, 1)}

// If no missions AND no events are available, then "quit"
{LIST_COUNT(availableMissions) == 0 && LIST_COUNT(availableEvents) == 0: -> no_more}


>>> COLOR: RESET
{debugMode:
    <- debug_print_available_missions
    <- debug_print_available_events
    <- debug_print_highest_priority_event
    //<- debug_print_resources
}

~ temp nextDivert = -> hub

// Pick the first available mission. If there aren't any,
// just take a random event instead.
{LIST_COUNT(availableMissions) > 0:
    ~ eventsSinceLastMission = 0
    ~ nextDivert = dbStorylets(LIST_MIN(availableMissions), "divert")
- else:
    {
        - LIST_COUNT(availableEvents) > 0:
            ~ temp highestPriorityEvent = pop(availableEvents)
            {get_highest_priority(highestPriorityEvent, availableEvents)}
            
            ~ eventsSinceLastMission += 1
            ~ nextDivert = dbStorylets(highestPriorityEvent, "divert")
    }
}

{nextDivert != -> hub:
    {debugMode:
        + [Next up {nextDivert}!]
        -> nextDivert
    - else:
        + [Continue your journey]
        -> nextDivert
    }
- else:
    -> nextDivert
}

=== no_more
There are no missions nor events you can play!
-> END