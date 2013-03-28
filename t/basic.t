use strictures;

package basic_test;

use Test::InDistDir;
use Test::More;
use Test::Fatal 'exception';

use Moo;
use MooX::OneArgHas;

run();
done_testing;
exit;

sub run {

    my $lazy;
    ok(
        !exception {
            has( three => sub { 3 } );
        },
        "one-arg accessor installed"
    );
    ok(
        !exception {
            has( four => ( is => 'lazy', builder => sub { $lazy++; 4 } ) );
        },
        "normal accessor installed"
    );

    like(
        exception {
            has five => sub { 4 } => ( is => 'lazy' );
        },
        qr/\QAccessor 'basic_test::five' cannot take further arguments.\E/,
        "accessor accepts only a single argument if a leading default is given",
    );

    ok( my $t = __PACKAGE__->new, "object creation still works" );

    is( $t->three, 3, "one-arg accessor returns expected value" );

    is( $lazy,    undef, "normal accessor is still lazy" );
    is( $t->four, 4,     "normal accessor returns expected value" );

    like(
        exception { $t->five },
        qr/Can't locate object method "five" via package "basic_test"/,
        "one-arg accessor with extra args not installed"
    );

    return;
}
