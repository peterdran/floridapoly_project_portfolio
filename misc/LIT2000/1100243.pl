#Author: "ghernandez"
#Date: September 11, 2014 01:47 UTC?

print "Life and death are balanced on the edge of a razor.\n";

sub razorsEdge {
	$life=shift;
	$death=shift;

  if ($death == $life) {
    $life = int(rand($death+1)*2);
    $death = int(rand($life+1)*2);
  }

  $life++ if ($life < $death);
  $death-- if ($death > $life);

  $life-- if ($life > $death);
  $death++ if ($death < $life);

  razorsEdge($life, $death);
}

razorsEdge($life, $death);

