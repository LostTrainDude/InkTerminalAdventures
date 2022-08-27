=== function dbStorylets(id, element)
{id:
    - M_TAPE_1:
        {element:
            - "title":
                ~return "The frequency of the Universe"
                
            - "prereq":
                ~return true // No prerequisites!
          
            - "outcome":
                ~allMissions -= id
                ~allMissions += M_TAPE_2 // Enables the second chapter of the quest
                
            - "outcome_negative":
                ~allMissions -= id
                ~alter(morale, -10)
            
            - "divert":
                ~return -> mission_tape_1
        }
    - M_TAPE_2:
        {element:
            - "title":
                ~return "The frequency of the Universe"
                
            - "prereq":
                ~return eventsSinceLastMission > 1
            
            - "outcome":
                ~allMissions -= id
            
            - "divert":
                ~return -> mission_tape_2
        }
    - E_PARTY:
        {element:
            - "title":
                ~return "A party"
                
            - "prereq":
                ~return morale < 70 && food > 35

            - "repeatable":
                ~return true                

            - "priority":
                ~return abs(70 - morale)

            - "outcome":
                ~allEvents -= id
                ~alter(food, -15)
                ~alter(morale, 15)

            - "outcome_negative":
                ~allEvents -= id
                ~alter(morale, -15)

            - "divert":
                ~return -> event_party
        }
    - E_FOOD_SUPPLIES:
        {element:
            - "title":
                ~return "Leftovers"
                
            - "prereq":
                ~return true

            - "repeatable":
                ~return true

            - "priority":
                ~return abs(40 - food)
          
            - "outcome":
                ~allEvents -= id
                ~alter(food, 15)
                ~alter(fuel, -15)

            - "outcome_negative":
                ~allEvents -= id
                ~alter(morale, -15)

            - "divert":
                ~return -> event_food_supplies
        }
    - E_ROLLIES:
        {element:
            - "title":
                ~return "A game of dice"
                
            - "prereq":
                ~return true

            - "repeatable":
                ~return true

            - "priority":
                ~return abs(60 - morale)
            
            - "outcome":
                ~allEvents -= id
                ~alter(morale, 10)
                
            - "outcome_negative":
                ~allEvents -= id
                ~alter(morale, -15)

            - "divert":
                ~return -> event_dice_game
        }
    - E_ASTEROID_FIELD:
        {element:
            - "title":
                ~return "Rocky turbulence"
                
            - "prereq":
                ~return true

            - "repeatable":
                ~return true

            - "priority":
                ~return RANDOM(0,100)
            
            - "outcome":
                ~allEvents -= id
                ~alter(morale, 10)
                
            - "outcome_negative":
                ~allEvents -= id
                ~alter(morale, -15)
                ~alter(status, -15)

            - "divert":
                ~return -> event_asteroid_field
        }             
}