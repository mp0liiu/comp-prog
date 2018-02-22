use v5.18;
use warnings;
use utf8;
use Data::Dumper;
use constant INF => 999999;
sub line { chomp(my $str = <>); $str; }
sub split_line { (split / /, line) }

main();

sub solve {
  my ($grid, $h, $w) = @_;
  # return -1 if $start->{color} eq '#';
  my @directions = (
    { x => 1, y => 0 },
    { x => 0, y => 1 },
    { x => -1, y => 0 },
    { x => 0, y => -1 },
  );
  my $start = $grid->[0][0];
  $start->{distance} = 1;
  my @queue = ($start);
  while (my $mass = pop @queue) {
    for my $direction (@directions) {
      my $point = {
        x => $mass->{x} + $direction->{x},
        y => $mass->{y} + $direction->{y},
      };
      my $adjacent = $grid->[ $point->{y} ][ $point->{x} ];
      if ( $point->{x} >= 0
        && $point->{y} >= 0
        && $point->{x} < $w
        && $point->{y} < $h
        && $adjacent->{color} eq '.' 
        && $adjacent->{distance} == INF )
      {
        $adjacent->{distance} = $mass->{distance} + 1;
        unshift @queue, $adjacent;
      }
    }
  }
  my $black_num = 0;
  for my $y (0 .. $h - 1) {
    for my $x (0 .. $w - 1) {
      $black_num++ if $grid->[$y][$x]->{color} eq '#'
    }
  }
  my $goal = $grid->[$h - 1][$w - 1];
  if ($goal->{distance} == INF) {
    -1;
  } else {
    ($h * $w - $goal->{distance}) - $black_num;
  }
}

sub main {
  my ($h, $w) = split_line;
  my $grid = [];
  for my $y (0 .. $h - 1) {
    my @line = split //, line;
    $grid->[$y] = [
      map {
        +{
          y => $y,
          x => $_,
          color => $line[$_],
          distance => INF,
        }
      } (0 .. $w - 1)
    ];
  }
  say solve($grid, $h, $w);
}

__END__

# https://abc088.contest.atcoder.jp/tasks/abc088_d

