#1. Разобраться в работе утилиты Греп ( посмотреть кейсы, )
#2. Разобраться с чтением потока ввода в Перле
#3. Гетопт Лонг
#4. Реализовать греп без ключей.
#5. Последовательно добавить ключи.

#6. Посмотреть как искать подстроку в строке.
#7.С данными нужно работать как с потоком.
#! grep [опции] шаблон [имя файла...]
#! grep -A1     war     GREP.txt


use strict;
use warnings;
use Data::Dumper;
use 5.010;

use Getopt::Long;
Getopt::Long::Configure ( "bundling" );

my $A;
my $B;

GetOptions ( "A=i"   => \$A , # -A, --after-context=ЧИС   печатать ЧИСЛО строк последующего контекста
             "B=i"   => \$B , # -B, --before-context=ЧИС  печатать ЧИСЛО строк предшествующего контекста
);

my $arg;
my $right;
my @string;
my $string;
my $lines;
my @Array;
my @Strings;



open( FIL,"GREP.txt" );

if ( $A ) {
@Strings = <FIL>;
foreach my $line ( @Strings ){
    push @Array, $line ;  
}
print @Array[0,1];
#say $A; # 1
}

else {
$arg = shift @ARGV;

while( <FIL> ){
    $right = substr( $_, index( $_, $arg ) );
    push @string, $right ;
print $.;

}
#? Простейший Grep, выводит слово на экран,если оно есть в файле
$string = join("", @string );
$string =~ s/^\s+|\s+$//g;
say  $string;
}

close( FIL );



__END__
$arg = shift @ARGV;

while( <FIL> ){
    $right = substr( $_, index( $_, $arg ) );
    push @string, $right ;
    $lines++;
}
#? Простейший Grep, выводит слово на экран,если оно есть в файле
$string = join("", @string );
$string =~ s/^\s+|\s+$//g;


say $lines;  # посчитали количество строк в файле
say $string; # нашли искомое слово
close( FIL );

#? Поддержка ключей
#  grep -A1 war GREP.txt
#! war ↓
#  main


__END__

#TODO находит слово в файле по подстроке
open( FIL,"GREP.txt" );
while(<FIL>) {
    my $right = substr( $_, index( $_, "hello" ) );
    say $right;
}
close( FIL );

#TODO выводит аргументы командной строки на дисплей
while (my $arg = shift @ARGV ) {
    #print "$arg\n";
}

#TODO выводит данные с файла построчно ( разделителем является \n ). Запись в массив.
@string = <FIL>;
foreach my $line ( @string ){
    push @Array, $line ;
    
}
print Dumper @Array;

#! Рабочий код на поиск

open( FIL,"GREP.txt" );

$arg = shift @ARGV;

while( <FIL> ){
    $right = substr( $_, index( $_, $arg ) );
    push @string, $right ;
}
#? Простейший Grep, выводит слово на экран,если оно есть в файле
$string = join("", @string );
$string =~ s/^\s+|\s+$//g;
say $string;
close( FIL );