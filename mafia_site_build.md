# Mafia Site

Every six months or so, my friend runs a live-action version of the card game Mafia, but on steroids.  He used to run it by hand using Google forms, so I offered to build him a website to make it easier for the users and automate some of the more tedious calculations.

## Basic Game Design

The players are divided into townspeople and Mafia members.  They are also divided into families - so for example, family X has six members, one of which is also in the Mafia.  The basic idea is that every night, the Mafia discuss and select a certain number of players to kill.  In turn, each day every player votes for a family, and the family that gets the most number of votes is sent to court.  Each player also votes for a member of their own family.  Whichever family is sent to court, the player from within that family that got the most votes is voted out of the game.

To make things more complicated and interesting, players are also assigned any of a number of roles.  These roles let them affect every aspect of the game.  Most of my time was spent making sure these roles interacted properly.  They had a priority list and could affect each other.

Each player was given an ID number, and had to enter that ID number to perform any action.

There was some basic test coverage, but not comprehensive and not end-to-end.  It was still incredibly useful.

## Basic Website Design

Not that complicated.  A page for the rules, a page to sign up, a roster page, a page for day actions like voting, a page for night actions, and an admin page that had live updates on what people were doing.  There was a separate file that counted the votes and ordered them by family, and another separate file that ran the nightly actions.  Both of those latter programs were run via rake tasks at the command line.

## Role Processing

Role actions were saved with the ID number of the player who used them, the time they were submitted, and any targets.  Some roles had one target, some had several.  Most targeted players, but some targeted families.  Some effects lasted forever, some laster only that night, some lasted until they were activated.  In addition, players could submit actions several times, but only the latest submission would be counted.  However, within each role, earlier submissions took precedence over later ones.

I began by giving each player a status for each night.  This held the full player status - basically a record of the player's state at that night.

Then I took each role in priority order.  I sorted them by timestamp once newest-oldest to remove duplicate submissions, then reversed the list to process them.  For each action, I:

* find the list of targets
* Check if the player is actually assigned that role
* Check if the player's status allows him to use that role
* Check if the target list needs to be changed(one role randomly reassigned targets)
* Process the role:
  * Check for role-specific status issues.  Some statuses prevented certain roles from acting
  * Update the status for the target.  If it was a status that took effect until it was activated, that night and every future night's status was changed to reflect that.  If it was an effect that was activated, that night and every future night's status was reverted to default.
  * return a string describing what happened.

If I had to do it again, I'd find a better solution than dumping everything into a single `player_status` table.  Many of the effects didn't match up well to a "one-a-night" status.  There were also edge cases like "this role can be used an infinite number of times, but only once on yourself" and "this role can be used twice" that were difficult to cover.  I also didn't have the resolution needed to separate day and night effects.  It also wasn't idempotent - I could only run each night's actions once.  Maybe a role-player table with extra info about how the role has been used, and move some of the more awkward `player_status` stuff into there.

## Mistakes

This was my first time being solely responsibly for a production build from beginning to end, and I wasn't as thorough with my testing and building as I could have been.  I got the technical details ironed out but missed a lot of the business logic, which caused problems when running the game.  It didn't have a large impact because I was available to fix them immediately, but it was still somewhere to improve.

I also should have been more proactive about user acceptance testing.  The first time they really touched the site was the day before game launch.  I should have had them submit several fake rounds at least a week in advance as a shakedown.

## Conclusion

This was a fun build.  I've always enjoyed watching the game, and I'm happy I was able to help out.  People seemed to really enjoy using the website, and it definitely made the moderators' job a lot easier.
