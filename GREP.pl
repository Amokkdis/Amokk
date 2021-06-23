#!/usr/bin/env perl
#1. Разобраться в работе утилиты Греп ( посмотреть кейсы, )
#2. Разобраться с чтением потока ввода в Перле
#3. Гетопт Лонг
#4. Реализовать греп без ключей.
#5. Последовательно добавить ключи.

#6. Посмотреть как искать подстроку в строке.
#7.С данными нужнsо работать как с потоком.

#? ПОИСК подстроки в строке Perl
#? Разобраться с @ARGV ARGС

#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use 5.010;
use Getopt::Long qw/:config no_ignore_case/;

# шаблон
my $regexp = $ARGV[ $#ARGV ]; # $#ARGV - соответствует последнему элементу списка ARGV; мой вариант с "shift @ARGV" почему то не сработал

# иницализация значений ключей ( иначе - предупреждения )
my $A = 0;
my $B = 0;
my $C = 0;

GetOptions ( 
             'A=i' => \$A,
	         'B=i' => \$B,
	         'C=i' => \$C,
) or die "Incorrect key";

# функция для сравнения с учетом ключей
my $regexpTrue;

	$regexpTrue = sub { # принцип оказался довольно прост - функция index возвращает всегда(!) только значение 0 и выше, если искомая подстрока в строке присутсвует и возвращает -1, если его нет
		my $a = shift;
		if ( index( $_, $regexp ) >= 0 ){
            return $_;
        }
	};

#  функция для печати строк с номером
sub printLine { # Пользовательские функции позволяют многократно применять написанный фрагмент кода в программе.
	my ( $foo ) = @_; # Perl автоматически сохраняет список параметров(другое название списка аргументов) в специальной переменной массива с именем @_ на время всего вызова функции. Функция может обратиться к этой переменной, чтобы узнать как количество аргументов,так и их значения.
	print $foo;
}

my $up = $B > $C ? $B : $C; # если значение ключа 'B' больше значения ключа 'C' , в переменную занести 'B' ; в ином случае - 'C' 
my $down = $A > $C ? $A : $C;  # если значение ключа 'A' больше значения ключа 'C' , в переменную занести 'A' ; в ином случае - 'C' 
my $downCheck; # проверка выведения нижеследующих строк при наличии down
my @queue; # очередь строк

while ( <STDIN> ) {
		# случай наличия отступов
		if ( $regexpTrue -> ( $_ ) ) { # TODO Вызов функции по ссылке ????
			# шаблон совпал - проверяем очередь и печатаем
			if ( scalar @queue > 0 ) { # очередь строк еще есть ? @queue - Массив,списковый контекст
				for ( 0..$#queue ) { # $#queue - соответствует последнему элементу списка
					printLine ( $queue[ $_ ] ); # выводит указанные значения вверх по списку при ключе С , начиная от искомого
				}
			}
			printLine ( $_ ); # выводит текущее искомое значение
			$downCheck = $down; # устанавливаем downcheck для печати нижнего отступа
		}
		# шаблон не совпал - но есть нижний отступ
		elsif ( $downCheck ) {
			printLine ( $_ ); # выводит указанные значения вниз по списку при ключе С , начиная от искомого
			$downCheck--; # уменьшаем количество строк соответственно
		}
		#если есть верхний отступ - заполняем очередь
		elsif ( $up ) {
			if ( scalar @queue < $up ) {
				push @queue, $_;
			} else {
				shift @queue;
				push @queue, $_;
			}
		}
	}






__END__
#! grep [опции] шаблон [имя файла...]
#! grep -A1     war     GREP.txt


use strict;
use warnings;
use Data::Dumper;
use 5.010;

my $right;
my @string;
my $string;
my $arg;

$arg = shift @ARGV;
open ( FIL , "GREP.txt" );
while( <FIL> ){
    $right = substr( $_, index( $_, $arg ) );
    push @string, $right ;
    
}
#? Простейший Grep, выводит слово на экран,если оно есть в файле
$string = join("", @string );
$string =~ s/^\s+|\s+$//g;



say $string; # нашли искомое слово
close( FIL );

__END__

use Getopt::Long;
Getopt::Long::Configure ( "bundling" );


my $arg = shift @ARGV;
my $right = substr( $_, index( $_, $arg ) );
print $arg;

while( <> ){
    print $_;
    if ( $arg eq substr )
}



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