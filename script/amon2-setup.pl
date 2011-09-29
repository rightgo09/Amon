#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib/";
use Getopt::Long;
use Pod::Usage;
use Amon2::Setup;
use Cwd ();

my @flavors;
GetOptions(
    'help'      => \my $help,
    'flavor=s@' => \@flavors,
) or pod2usage(0);
pod2usage(1) if $help;
push @flavors, 'Basic' if @flavors == 0;
@flavors = map { split /,/, $_ } @flavors;

&main;exit;

sub main {
    my $module = shift @ARGV or pod2usage(0);
       $module =~ s!-!::!g;

    # $module = "Foo::Bar"
    # $dist   = "Foo-Bar"
    my @pkg  = split /::/, $module;
    my $dist = join "-", @pkg;

    mkdir $dist or die "Cannot mkdir '$dist': $!";
    chdir $dist or die $!;

    my $setup = Amon2::Setup->new(module => $module);
    $setup->run(@flavors);
}

__END__

=head1 NAME

amon2-setup.pl - setup script for amon2

=head1 SYNOPSIS

    % amon-setup.pl MyApp

        --flavor=Basic   basic flavour(default)
        --flavor=Lite    Amon2::Lite flavour
        --flavor=Minimum minimalistic flavour for benchmarking

        --help   Show this help

=head1 DESCRIPTION

This is a setup script for Amon2.

amon2-setup.pl is highly extensible. You can write your own flavor.

=head1 HINTS

You can specify C<< --flavor >> option multiple times. For example, you can
type like following:

    % amon-setup.pl --flavor=Basic --flavor=Teng MyApp

Second flavor can overwrite files generated by first flavor.

=head1 AUTHOR

Tokuhiro Matsuno

=cut
