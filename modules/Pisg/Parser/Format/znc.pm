package Pisg::Parser::Format::znc;

# Documentation for the Pisg::Parser::Format modules is found in Template.pm

use strict;
$^W = 1;

sub new
{
    my ($type, %args) = @_;
    my $self = {
        cfg => $args{cfg},
        normalline => '^\[(\d+):\d+(?:\:\d+)?\] <([^>]+)> (.*)$',
        actionline => '^\[(\d+):\d+(?:\:\d+)?\] \* (\S+) (.+)$',
        thirdline  => '^\[(\d+):(\d+)(?:\:\d+)?\] \*{3} (\S+) (\S+) (.*)$',
    };

    bless($self, $type);
    return $self;
}

sub normalline
{
    my ($self, $line, $lines) = @_;
    my %hash;

    if ($line =~ /$self->{normalline}/o) {

        $hash{hour}   = $1;
        $hash{nick}   = $2;
        $hash{saying} = $3;

        return \%hash;
    } else {
        return;
    }
}

sub actionline
{
    my ($self, $line, $lines) = @_;
    my %hash;

    if ($line =~ /$self->{actionline}/o) {

        $hash{hour}   = $1;
        $hash{nick}   = $2;
        $hash{saying} = $3;

        return \%hash;
    } else {
        return;
    }
}

sub thirdline
{
    my ($self, $line, $lines) = @_;
    my %hash;

    if ($line =~ /$self->{thirdline}/o) {

        $hash{hour} = $1;
        $hash{min}  = $2;
        $hash{nick} = $3;

        if ($3 eq 'Joins:') {
            $hash{newjoin} = $4;
            $hash{nick} = $4;
        } elsif ($4 eq 'changes') {
            $5 =~ /^topic to (.*)$/;
            $hash{newtopic} = $1;
        } elsif ($4 eq 'is') {
            $5 =~ /^now known as (.*)$/;
            $hash{newnick} = $1;
        }

        return \%hash;

    } else {
        return;
    }
}

1;

