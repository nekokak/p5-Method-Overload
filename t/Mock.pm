package Mock;
use strict;
use warnings;
use Method::Overload;

def say => setting {
    install {
        args qw/twitt/;
        callback {
            my ($self, $args) = @_;
            return $args->{twitt}. '...';
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

