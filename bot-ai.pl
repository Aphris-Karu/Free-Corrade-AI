#!/usr/bin/perl
use Net::MQTT::Simple;
use RiveScript;
my $Version = "2.3";
my $MQTT=$ENV{'MQTT_SERVER'} || "mqtt";
my $MQTT_TOPIC_IN=$ENV{'MQTT_TOPIC_IN'} || "ai/input"; 
my $MQTT_TOPIC_OUT=$ENV{'MQTT_TOPIC_OUT'} || "ai/output";

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
    $MQTT_TOPIC_IN => sub {
        my ($topic, $message) = @_;
        my ($PRIVATE, $UUID, $DATA) = split('&', "$message");
        my ($junk1, $PRIVATE) = split('=', "$PRIVATE");
        my ($junk1, $AGENT) = split('=', "$UUID");
        my ($junk1, $message) = split('=', "$DATA");
        my $reply = $rs->reply ('localuser',$message);

         print "$message\n"; 
         print "AI: $reply\n";
         $reply = "PRIVATE=$PRIVATE&UUID=$AGENT&Message=$reply";
         $mqtt->publish($MQTT_TOPIC_OUT => $reply);
    },
);
