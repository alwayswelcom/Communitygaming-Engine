#include "Timer.hpp"

time_point		Timer::_epoch = high_resolution_clock::now();
// std::map< std::string, time_point >	Timer::_timePoints = std::map< std::string, time_point >();

// GETTER
double			Timer::getMicrotime( void )
{
	return ( ( (double)clock() / (double)CLOCKS_PER_SEC ) );
}

long double		Timer::currentNanoSecond( void )
{
	return ( time(0) );
}

const std::string	Timer::currentDateTime( void )
{
	return ( Timer::currentDateTime( "%Y-%m-%d.%X" ) );
}

const std::string	Timer::currentDateTime( const std::string & format )
{
	time_t		now = time( 0 );
	struct tm	tStruct;
	char		buf[80];

	tStruct = *localtime( &now );
	strftime( buf, sizeof( buf ), format.c_str(), &tStruct );
	return ( buf );
}
