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

# функция для поиска искомой подстроки в строке
my $regexpTrue;

my @queue; # очередь строк
my $down = $A;
my $up = $B;
my $downCheck;

	$regexpTrue = sub { # принцип оказался довольно прост - функция index возвращает всегда(!) только значение 0 и выше, если искомая подстрока в строке присутсвует и возвращает -1, если его нет
		my $a = shift;
		if ( index( $_, $regexp ) >= 0 ){
            return $_;
        }
	};

while ( <STDIN> ) {
	if ( $regexpTrue -> ( $_ ) ) { # TODO Вызов функции по ссылке ????
	# шаблон совпал - проверяем очередь и печатаем
		if ( scalar @queue > 0 ) { # очередь строк еще есть ? @queue - Массив,списковый контекст
			push @queue, $_;
			for ( 0..$#queue ) { # $#queue - соответствует последнему элементу списка
				print ( $queue[ $_ ] ); # выводит указанные значения из массива
			}
		}
	$up--;
	}
	elsif( $up ){ 
		if( scalar @queue < $up ){
			push @queue, $_;
		}else{
			shift @queue;
			push @queue, $_;
		}
	}	
}

