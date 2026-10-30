//////////////////////////////////////////////////////
// RESOURCES VARIABLES
//////////////////////////////////////////////////////

VAR fuel = 100
VAR food = 100
VAR morale = 100
VAR status = 100

VAR jumps = 0

-> start
=== start
>>> TITLE: Let's ruin in a bad way!
>>> COLOR: 9ea8b8

I'm not that kind of person, but yeah

    + [GO!]
    -> one

=== one
>>> TITLE: Let's follow Nathan!
>>> COLOR: c77152

His daughter was fully able by then

    + [I remember something was interesting there]
    And indeed it was
    
    + [Boy, writers' strike sure did a number on this]
    Sigh
 
- -> two

=== two
>>> TITLE: A simple day

    + [Let's play some NON DEPRESSING videogames / FOOD-- MORALE++]
    Pew pew!
    
    + [Let's watch NOTRE DAME DE PARIS / MORALE++]
    FUCK YES
    
- -> END