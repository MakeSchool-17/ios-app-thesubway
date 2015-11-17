#App Design Document


##Objective
TournaMake is an app that allows users to create tournaments, using any tournament format they want.
This can apply to any kind of competition. Whether it's Smash, Football, Chess, Rock-Paper-Scissors, etc.

##Audience
This app is for people who want to create and host tournaments.
These can be anyone who likes to organize events. It does not matter what their income is.
##Experience
A user wants to create a tournament. They plan to make it group stage + knockout stage format. They open the app, and sign-up with their name, email, and password.
-Afterward, they receive a confirmation email.
-Then they log in using their email address, and password.
-They create a tournament pressing the plus button.
-They select group stage + knockout from the dropdown menu.
-They name it "MyTournament1", and add 15 entrants into tournament.
-The tournament generates 4 groups-of-4. However, since there are only 15 teams, marks one of the slots as "--leave empty--", then fills each remaining slot with one randomly chosen entrant.
-The user decides to change the entrants around a little, before completing the groupStage setup.
-The user is then taken to the knockout stage setup page. The default is:
A1 vs B2, C1 vs D2, A2 vs B1, C2 vs D1.
-User wants only 7 teams to qualify for this stage. So they change:
C1 vs D2
to
C1 vs --bye--
-The user wants a 3rd place match, so they will leave the "3rd place consolation?" box checked.
-The user is now finished, and the tournament is successfully created.

-The user is now taken back to the tournaments page, where the list now contains their newly created tournament. They tap that tournament.
-The group stage of the tournament is opened. The user may now enter the scores for the round 1 games. If any team is on bye, their scores won't get entered.
As the scores get entered, the standings update according to the scores.
-Once the user finishes entering all scores for group stage, the knockout stage begins.
-As usual, the user will update knockout stage scores. The winner of each game advances to the next round. The semi-final losers will have a match against each other to determine 3rd place.
Once the user updates all scores, the tournament is finished, and the final rankings are displayed.

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
	UI items:
	Login (vc)
	SignUp (vc)
	Tournaments (vc)
		Tournaments List (tableView of cells each containing tournament name, and timestamp of creation. If tournament is completed)
	CreateTournament (pop-up view)
	CreateGroupStage (vc)
	CreateKnockout (vc)

	classes:
	User
		-name
		-email address
		-hashed password
		-tournaments
	Tournament
		-id
		-name (must contain at least 1 non-space character)
	Match
		-id
		-leftScore (default "")
		-rightScore (default "")
		-isFinished (default false)
		-leftId
		-rightId
		-result(id), which lists input team's score first, followed by opposing team's score.
	Entrant
		-id (starts from 0, then increments. Limit 100 entrants.)
		-matches (array of all matches they are involved in)
		-wins (updated after matches update)
		-losses
		-ties
		-differential (all statistical variables update upon match updates)
	Standings
		-MDSpreadView
			-each row is 1 entrant.
			-each column is data (Rank, W, L, T, Pts, etc.)
	Bracket
		-ScrollView
		-matches (array of all knockout matches)

####Data Models
	User
	Tournament (each tournament belongs to a user)
	Entrant (each entrant belongs to a tournament)
	Match (tournament has reference to match; entrant has reference to their matches)
	Standings (property of tournament)
	Bracket (property of tournament)
##MVP Milestones
	Week 1 (11/16-11/20):
		-Implement mock design into storyboard.
		-Hard-code entrants.
		-Pre-hardcode schedules, but allow user to manually change assignments.
		-Allow user to manually update knockout stage.
	Week 2 (11/23-11/25):
		-Set up backend for user, tournament, entrants, matches (schedule).
		-Implement user authentication.
		-Implement core data models for user, tournament, entrants, matches (schedule).
	Week 3 (11/30-12/04):
		-Add MDSpreadView for hardcoded standings.
		-Add functionality for default tournament schedules.
		-Add functionality for brackets (based off current standings).
	Week 4 (12/07-12/11):
		-Set up backend for standings and bracket.
		-Implement core data models for standings and bracket.
		-Add functionality to calculate final rankings.