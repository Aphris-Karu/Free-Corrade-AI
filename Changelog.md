2.3.5
 * Fixed issue with usernames that have numbers in them
 * Fixes issue with bot not being able to do math.
 * bot now properly sets up a table in memory for each user it speaks with
   keeping the user vars separate.
   
*BREAKS!
   Because of the changes to the way it handles user names, the triggers in 
   rive are no longer required to start with an _ \[\*\]. 

2.3.3
 * Fixed issues with mqtt communications.
 * Added proper output lines for logging to stderr for docker container.
     - you can now see a log of all chats via docker log.
