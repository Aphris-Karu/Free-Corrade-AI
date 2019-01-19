/*
    Basic bot setup
    Fill in with your bots info
*/
string configurationFile = ".Config";
string CORRADE = "" ;
string GROUP = "";
string PASSWORD = "";
string MQTT_HOST = "";
string MQTT_PORT = "1883";
string MQTT_USER = "corrade";
string MQTT_PASS = "corrade";
string MQTT_TOPIC_OUT = "ai/output";
string MQTT_TOPIC_IN = "ai/input";
string MQTT_ID = "c0e367f2-20f1-4c32-a723-3d4bd3795ca3";
list seperator = ["ȵ"];

// This is the holder for the CORRADE callback address
string callback = "";

integer private = 1; //Set the speach responce to public or private

integer line;
key readLineId;
string AvatarName;
string FavoriteColor;

/*
  Script functions
*/
init()
{
    // Is there a config notecard
    if(llGetInventoryType(configurationFile) != INVENTORY_NOTECARD)
    {
        llOwnerSay("Missing Configuration file: " + configurationFile);
        return;
    }
    line = 0;
    readLineId = llGetNotecardLine(configurationFile, line++);
}

processConfiguration(string data)
{
    if(data == EOF)
    {
        llOwnerSay("Done reading the configuration");
        state url;
    }

    if(data != "")
    {
        // if the line does not begin with a comment
        if(llSubStringIndex(data, "#") != 0)
        {
            // find first equal sign
            integer i = llSubStringIndex(data, "=");

            // if line contains equal sign
            if(i != -1)
            {
                // get name of name/value pair
                string name = llGetSubString(data, 0, i - 1);

                // get value of name/value pair
                string value = llGetSubString(data, i + 1, -1);

                // trim name
                list temp = llParseString2List(name, [" "], []);
                name = llDumpList2String(temp, " ");

                // trim value
                temp = llParseString2List(value, [" "], []);
                value = llDumpList2String(temp, " ");

                if(name == "CORRADE")  CORRADE = value;
                if(name == "GROUP")   GROUP = value;
                if(name == "PASSWORD")  PASSWORD = value;
                if(name == "MQTT_HOST")  MQTT_HOST = value;
                if(name == "MQTT_PORT")  MQTT_PORT = value;
                if(name == "MQTT_USER")  MQTT_USER = value;
                if(name == "MQTT_PASS")  MQTT_PASS = value;
                if(name == "MQTT_TOPIC_OUT")  MQTT_TOPIC_OUT = value;
                if(name == "MQTT_TOPIC_IN")  MQTT_TOPIC_IN = value;
                if(name == "MQTT_ID")  MQTT_ID = value;
            }
            else  // line does not contain equal sign
            {
                llOwnerSay("Configuration could not be read on line " + (string)line);
            }
        }
    }

    // read the next line
    readLineId = llGetNotecardLine(configurationFile, line++);

}

string wasKeyValueGet(string k, string data) {
    if(llStringLength(data) == 0) return "";
    if(llStringLength(k) == 0) return "";
    list a = llParseString2List(data, ["&", "="], []);
    integer i = llListFindList(llList2ListStrided(a, 0, -1, 2), [ k ]);
    if(i != -1) return llList2String(a, 2*i+1);
    return "";
}

string wasKeyValueEncode(list data) {
    list k = llList2ListStrided(data, 0, -1, 2);
    list v = llList2ListStrided(llDeleteSubList(data, 0, 0), 0, -1, 2);
    data = [];
    do {
        data += llList2String(k, 0) + "=" + llList2String(v, 0);
        k = llDeleteSubList(k, 0, 0);
        v = llDeleteSubList(v, 0, 0);
    } while(llGetListLength(k) != 0);
    return llDumpList2String(data, "&");
}

string wasURLEscape(string i) {
    string o = "";
    do {
        string c = llGetSubString(i, 0, 0);
        i = llDeleteSubString(i, 0, 0);
        if(c == "") jump continue;
        if(c == " ") {
            o += "+";
            jump continue;
        }
        if(c == "\n") {
            o += "%0D" + llEscapeURL(c);
            jump continue;
        }
        o += llEscapeURL(c);
@continue;
    } while(i != "");
    return o;
}
string wasURLUnescape(string i) {
    return llUnescapeURL(
        llDumpList2String(
            llParseString2List(
                llDumpList2String(
                    llParseString2List(
                        i, 
                        ["+"], 
                        []
                    ), 
                    " "
                ), 
                ["%0D%0A"], 
                []
            ), 
            "\n"
        )
    );
}

/*
  Start main body of script.
*/
default {
    state_entry() {
        llOwnerSay("Booting the Bot Brain");
        llSetColor(<0.75,0.75,0.75>, ALL_SIDES);
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
        init();
    }
        on_rez(integer num) {
        llResetScript();
    }
    changed(integer change) {
        if((change & CHANGED_INVENTORY) || (change & CHANGED_REGION_START)) {
            llResetScript();
        }
    }
    dataserver(key request_id, string data)
    {
        if(request_id == readLineId)
            processConfiguration(data);

    }
}

state url {
    state_entry() {
        llOwnerSay("Requesting URL...");
        llRequestURL();
    }
    http_request(key id, string method, string body) {
        if(method != URL_REQUEST_GRANTED) return;
        callback = body;
        // DEBUG
        llOwnerSay("Got URL...");
        state detect;
    }
    on_rez(integer num) {
        llResetScript();
    }
    changed(integer change) {
        if((change & CHANGED_INVENTORY) || (change & CHANGED_REGION_START)) {
            llResetScript();
        }
    }
}
 
state detect {
    state_entry() {
        llOwnerSay("Detecting if Corrade bot is online");
        llSetTimerEvent(10);
    }
    timer() {
        llRequestAgentData((key)CORRADE, DATA_ONLINE);
    }
    dataserver(key id, string data) {
        if(data != "1") {
            // DEBUG
            llOwnerSay("Bot is not online, sleeping...");
            llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
            llSetColor(<0.75,0.75,0.75>, ALL_SIDES);
            llSetTimerEvent(30);
        } else {
           llOwnerSay("Bot is online...");
           llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
           llSetColor(<1.0, 1.0, 1.0>, ALL_SIDES);
           state instant_notify;
        }
    }
    on_rez(integer num) {
        llResetScript();
    }
    changed(integer change) {
        if((change & CHANGED_INVENTORY) || (change & CHANGED_REGION_START)) {
            llResetScript();
        }
    }
}

state instant_notify {
    state_entry() {
        // DEBUG
        llOwnerSay("Binding to the instant messages notification...");
        llInstantMessage(
            (key)CORRADE, 
            wasKeyValueEncode(
                [
                    "command", "notify",
                    "group", wasURLEscape(GROUP),
                    "password", wasURLEscape(PASSWORD),
                    "action", "set",
                    "type", "message",
                    "URL", wasURLEscape(callback),
                    "callback", wasURLEscape(callback)
                ]
            )
        );
    }
    http_request(key id, string method, string body) {
        llHTTPResponse(id, 200, "OK");
        if(wasKeyValueGet("command", body) != "notify" ||
            wasKeyValueGet("success", body) != "True") {
            // DEBUG
            llOwnerSay("Failed to bind to the instant message notification...");
            state instant_notify;
        }
        // DEBUG
        llOwnerSay("Instant message notification installed...");
        state MQTT_AI;
    }
    on_rez(integer num) {
        llResetScript();
    }
    changed(integer change) {
        if((change & CHANGED_INVENTORY) || (change & CHANGED_REGION_START)) {
            llResetScript();
        }
    }
}

state MQTT_AI {
    state_entry() {
        // DEBUG
        llOwnerSay("Binding to MQTT AI interface...");
          llInstantMessage(CORRADE,
            wasKeyValueEncode(
                [
                    "command", "MQTT",
                    "group", wasURLEscape(GROUP),
                    "password", wasURLEscape(PASSWORD),
                    "action", "subscribe",
                    "host", MQTT_HOST,
                    "port", MQTT_PORT,
                    "username", MQTT_USER,
                    "secret", MQTT_PASS,
                    "topic", MQTT_TOPIC_OUT,
                    "id", MQTT_ID,
                    "callback", wasURLEscape(callback),
                    "URL", wasURLEscape(callback)
                ]
            )
        );
    }
    http_request(key id, string method, string body) {
        llHTTPResponse(id, 200, "OK");
        if(wasKeyValueGet("command", body) != "MQTT" ||
            wasKeyValueGet("success", body) != "True") {
            // DEBUG
            llOwnerSay("Failed to bind to the MQTT service...");
            llOwnerSay("Message: "+body);
            llResetScript();
        }
        // DEBUG
        llOwnerSay("MQTT Interface installed...");
        state reply;
    }
    on_rez(integer num) {
        llResetScript();
    }
    changed(integer change) {
        if((change & CHANGED_INVENTORY) || (change & CHANGED_REGION_START)) {
            llResetScript();
        }
    }
}

state reply {
    state_entry() {
        // DEBUG
        llOwnerSay("Bot AI Online and Ready"); 
        llSetTimerEvent(30);
    }
    
    http_request(key id, string method, string body) {
        llHTTPResponse(id, 200, "OK");
        string Message;
        string MessageBody = llToLower(wasURLUnescape( wasKeyValueGet("message", body) ));
        string orgMessageBody = wasURLUnescape( wasKeyValueGet("message", body) );
        string MSGType = wasURLUnescape( wasKeyValueGet("type", body));
        string WhoAsked = wasURLUnescape( wasKeyValueGet("agent", body));
    if( MSGType == "MQTT") {
            // We have a message from the AI via MQTT, time to process it.
            string data = wasURLUnescape(wasKeyValueGet("payload", body));
            string msgid = wasURLUnescape(wasKeyValueGet("id", body));
            if ( msgid == MQTT_ID ) 
            {
            WhoAsked = wasKeyValueGet("UUID", data);
            private = (integer)wasURLUnescape(wasKeyValueGet("PRIVATE", data));
            Message = wasURLUnescape(wasKeyValueGet("Message", data));
            //
            // This is how I use the private variable within my scripts.
            // 
            // If UUID == COMMAND and private == 4 then this is the AI sending a command to the bot.
            // private == 0 public chat
            // private == 1 private chat
            // private == 2 then send group chat
            // private == 3 then send notice
            //          

            if ( private == 1) 
            {
                llInstantMessage(CORRADE,
                  wasKeyValueEncode(
                  [
                      // send the reply to an avatar
                      "command", "tell",
                      "group", wasURLEscape(GROUP),
                      "password", wasURLEscape(PASSWORD),
                      "agent", WhoAsked,
                      "entity", "avatar",
                      "dialog", "MessageFromAgent",
                      "message", Message, 
                      "callback", callback
                 ]
               )
             );
                 return;
            }
        }
    }

       if ( MSGType == "message" )
       { 
           // We just got a message from the Avatar
          string uname = wasURLUnescape( wasKeyValueGet("firstname", body));
          string lname = wasURLUnescape( wasKeyValueGet("lastname", body));
          MessageBody = llToLower(wasURLUnescape( wasKeyValueGet("message", body) )); 
          MessageBody = uname+" "+lname+": "+MessageBody;
          private = 1;
          // Send the message to MQTT to be processed by the AI
          llInstantMessage(CORRADE,
            wasKeyValueEncode(
                [
                    "command", "MQTT",
                    "group", wasURLEscape(GROUP),
                    "password", wasURLEscape(PASSWORD),
                    "action", "publish",
                    "host", MQTT_HOST,
                    "port", MQTT_PORT,
                    "username", MQTT_USER,
                    "secret", MQTT_PASS,
                    "topic", MQTT_TOPIC_IN,
                    "payload", wasURLEscape(
                        wasKeyValueEncode(
                            [
                                "PRIVATE", private,
                                "UUID", WhoAsked,
                                "Message", MessageBody
                            ]
                        )
                    ),
                    "callback", wasURLEscape(callback)
                ]
            )
        );
       }
    }
    
    timer() {
        llRequestAgentData((key)CORRADE, DATA_ONLINE);
    }
    
    dataserver(key id, string data) {
        if(data != "1") {
            llOwnerSay("Bot is not online, sleeping...");
            llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
            llSetColor(<0.75, 0.75, 0.75>, ALL_SIDES);
            state detect;
        }
    }
    
}
