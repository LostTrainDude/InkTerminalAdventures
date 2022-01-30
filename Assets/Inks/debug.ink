// Prints out the state of all the variables
=== debug_print_resources
Fl: {fuel} Fo: {food} Mr: {morale} St: {status} Ju: {jumps}
-> DONE

// Prints a list of all the missions which prerequisites
// have been met
=== debug_print_available_missions
~ temp availableMissions = ()
{get_available_missions(availableMissions, 1)}
Available missions: {availableMissions}
-> DONE

// Prints a list of all the events which prerequisites
// have been met
=== debug_print_available_events
~ temp availableEvents = ()
{get_available_events(availableEvents, 1)}
Available events: {availableEvents}
-> DONE

// Prints the ID of the event with the highest priority
=== debug_print_highest_priority_event
~ temp availableEvents = ()
{get_available_events(availableEvents, 1)}
~ temp highestPriorityEvent = pop(availableEvents)
{get_highest_priority(highestPriorityEvent, availableEvents)}
Highest priority Event: {highestPriorityEvent}
-> DONE