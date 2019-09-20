#!/usr/bin/perl -w
use strict;
my $Version = "2.3.5";

use lib '/usr/local/lib/perl5/site_perl/5.20.3';
use Net::MQTT::Simple;
use RiveScript;


my $MQTT=$ENV{'MQTT_SERVER'} || "mqtt";
my $MQTT_TOPIC_INPUT=$ENV{'MQTT_TOPIC_IN'} || "ai/input";
my $MQTT_TOPIC_OUTPUT=$ENV{'MQTT_TOPIC_OUT'} || "ai/output";

print STDERR "Bot AI V$Version Started\n";
print STDERR "Server: $MQTT\n";
print STDERR "Input Topic: $MQTT_TOPIC_INPUT\n";
print STDERR "Output Topic: $MQTT_TOPIC_OUTPUT\n";

# Create a new RiveScript interpreter.
my $rs = new RiveScript;
 
# Load a directory of replies.
$rs->loadDirectory ("./brain");
 
# Sort all the loaded replies.
$rs->sortReplies;

my $mqtt = Net::MQTT::Simple->new($MQTT);

$mqtt->login("bot-ai"); 

# Chat with the bot.
$mqtt->run(
    $MQTT_TOPIC_INPUT => sub {
	my $tstamp=localtime();
        my ($topic, $message) = @_;
        my ($PRIVATE, $UUID, $DATA) = split('&', "$message");
        my ($junk1, $PRIVATE1) = split('=', "$PRIVATE");
        my ($junk2, $AGENT) = split('=', "$UUID");
        my ($junk3, $message1) = split('=', "$DATA");
        my ($user, $msg) = split(/:/, $message1, 2);
        my @name = split / /, $user;
        print STDERR "[$tstamp] User: $name[0]\n";
        $msg =~ s/\+/ \+ / if $msg =~ /[0-9]/;
        $msg =~ s/\*/ \* / if $msg =~ /[0-9]/;
        $msg =~ s/\-/ \- / if $msg =~ /[0-9]/;
        $msg =~ s/\// \/ / if $msg =~ /[0-9]/;
        print STDERR "[$tstamp] MESSAGE: $msg\n";
        my $reply = $rs->reply ($user,$msg);
        print STDERR "[$tstamp] AI: $reply\n";
        $reply = "PRIVATE=$PRIVATE1&UUID=$AGENT&Message=$reply";
        $mqtt->publish($MQTT_TOPIC_OUTPUT => $reply);
    },
);