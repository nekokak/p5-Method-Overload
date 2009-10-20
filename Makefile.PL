use inc::Module::Install;
name 'Method-Overload';
all_from 'lib/Method/Overload.pm';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
