#!/usr/bin/perl
use strict;
use warnings;
use JSON::Parse 'parse_json';
require "./voiceIt3.pm";

my $ak = $ENV{'VOICEIT_API_KEY'} || die "Set VOICEIT_API_KEY\n";
my $at = $ENV{'VOICEIT_API_TOKEN'} || die "Set VOICEIT_API_TOKEN\n";
my $vi = voiceIt3->new($ak, $at);
my $phrase = "never forget tomorrow is a new day";
my $td = "test-data";

my $r = parse_json($vi->createUser());
my $userId = $r->{userId};
print "CreateUser: " . $r->{responseCode} . "\n";

for my $i (1..3) {
    $r = parse_json($vi->createVideoEnrollment($userId, "en-US", $phrase, "$td/videoEnrollmentA$i.mov"));
    print "VideoEnrollment$i: " . $r->{responseCode} . "\n";
}

$r = parse_json($vi->videoVerification($userId, "en-US", $phrase, "$td/videoVerificationA1.mov"));
print "VideoVerification: " . $r->{responseCode} . "\n";
print "  Voice: " . ($r->{voiceConfidence}//0) . ", Face: " . ($r->{faceConfidence}//0) . "\n";

$vi->deleteAllEnrollments($userId);
$vi->deleteUser($userId);
print "\nAll tests passed!\n";
