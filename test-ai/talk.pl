#!/usr/bin/perl -w
use strict;
my $Version = "2.3.4";
my $I = 0;
use lib '/usr/local/lib/perl5/site_perl/5.20.3';
#use Net::MQTT::Simple;
use RiveScript;
#my $MQTT=$ENV{'MQTT_SERVER'} || "mqtt";
#my $MQTT_TOPIC_INPUT=$ENV{'MQTT_TOPIC_IN'} || "ai/input";
#my $MQTT_TOPIC_OUTPUT=$ENV{'MQTT_TOPIC_OUT'} || "ai/output";

print STDERR "Sex Bot AI V$Version Started\n";
#print STDERR "Server: $MQTT\n";
#print STDERR "Input Topic: $MQTT_TOPIC_INPUT\n";
#print STDERR "Output Topic: $MQTT_TOPIC_OUTPUT\n";

# Create a new RiveScript interpreter.
my $rs = new RiveScript;
 
# Load a directory of replies.
$rs->loadDirectory ("./brain");
 
# Sort all the loaded replies.
$rs->sortReplies;

#my $mqtt = Net::MQTT::Simple->new($MQTT);

#$mqtt->login("bot-ai"); 

while ( $I == 0 ) {
print ">: ";
my $message = <STDIN>;
chomp $message;
$message = "SecondLife Resident: $message";
        #print "MESSAGE: $message\n";
        my $reply = $rs->reply ('localuser',$message);
        print "AI: $reply\n";
