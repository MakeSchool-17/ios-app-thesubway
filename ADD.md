#App Design Document


##Objective
TournaMake is an app that allows users to create tournaments, using any tournament format they want.
This can apply to any kind of competition. Whether it's Smash, Football, Chess, Rock-Paper-Scissors, etc.

##Audience
This app is for people who want to create and host tournaments.
These can be anyone who likes to organize events. It does not matter what their income is.
##Experience


##Technical

####External Services
	MDSpreadView
	Email (for feedback)
	Facebook, Twitter (for sharing)
####Screens
	1a. Login screen. This appears upon launch of app. Here the user will enter their email and password to log in.
	1b. Sign-Up screen. Can get here from the login screen. They must enter name, email, password, and password confirmation, to create account. Emails must be unique from other users' emails.
	2. Tournaments screen. This appears after user successfully logs in. There is a plus icon in the toolbar on the top-right, which user can press to add tournaments.
	3. Create tournament page, which shows up after user taps the add button. User selects stage format from drop-down menu. User also enters a tournament name, and all Entrants' names.
	As this gets entered, the entrant count will be updated accordingly.
	4. Groupings page. The groups will be randomly filled out through an algorithm, but afterward the user may edit the group placings at this stage.
	5. Knockout stage page. Only the qualified teams advance to this stage. The match-ups will be pre-determined by an algorithm, but afterward the user may determine which seeds face each other in the first round.
	User must also determine if there will be a third place match or not.
	Once user completes this page, the tournament is successfully created.
	6. Tournament information split-view page. This page appears after (i) successful creation of tournament, or (ii) user selects this tournament from Tournaments screen.
	The Tournament split-view page contains 3 tabs: Standings, group, and bracket.
	6b.As the user enters scores in the group tab, the Standings tab will be updated to show how each team is doing. Also, the bracket page will show which teams would advance "if knockout stage were to start now". However, bracket scores are not editable until all group stage matches are complete.
	6c.Once knockout stage is editable, user may update the scores of those matches.
	6d.Once all knockout stage scores are updated, the tournament will be complete, and a results tab will appear, to show final rankings.
####Views / View Controllers/ Classes

####Data Models

##MVP Milestones