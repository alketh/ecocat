netcdf B057-D4_3D.2000.vol {
dimensions:
	longitude = 88 ;
	latitude = 82 ;
	depth = 2 ;
	time = UNLIMITED ; // (2 currently)
variables:
	float longitude(longitude) ;
		longitude:standard_name = "longitude" ;
		longitude:long_name = "longitude" ;
		longitude:units = "degrees_east" ;
		longitude:axis = "X" ;
	float latitude(latitude) ;
		latitude:standard_name = "latitude" ;
		latitude:long_name = "latitude" ;
		latitude:units = "degrees_north" ;
		latitude:axis = "Y" ;
	float depth(depth) ;
		depth:units = "meters" ;
		depth:axis = "Z" ;
	double time(time) ;
		time:standard_name = "time" ;
		time:units = "days since 2000-1-1 00:00:00" ;
		time:calendar = "standard" ;
		time:axis = "T" ;
	float VARNAME(time, depth, latitude, longitude) ;
		VARNAME:long_name = "XXX" ;
		VARNAME:units = "mmolN m-3" ;
		VARNAME:_FillValue = -9.999e+010f ;
		VARNAME:missing_value = -9.999e+010f ;

// global attributes:
		:CDI = "Climate Data Interface version 1.7.0 (http://mpimet.mpg.de/cdi)" ;
		:Conventions = "CF-1.4" ;
		:history = "Sun Nov 20 14:30:03 2016: cdo splitname tmp.nc B057-D4_3D.2000." ;
		:CDO = "Climate Data Operators version 1.7.0 (http://mpimet.mpg.de/cdo)" ;
data:

 longitude = -15.08333, -14.75, -14.41667, -14.08333, -13.75, -13.41667, 
    -13.08333, -12.75, -12.41667, -12.08333, -11.75, -11.41667, -11.08333, 
    -10.75, -10.41667, -10.08333, -9.75, -9.416667, -9.083333, -8.75, 
    -8.416667, -8.083333, -7.75, -7.416667, -7.083333, -6.75, -6.416667, 
    -6.083333, -5.75, -5.416667, -5.083333, -4.75, -4.416667, -4.083333, 
    -3.75, -3.416667, -3.083333, -2.75, -2.416667, -2.083333, -1.75, 
    -1.416667, -1.083333, -0.75, -0.4166667, -0.08333334, 0.25, 0.5833333, 
    0.9166667, 1.25, 1.583333, 1.916667, 2.25, 2.583333, 2.916667, 3.25, 
    3.583333, 3.916667, 4.25, 4.583333, 4.916667, 5.25, 5.583333, 5.916667, 
    6.25, 6.583333, 6.916667, 7.25, 7.583333, 7.916667, 8.25, 8.583333, 
    8.916667, 9.25, 9.583333, 9.916667, 10.25, 10.58333, 10.91667, 11.25, 
    11.58333, 11.91667, 12.25, 12.58333, 12.91667, 13.25, 13.58333, 13.91667 ;

 latitude = 47.68333, 47.88334, 48.08333, 48.28333, 48.48333, 48.68333, 
    48.88334, 49.08333, 49.28333, 49.48333, 49.68333, 49.88334, 50.08333, 
    50.28333, 50.48333, 50.68333, 50.88334, 51.08333, 51.28333, 51.48333, 
    51.68333, 51.88334, 52.08333, 52.28333, 52.48333, 52.68333, 52.88334, 
    53.08333, 53.28333, 53.48333, 53.68333, 53.88334, 54.08333, 54.28333, 
    54.48333, 54.68333, 54.88334, 55.08333, 55.28333, 55.48333, 55.68333, 
    55.88334, 56.08333, 56.28333, 56.48333, 56.68333, 56.88334, 57.08333, 
    57.28333, 57.48333, 57.68333, 57.88334, 58.08333, 58.28333, 58.48333, 
    58.68333, 58.88334, 59.08333, 59.28333, 59.48333, 59.68333, 59.88334, 
    60.08333, 60.28333, 60.48333, 60.68333, 60.88334, 61.08333, 61.28333, 
    61.48333, 61.68333, 61.88334, 62.08333, 62.28333, 62.48333, 62.68333, 
    62.88334, 63.08333, 63.28333, 63.48333, 63.68333, 63.88334 ;

 depth = 5, 12.5 ;

 time = 0, 1 ;

 VARNAME =
;
}
