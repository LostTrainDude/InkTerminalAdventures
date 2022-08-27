=== event_party
>>> TITLE: {get_title(E_PARTY)}
>>> COLOR: 41118b

It's the birthday of one of the crewmembers, and the rest of the team wanted to throw a small party to celebrate.

    + [Agree / FOOD-- MORALE++]
    ~process_outcome(E_PARTY, POSITIVE)
    The party was a success. Maybe even a little too much.
    
    + [Deny / MORALE--]
    ~process_outcome(E_PARTY, NEGATIVE)
    Needless to say, your decision is not very popular among the crew.
    
    - - + + [Ok] ->

- -> hub

=== event_food_supplies
>>> TITLE: {get_title(E_FOOD_SUPPLIES)}
>>> COLOR: 00FFFF

We found out that on {planet_name()} there are food supplies leftover by a previous crew. They could turn out quite useful!

    + [Accept / FUEL-- FOOD++]
    ~process_outcome(E_FOOD_SUPPLIES, POSITIVE)
    Reaching the planet proved to be more difficult than anticipated, but at least we managed to collect some useful food supplies.
        
    + [Refuse / MORALE--]
    ~process_outcome(E_FOOD_SUPPLIES, NEGATIVE)
    The crew keeps on meticolously managing their rations
    
    - - + + [Ok] ->
    
- -> hub

=== event_dice_game
>>> TITLE: {get_title(E_ROLLIES)}
While going back to your quarters for the night, you can hear your crew being loud in the mess hall.

    + [Get closer]
    -> approach
    
    + [Leave them alone / MORALE--]
    -> ignore
    

= approach
As you approach them, you realize they're playing ROLLIES, a popular dice game.<br>They ask you if you wish to join the fun, "or are you afraid to lose?", they tease.

    + [Accept / MORALE++]
    ~ process_outcome(E_ROLLIES, POSITIVE)
    
    You sit in front of one of your crewmembers, grabbing a 20-sided dice and starting to making it roll in your hand.
        
        + + [Throw the dice]
        - - (rollies)
            ~temp you = RANDOM(1,20)
            ~temp them = RANDOM(1,20)
            
            You rolled a {you}, while your crewmember rolled a {them}. {you == them:It's a tie!|You {you >= them:won|lost}.}
            
            You are asked whether you want to play again.
            
            + + + [Roll again!] -> rollies
            
            + + + [Enough for today]
            You excuse yourself from the rest of the crew as they keep on playing and go to sleep, knowing that bonding with your crewmembers was, indeed, a great thing to do.
            
                + + + + [OK] -> hub
    
    + [Refuse / MORALE--]
    -> ignore


= ignore
~ process_outcome(E_ROLLIES, NEGATIVE)
You go back to your quarters having maybe lost a good opportunity to catch up with your fellow crewmembers.

    + [Ok] -> hub



=== event_asteroid_field
>>> TITLE: {get_title(E_ASTEROID_FIELD)}
>>> COLOR: C0C0C0
We jumped out of hyperspace right into an asteroid field! What should we do?

    + [Carefully manouver through]
    We get hit multiple times but it would have been a lot worse if we stayed still
    ~process_outcome(E_ASTEROID_FIELD, POSITIVE)

    + [Stand still and await for a breach to open]
    As you wait you get hit by a massive rock that wreaks havoc in the engine's room
    ~process_outcome(E_ASTEROID_FIELD, NEGATIVE)

    - + + [Ok] -> hub