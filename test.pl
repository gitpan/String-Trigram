# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'.
# A command parameter evaluating to true will make the script more verbose
#########################

use Test;
use strict;
BEGIN { plan tests => 11 };
use String::Trigram qw (compare);

my %tests = ();
my $verbose = $ARGV[0];

$tests{"identical strings"} =
  sub {((compare("abc", "abc")             == 1) and
        (compare("abbbcdef", "abbbcdef")   == 1) and
        (compare("abcdefghi", "abcdefghi") == 1))};

$tests{"completely different strings"} =
  sub {((compare("abc", "def")                 == 0) and
        (compare("abcdef", "ghkl")             == 0) and
        (compare("abcdefghi", "jklmnopqrurwt") == 0))};

$tests{"several tokens of one trigram type"} =
  sub {((compare("abcabc", "abcabc") == 1) and
        (compare("abc", "abcabc")    == 0.5))};

$tests{"compare a to b equals compare b to a"} =
  sub {compare("kangaroo", "cockatoo") == compare("cockatoo", "kangaroo")};

$tests{"warp"} =
  sub {sprintf("%.2f", compare("abc", "abcabc", warp => 1.5)) == 0.65};

$tests{"keep only alphanumerics"} =
  sub {((compare("a+bc%}", "--:a.b?c##", keepOnlyAlNums => 1) == 1) and
        (compare("a+bc%}", "--:a.b?c##", keepOnlyAlNums => 0) == 0))};

$tests{"ignore case"} =
  sub {sprintf("%.2f", compare("abc", "abcabc", warp => 1.5)) == 0.65};

$tests{"warp"} =
  sub {((compare("abc", "AbC", ignoreCase => 1) == 1) and
        (compare("abc", "AbC", ignoreCase => 0) == 0))};

$tests{"reInit"} =
  sub {
         my $trig = new String::Trigram(cmpBase => ["abc", "def", "ghi"]);
         $trig->reInit(["jkl", "mno"]);
         my $res = {};
         return 1 if (($trig->getSimilarStrings("abc", $res) == 0) and
                      ($trig->getSimilarStrings("mno", $res) == 1));
         return 0;
      };

$tests{"getBestMatch"} =
  sub {
         my $trig = new String::Trigram(cmpBase => ["abc", "abcabc", "aabc"]);
         my $sims = {};
         my $best = [];

         $trig->getSimilarStrings("abc", $sims);

         return 1 if (($trig->getBestMatch("abc", $best) == 1) and
                      (@$best == 1) and
                      ($best->[0] eq "abc"));
         return 0;
      };

$tests{"minSim"} =
  sub {
         my $trig = new String::Trigram(cmpBase => ["abc", "abcabc", "aabc"]);
         my $sims1 = {};
         my $sims2 = {};

         my $msBeg = $trig->minSim();

         $trig->getSimilarStrings("abc", $sims1);

         $trig->minSim(0.9);

         $trig->getSimilarStrings("abc", $sims2);

         my $msEnd = $trig->minSim();

         return 1 if (($msBeg == 0)        and
                      ($msEnd == 0.9)      and
                      (keys(%$sims1) == 3) and
                      (keys(%$sims2) == 1));
         return 0;
      };

$tests{"padding"} =
  sub {((compare("abc", "aabc", padding => 0)   == 1/2) and
        (compare("abc", "aabc", padding => 1)   == 2/5) and
        (compare("abc", "aabc", padding => 1.5) == 2/5) and
        (compare("abc", "aabc", padding => 2)   == 4/7))};

my @names   = keys(%tests);
my $longest = getLongestName();

foreach (sort(@names))
{
  testMe($_, $longest);
}

sub testMe
{
  my $name = shift;
  my $lon  = shift;

  print "testing: $name ", '.' x ($lon + 3 - length ($name)), ' ' if $verbose;
  ok($tests{$name});
}

sub getLongestName
{
  my $len = 0;

  foreach (@names)
  {
    $len = length if (length > $len);
  }

  return $len;
}

#########################
