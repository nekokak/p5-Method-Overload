use strict;
use warnings;
use Test::Declare;
use lib './t';
use Mock;

plan tests => blocks;

describe 'Class::Py tests' => run {
    test 'def say' => run {
        is +Mock->say(), 'ya';
        is +Mock->say({twitt => 'ya'}), 'ya...';
        is +Mock->say({shout => 'ya'}), 'ya!!!';
    };
};

