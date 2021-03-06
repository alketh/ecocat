% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eco-to-tidy.R
\name{eco_to_tidy}
\alias{eco_to_tidy}
\title{Convert netcdf output from ECOHAM simulation to tidy dataframe.}
\usage{
eco_to_tidy(nc)
}
\arguments{
\item{nc}{connection to the netcdf file to read in.}
}
\value{
tidy dataframe with columns longitude, latitude, depth, time, variable-name, ecohambox-id.
}
\description{
Read in netcdf output array from ECOHAM simulation and convert it to a tidy dataframe to allow
coupling with atlantistools output.
}
\examples{
nc <- system.file(package = "ecocat", "extdata/volume.nc")
vol <- eco_to_tidy(nc)
}
