/*
    Basic bot setup
*/
key CORRADE = "" ;
string GROUP = "";
string PASSWORD = "";
list seperator = ["ȵ"];

// This is the holder for the CORRADE callback address
string callback = "";
integer private = 1; //Set the speach responce to public or private


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



default {
    state_entry() {
        llOwnerSay("Booting the Bot Brain");
        state url;
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

state url {
    state_entry() {
        // DEBUG
        llOwnerSay("Requesting URL...");
        llRequestURL();
    }
    http_request(key id, string method, string body) {
        if(method != URL_REQUEST_GRANTED) return;
        callback = body;
        // DEBUG
        llOwnerSay("Got URL...");
        state instant_notify;
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
                    // Subscribe to Corrade AI
                    "action", "subscribe",
                    // Corrade AI listening host.
                    "host", "192.168.1.222",
                    // Corrade AI listening port.
                    "port", 1883,
                    // Corrade AI credentials.
                    "username", "corrade",
                    "secret", "corrade",
                    // Use the SIML module of Corrade AI.
                    "topic", "ai/output",
                    "id", "c0e367f2-20f1-4c32-a723-3d4bd3795ca3",
                    // Send the result of the MQTT command to this URL.
                    "callback", wasURLEscape(callback),
                    // By adding an URL, Corrade will subscribe AND bind to the "MQTT" notification.
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
    }
    http_request(key id, string method, string body) {
        llHTTPResponse(id, 200, "OK");
         llOwnerSay("HTTP Recieved");
         llOwnerSay("HTTP Body: "+body);
        string Message;
        string MessageBody = llToLower(wasURLUnescape( wasKeyValueGet("message", body) ));
        string orgMessageBody = wasURLUnescape( wasKeyValueGet("message", body) );
        string MSGType = wasURLUnescape( wasKeyValueGet("type", body));
        string WhoAsked = wasURLUnescape( wasKeyValueGet("agent", body));
    if( MSGType == "MQTT") {
            // Get the sent message.
            llOwnerSay("MQTT Recieved");
            string data = wasURLUnescape(wasKeyValueGet("payload", body));
            string msgid = wasURLUnescape(wasKeyValueGet("id", body));
            if ( msgid == "c0e367f2-20f1-4c32-a723-3d4bd3795ca3" ) 
            {
            WhoAsked = wasKeyValueGet("UUID", data);
            private = (integer)wasURLUnescape(wasKeyValueGet("PRIVATE", data));
            Message = wasURLUnescape(wasKeyValueGet("Message", data));
            //
            // If UUID == COMMAND and private == 4 then load var's
            // private == 0 public chat
            // private == 1 private chat
            // if private == 2 then send group chat
            // if private == 3 then send notice
            //          

            if ( private == 1) 
            {
                llMessageLinked(LINK_THIS, 0, "Tellȵ"+(string)CORRADE+"ȵ"+(string)WhoAsked+"ȵ"+Message+"ȵ"+callback, ""); 
                 return;
            }
        }
    }

       if ( MSGType == "message" )
       { 
          string uname = wasURLUnescape( wasKeyValueGet("firstname", body));
          string lname = wasURLUnescape( wasKeyValueGet("lastname", body));
          MessageBody = llToLower(wasURLUnescape( wasKeyValueGet("message", body) )); 
          string username=llKey2Name(WhoAsked);
          MessageBody = username+": "+MessageBody;
          private = 1;
          llOwnerSay("Sending to MQTT");
          llMessageLinked(LINK_THIS, 0, "MQTTȵ"+(string)CORRADE+"ȵ"+WhoAsked+"ȵ"+(string)private+"ȵ"+MessageBody+"ȵ"+callback, ""); 
        }
    }
}

