package Method::Overload;
use strict;
use warnings;
use List::MoreUtils qw/all/;
use Data::Dumper;

our $VERSION = '0.01';

sub import {
    my $caller = caller(0);

    no strict 'refs';
    for my $func (qw/def install args callback _get_caller_class setting/) {
        *{"$caller\::$func"} = \&$func;
    }

    my $_def_info = {};
    *{"$caller\::def_info"} = sub { $_def_info };
}

sub _get_caller_class {
    my $caller = caller(1);
    return $caller;
}

sub def ($$) { ## no critic.
    my ($func_name, $setting) = @_;

    my $class = _get_caller_class;
    $class->def_info->{stack}->{_installing_stack_count} = 0;

    $setting->();

    my $code = sub {
        my ($self, $args) = @_;

        for my $stack (sort keys %{$class->def_info->{stack}}) {
            my $do_it=1;
            for my $key (@{$class->def_info->{stack}->{$stack}->{args}}) {
                unless (exists $args->{$key}) {
                    $do_it=0;
                }
            }

            if ($do_it) {
                return $class->def_info->{stack}->{$stack}->{callback}->($self, $args);
            }
        }

        die 'no match!';
    };

    no strict 'refs'; ## no critic.
    *{"$class\::$func_name"} = $code;
}

sub setting (&) { shift } ## no critic.
sub install (&) { ## no critic.
    my $code = shift;

    my $class = _get_caller_class;
    $class->def_info->{stack}->{_installing_stack_count}++;
    $code->();
}

sub callback (&)  { ## no critic.
    my $code = shift;

    my $class = _get_caller_class;
    my $stack_count = $class->def_info->{stack}->{_installing_stack_count};
    $class->def_info->{stack}->{$stack_count}->{callback} = $code;
}

sub args (@) { ## no critic.
    my @args = @_;

    my $class = _get_caller_class;
    my $stack_count = $class->def_info->{stack}->{_installing_stack_count};
    $class->def_info->{stack}->{$stack_count}->{args} = \@args;
}

=head1 NAME

Method::Overload - method overload definition

=head1 SYNOPSIS

    package Mock;
    use strict;
    use warnings;
    use Method::Overload;
    
    def say => setting {
        install {
            args qw/twitt/;
            callback {
                my ($self, $args) = @_;
                return $args->{twitt};
            };
        };
        install {
            args qw/shout/;
            callback {
                my ($self, $args) = @_;
                return $args->{shout}. '!!!';
            };
        };
        install {
            callback {
                return 'ya';
            }
        };
    };
    
    1;

    # in your script:
    Mock->say();                # ya
    Mock->say({twitt => 'ya'}); # ya...
    Mock->say({shout => 'ya'}), # ya!!!

=head1 DESCRIPTION

method orverload.
use argments.

=head1 AUTHOR

Atsushi Kobayashi <nekokak __at__ gmail.com>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;
