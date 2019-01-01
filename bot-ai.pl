#!/usr/bin/perl
use Net::MQTT::Simple;
use RiveScript;
my $Version = "2.3";
my $MQTT=$ENV{'MQTT_SERVER'} || "mqtt";
 
# Create a new RiveScript interpreter.
my $rs = new RiveScript;
 
# Load a directory of replies.
$rs->loadDirectory ("./brain");
 
# Sort all the loaded replies.
$rs->sortReplies;

my $mqtt = Net::MQTT::Simple->new($MQTT);
 
# Chat with the bot.
print "Bot AI V$Version Started\n";

$mqtt->run(
    "ai/input" => sub {
        my ($topic, $message) = @_;
        my ($PRIVATE, $UUID, $DATA) = split('&', "$message");
        my ($junk1, $PRIVATE) = split('=', "$PRIVATE");
        my ($junk1, $AGENT) = split('=', "$UUID");
        my ($junk1, $message) = split('=', "$DATA");
        print "$message\n";
        my $reply = $rs->reply ('localuser',$message);

        open(my $fh, '>>', 'chat.log');
         print $fh "$message\n"; 
         print $fh "KellyAI: $reply\n";
         $reply = "PRIVATE=$PRIVATE&UUID=$AGENT&Message=$reply";
         close $fh;
         $mqtt->publish("ai/output" => $reply);
    },
);

