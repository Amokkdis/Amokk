#!/usr/bin/env perl
use 5.016;
use warnings;
use Getopt::Long qw/:config no_ignore_case/;
use Data::Dumper;
use List::Util qw /uniq/;
# хеш ключей
my %key = (
	'A' => 0,
	'B' => 0,
	'C' => 0
);

# шаблон
my $regexp = $ARGV[ $#ARGV ]; # TODO -разобрать

GetOptions ( \%key,
	'A=i',
	'B=i',
	'C=i',
	'c'  ,
	'i'  ,
	'v'  ,
	'F'  ,
	'n'
) or die "Incorrect key";

# функция для сравнения с учетом ключей
my $regexpTrue;

if ( $key{'i'} && $key{'F'} ) {
	$regexpTrue = sub {
		my $a = shift;
		chomp $a;
		return 1 + index( lc $a, lc $regexp ); # lc $a - передается строка, lc $regexp - искомая строка. Ф-я index принимает две строки и возвращает положение второй строки внутри первой
	};
}
elsif ( $key{'F'} ) {
	$regexpTrue = sub {
		my $a = shift;
		chomp $a;
		return 1 + index( $a, $regexp );
	};
}
elsif ( $key{'i'} ) {
	$regexpTrue = sub {
		my $a = shift;
		chomp $a;
		return $a =~ /$regexp/i;
	};
} else {
	$regexpTrue = sub {
		my $a = shift;
		chomp $a;
		return $a =~ /$regexp/;
	};
}

my $n = 0;

my $up = $key{'B'} > $key{'C'} ? $key{'B'} : $key{'C'}; # если значение ключа 'B' больше значения ключа 'C' , в переменную занести 'B' ; в ином случае - 'C' 
my $down = $key{'A'} > $key{'C'} ? $key{'A'} : $key{'C'};  # если значение ключа 'A' больше значения ключа 'C' , в переменную занести 'A' ; в ином случае - 'C' 
my $downCheck; # проверка выведения нижеследующих строк при наличии down
my $prev = 0; # последняя выведенная строчка
my @queue; # очередь строк
my @queueNum; # очередь номеров строк
#  функция для печати строк с номером
sub printLine { # Пользовательские функции позволяют многократно применять написанный фрагмент кода в программе.
	my ($foo, $bar) = @_; # Perl автоматически сохраняет список параметров(другое название списка аргументов) в специальной переменной массива с именем @_ на время всего вызова функции. Функция может обратиться к этой переменной, чтобы узнать как количество аргументов,так и их значения.
	print "$bar." if $key{'n'};
	print $foo;
}

while (<STDIN>) {
	# ключ с - считаем количество строк
	if ( $key{'c'} ) {
		$n++ if ( $key{'v'} ? !$regexpTrue->($_) : $regexpTrue->($_) );
	}
	# если нет ключей А В С v
	elsif ( !$key{'A'} && !$key{'B'} && !$key{'C'} ) {
		printLine ($_, $.) if ( $key{'v'} ? !$regexpTrue->($_) : $regexpTrue->($_) ); # $_ В эту переменную по умолчанию происходит ввод, присваивание, в нее складываются результаты поиска по заданному образцу. $. Эта переменная содержит номер строки, которая была почитана последней из файла, который был прочитан последним. Она также доступна только для чтения
	} else {
		# случай наличия отступов
		if ( $regexpTrue->($_) ) {
			# шаблон совпал - проверяем очередь и печатаем
			if ( scalar @queue > 0 ) {
				print "--\n" if ( $prev &&
						  $queueNum[0] - $prev > 1 );
				for ( 0..$#queue ) {
					printLine ($queue[$_], $queueNum[$_]);
				}
			} else {
				print "--\n" if ( $prev &&
								  $. - $prev > 1 );
			}
			printLine ($_, $.);
			$prev = $.;
			$downCheck = $down; # устанавливаем downcheck для печати нижнего отступа
			@queue = ();
			@queueNum = ();
		}
		# шаблон не совпал - но есть нижний отступ
		elsif ( $downCheck ) {
			printLine ($_, $.);
			$prev = $.;
			$downCheck--;
		}
		#если есть верхний отступ - заполняем очередь
		elsif ( $up ) {
			if ( scalar @queue < $up ) {
				push @queue, $_;
				push @queueNum, $.;
			} else {
				shift @queue;
				shift @queueNum;
				push @queue, $_;
				push @queueNum, $.;
			}
		}
	}
}

print "$n\n" if $key{'c'};