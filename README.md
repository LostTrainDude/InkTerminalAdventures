# Ink Terminal Adventures
**Ink Terminal Adventures** is a framework to play **binary choice** Interactive Fiction games that are written using the [ink scripting language](https://github.com/inkle/ink) and feature elements of resource management, loosely as seen in titles like [Reigns](https://en.wikipedia.org/wiki/Reigns_%28video_game%29) and [Seedship](https://johnayliff.itch.io/seedship).

Developed in Unity (current version 2021.3.8f1), its original purpose is to give IF writers a ready-made implementation to rapidly prototype and play with, without having to deal with engine-side programming work.

Along with the Unity project, there is an experimental storylet "template", optional, and all written in ink and [explained later](#the-storylets-template).

## How to play your story
* Export your ink story in JSON format (for example, using Inky), name it `story.json`, and place it in the `StreamingAssets` folder, located in:
    - `InkTerminalAdventures\InkTerminalAdventures_Data`, if you are just running the game
    - `Assets\StreamingAssets` if you are working within the Unity Editor

The game reads the story file at runtime, so writers can update it without having to neither reboot nor rebuild the game.

Just overwrite the file and hit the `R` key on your keyboard, while playing.

If things go wrong (e.g. you end up writing an infinite loop by mistake or something makes the game crash) force-quitting and\or your OS' Task Manager can come to the rescue, as always.

## How to write your story
Given that you are not going to use the provided storylet template and that you are free to open up the Unity project and edit it everything yourself, the provided framework requires some specific guidelines to be followed.

### Global variables (aka resources)
By default, the framework requires five specific global variables to be available in your ink story. They should be mostly self-explanatory but here's a quick rundown of their naming and purpose.

| Variable name | Purpose | Range |
|---|---|---|
| food | The amount of food available | 0-100 |
| fuel | The amount of fuel available | 0-100 |
| morale | The general "happiness" of the crew | 0-100 |
| status | The general integrity of the ship's systems | 0-100 |
| jumps | The amount of hyperspace jumps performed so far | - |

You can add, remove or modify these and their naming the way you see fit, of course, but to do so you should also modify their references in the `[InkManager]` GameObject in the Unity project.

### The anatomy of a basic event
```
=== event_party
>>> TITLE: A party!
It's the birthday of one of our crewmates and the rest of the crew wants to throw a party to celebrate them.

	+ [Allow / MORALE++ FOOD--]
		The party was a success! Probably even too much.
		~morale += 15
		~food -= 15
	
	+ [Deny / MORALE--]
		The crew is not happy with your decision.
		~morale -= 15
```
In basic storylet fashion, an event can simply be something that is enabled by a specific set prerequisites and that has a specific set of outcomes.

Now let's look at a couple things more closely.

```
>>> TITLE: A party!
```
This command (or "direction", which will be explained further [later on](
#currently-available-directions)) instructs Unity to change the top-left label with the text provided (in this case "A party!")

---
```
+ [Allow / MORALE++ FOOD--]
```
This is how choices are presented to players.

What's before the ` / `is the actual text of the displayed choice; what's after is the "foreshadowing" of what resources are going to be affected.

![Animated GIF showing Ink Terminal Adventures' outcome forshadowing](https://i.imgur.com/Jt060qA.gif)
It is not mandatory to include such foreshadowing, but please note that whitespace before and after `/` is currently **required**

---

`FUEL`, `FOOD`, `MORALE` and`STATUS` are being declared as "prefixes" in the `InkVariable` objects prepared in the `[InkManager]`  so, if you plan to use your own you may want to alter these accordingly

![Image showing the Unity Inspector for changing variable tracking settings in Ink Terminal Adventures](https://i.imgur.com/j336Pab.png)
This alone should be enough to get started writing and testing your own events.

### TIP: How to work around the binary choice limitation
The framework technically allows a maximum of two choices to be on screen at any given time, but with a workaround, this can be circumvented. In your knot, you can create a loop like the following:

```
=== event_abandoned_ship
>>> TITLE: A deep space mistery
Inside the abandoned ship there are different rooms you can reach

- (opts)
{cycle:
	- + [Go to the med bay] -> med_bay
	- + [Go to the engine room] -> engine_room
	- + [Go to the mess hall] -> mess_hall
	- + [Go to the bridge] -> bridge
	
}
    + [< BROWSE >] -> event_abandoned_ship
```
![Animated GIF showcasing the workaround to circumvent binary choice limitation in Ink Terminal Adventures](https://i.imgur.com/ia84R3h.gif)

Why divert to `event_abandoned_ship` instead of `opts`? Because of the way text is collected and displayed in the implementation, doing so would mean that, upon cycling through the options, the content before that would not be displayed.

### Debug mode
You can toggle Debug mode by changing the boolean value of the `debugMode` global variable at the top of the `main.ink` file.

## Currently available directions
In your ink story you can write "directions" to have the game perform special tasks. You should be able to write them anywhere in your knots, provided that you write them on a newline, and the game should parse them accordingly.

### Audio management
The game recognizes only audio files with `.ogg`, `.mp3` and `.wav` extensions.

#### `>>> PLAY: audioFileName`
Plays an audio file calling it by name (without extension), provided that a audio file with that name is available within the `StreamingAssets\SFX` folder. **Warning**: case sensitive.
##### Example
```
>>> PLAY: door_creak
You hear a door creaking
```
---
#### `>>> PLAY LOOP: audioFileName`
Plays an audio file calling it by name (without extension), provided that a audio file with that name is available within the `StreamingAssets\SFX` folder. **Warning**: case sensitive.

##### Example
```
>>> PLAY LOOP: rain
The rain started pouring
```
---
#### `>>> STOP: ALL`
Stops all audio altogether
##### Example
```
>>> STOP: ALL
And then it was just silence
```
---
#### `>>> STOP: audioFileName`
Stops the specific audio file, provided that the file is available within the `StreamingAssets\SFX` folder. **Warning**: case sensitive.
##### Example
```
>>> STOP: alarm
The blaring alarm stopped
```

### UI effects

#### `>>> TITLE: My Title!`
Updates the top-left label of the Terminal
##### Example
```
>>> TITLE: A new beginning
This is where our tale begins!
```
---
#### `>>> COLOR: 012345`
Changes the color palette of the Terminal into the hex color of choice
##### Example
```
>>> COLOR: 33FF33
The Terminal has now an Apple][ green color
```
![An image showcasing the color change effect in Ink Terminal Adventures](https://i.imgur.com/zmoYshv.gif)

---
#### `>>> COLOR: RESET`
Resets the color palette of the Terminal to its original one
##### Example
```
>>> COLOR: RESET`
The Terminal has now reset its color to the default amber one
```
---
#### `>>> GLITCH: START`
Causes the camera to start "glitching" (by randomizing the Color Aberration intensity)
##### Example
```
>>> GLITCH: START
Oh no! it's glitching!
```
![An animated GIF showcasing the "glitch" effect in Ink Terminal Adventures](https://i.imgur.com/8GRUw8e.gif)

---
#### `>>> GLITCH: STOP`
Causes the camera to stop "glitching"
##### Example
```
>>> GLITCH: STOP
The disturbance stopped.
```

## The storylets "template"
Now to dive more into the provided storylets template! You can find the ink source files within the /Inks/ folder.

**DISCLAIMER:** don't expect much quality or stability in the game story or flow! At this stage it is basically a quick "proof of concept".

### Files
| Filename | Description |
| -------- | ----------- |
| databases.ink | Contains the "database functions" used to "store" storylets data |
| debug.ink | Contains debug ink threads that display the status of different elements in the game |
| events.ink | Contains all the Events |
| functions.ink | Contains all the helper\math\general functions used in the story |
| main.ink | Contains all the global variables and the main "hub" that directs players to different content |
| missions.ink | Contains all the Missions |

### Missions and Events
In this framework, Missions are kinda like quests in most videogames. They can be self contained but also carry over multiple "steps" to be played throughout the whole game.

Events, on the other hand are usually considered short, self contained playable chunks of content that have a specific set of prerequisites and outcomes.

They have also a slight difference in their properties that, given there's no such thing as structured data in ink, can be altered all the time if people wish to do so.

For instance, Missions by default don't have a "priority" but I may want or need to supply one at some point to a specific Mission I'm working on. I can simply add it when creating its "database entry".

#### Properties of Missions
| Property | Description | Returns
|--|--|---|
|"title"|The stored string that can be used to update the title label in the Terminal|string|
|"prereq"|Checks whether prerequisites are met|bool
|"outcome"|"function" that executes code, used for positive\generic outcomes|void
|"outcome_negative"|"function" that executes code, used for negative outcomes|void
|"divert"|The shortcut to the name of the knot related to the Mission|divert|

#### Properties of Events
| Property | Description | Returns
|--|--|---|
|"title"|The stored string that can be used to update the title label in the Terminal|string|
|"prereq"|Checks whether prerequisites are met|bool
|"repeatable"|Checks whether the Event can be replayed|bool
|"priority"|Calculates the likeliness of the Event to happen based on specific criteria|int
|"outcome"|"function" that executes code, used for positive\generic outcomes|void
|"outcome_negative"|"function" that executes code, used for negative outcomes|void
|"divert"|The shortcut to the name of the knot related to the Event|divert|

##### A note on "priority"
Events are thought to have "priority", determined by how "critical" the situation is for the players.

For example: I want the event `E_FOOD_SUPPLIES` to be increasingly more likely to be played out, the closer the `food` variable is to 0. In other words, I want to be sure that players have more chances to find food supplies when they're running out of them.

### How to add new Missions and Events
Add an ID for the Mission or Event to the `allMissions` or `allEvents` LIST at the top of the `main.ink` file. For example, let's say your Mission ID is `M_MY_NEW_MISSION`, you can add it like so:
```
LIST  allMissions  = (M_TAPE_1), M_TAPE_2, (M_MY_NEW_MISSION), M_NULL
```
Putting the ID between brackets marks it "available for selection" from the start. Otherwise it would need to be "activated" manually somewhere in the code.

For example, the `M_TAPE_2` Mission is activated as an outcome of the `M_TAPE_1` Mission.

Once you do that, add an entry to the `dbStorylets` function in the `databases.ink` file.

If it's a Mission:
```
...
-  M_MY_NEW_MISSION:
	{element:
		- "title":
			~return "My amazing new Mission!"
		- "prereq":
			~return true  // No prerequisites!
		- "outcome":
			~allMissions -=  id // Removes it from the list of the available Missions
		- "outcome_negative":
			~allMissions -= id
			~alter(morale, -10) // alter(var, amount) makes sure the result is within 0-100 range
		- "divert":
			~return -> mission_my_new_mission
	}
...
```

If it's an Event:
```
...
-  E_MY_NEW_EVENT:
	{element:
		- "title":
			~return "My fantastic new Event!"
		- "prereq":
			~return food < 50 && morale > 50 
		- "repeatable":
			~return true // It will be reactivated upon reset!
		- "priority":
			~ return abs(50 - food)
		- "outcome":
			~allEvents -=  id // Removes it from the list of the available Events
			~alter(food, 15) // alter(var, amount) makes sure the result is within 0-100 range
		- "outcome_negative":
			~allMissions -= id
			~alter(morale, -10)
		- "divert":
			~return -> event_my_new_event
	}
...
```
... And that's pretty much it. Of course you need to actually write your Missions and Events in order to actually include them in the "database".

### Functions
#### Generic storylets-related
|Name|Description|Parameters|Returns|
|--|--|--|--|
|get_title|Gets the title of a storylet|LIST element|string
|check_prerequisites|Checks whether all prerequisites for a given storylet are met|LIST element|bool
|get_random_divert|Gets the "divert" property of a random storylet|VARLIST\LIST|divert
|get_priority|Gets the "priority" property of a storylet|LIST element|int\float
|is_repeatable|Checks whether a storylet has a "repeatable" property set to true|LIST element| bool
|process_outcome|Executes the "outcome"\"outcome_negative" of a storylet|LIST element, bool|void
|get_highest_priority|Returns the ID of the storylet with the highest "priority" property inside a list|ref LIST element, LIST\VARLIST|int\float

#### Math functions
|Name|Description|Parameters|Returns|
|--|--|--|--|
|abs|Returns the absolute value of a number or operation|int\float|int\float
|alter|Executes +/- operations on variables, making sure they're within 0-100 range|ref int\float, int\float|int\float

#### Missions-related
|Name|Description|Parameters|Returns|
|--|--|--|--|
|allMissionsCount|Returns the count of all the Missions in the `allMissions` LIST|-|int
|get_open_missions|Returns a list of all the "open" Missions in the `allMissions` LIST|-|VARLIST
|get_available_missions|Collects available Missions by checking their prerequisites, then fills a VARLIST|ref VARLIST, int|VARLIST

#### Events-related
|Name|Description|Parameters|Returns|
|--|--|--|--|
|allEventsCount|Returns the count of all the Events in the `allEvents` LIST|-|int
|get_open_events|Returns a list of all the "open" Events in the `allEvents` LIST|-|VARLIST
|get_available_events|Collects available Events by checking their prerequisites, then fills a VARLIST|ref VARLIST, int|VARLIST
|reset_repeatable_events|Iterates through the `allEvents` LIST and re-activates the Events that are marked as "repeatable"|int|void

#### Other
|Name|Description|Parameters|Returns|
|--|--|--|--|
|planet_name|Generates a random name for a planet|-|string
|pop|Returns the top-most element of a list, "deactivating" it in the list|ref LIST\VARLIST|LIST element


### Debug threads
These are not functions, but ink threads that are used to display useful information for debugging purposes.

|Name|Description|
|--|--|
|debug_print_resources|Prints the value of all the Resources' variables
|debug_print_available_missions|Prints a list of all the Missions which prerequisites have been met
|debug_print_available_events|Prints a list of all the Events which prerequisites have been met
|debug_print_highest_priority_event|Prints the ID of the event with the highest priority


## Acknowledgements
I'd like to thank [Richard Cobbett](https://twitter.com/richardcobbett) for first showing me a use case for the "database function" in ink and, in general, for discussing the subject of Storylets in ink a lot over the last few months, along with [Cidney Hamilton](https://cidney.org) and [Dennis Plöger](https://deep-entertainment.de/). Other huge sources of tips and tricks have been the [inkle's official Discord](https://discord.gg/inkle) and [Patreon posts](https://www.patreon.com/inkle).

I'd also like to point out (in chronological order) some of the material I've been trying to study to come up with something useful. You will probably realize that the road to get there is likely still very long!

- [Story vs. Game: The Battle of Interactive Fiction (Doug Sharp, 1989)](https://dougsharp.wordpress.com/story-vs-game-the-battle-of-interactive-fiction/)
- [King of Dragon Pass: An Architecture Overview (David Dunham, 2011)](https://kingofdragonpass.blogspot.com/2011/02/architecture-overview.html)
- [Queens of the Phone Age: The Narrative Design of Reigns: Her Majesty (Leigh Alexander, 2018)](https://www.youtube.com/watch?v=qiV4Um77bnc)
 - [Storylets, you want them (Emily Short, 2019)](https://emshort.blog/2019/11/29/storylets-you-want-them/)
 - [Storylets Play Together (Emily Short, 2019)](https://emshort.blog/2019/12/03/storylets-play-together/)
 - [Pacing Storylet Structures (Emily Short, 2020)](https://emshort.blog/2020/01/21/pacing-storylet-structures/)
 - [Development Process for Storylet-based Interactive Fiction (Emily Short, 2020)](https://emshort.blog/2020/02/18/mailbag-development-process-for-storylet-based-interactive-fiction/)
 - [Talk and Workshop by Emily Short about Storylets (IF London Meetup, January 2020)](https://www.youtube.com/watch?v=0zDXcVc5zv0)
 - [Understanding Reigns through Storylet Design Terms (Dan Cox, 2021)](https://videlais.com/2021/01/01/understanding-reigns-2016-through-storylet-design-terms/)
