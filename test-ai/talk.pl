#!/usr/bin/perl -w
use strict;
my $Version = "2.3.5";
my $I = 0;
use lib '/usr/local/lib/perl5/site_perl/5.20.3';
use RiveScript;

print STDERR "Bot AI V$Version Started\n";

# Create a new RiveScript interpreter.
my $rs = new RiveScript;
 
# Load a directory of replies.
$rs->loadDirectory ("./brain");
 
# Sort all the loaded replies.
$rs->sortReplies;

while ( $I == 0 ) {
print ">: ";
my $message = <STDIN>;
chomp $message;
$message = "Secondlife Resident: $message";
        print "MESSAGE: $message\n";
        my ($user, $msg) = split(/:/, $message, 2);
        my @name = split / /, $user;
        print "User: $name[0]\n";
        $message =~ s/\+/ \+ / if $message =~ /[0-9]/;
        $message =~ s/\*/ \* / if $message =~ /[0-9]/;
        $message =~ s/\-/ \- / if $message =~ /[0-9]/;
        $message =~ s/\// \/ / if $message =~ /[0-9]/;
        my $reply = $rs->reply ($name[0],$msg);
        print "AI: $reply\n";


