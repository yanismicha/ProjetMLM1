% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_quanti.R
\name{plot_quanti}
\alias{plot_quanti}
\title{permet de faire un plot quantitatif}
\usage{
plot_quanti(
  plot_type = "Histogram",
  data,
  variable_quanti1,
  variable_quanti2,
  variable_binaire,
  modalites = "Aucune",
  breaksHist = 10,
  breaksBox = 1,
  ajust = "non",
  discr = "non",
  type = "classique"
)
}
\arguments{
\item{plot_type}{le type de plot ('histogramme','Density','boxplot','scatterplot')}

\item{data}{un dataframe}

\item{variable_quanti1}{une variable quantitative.}

\item{variable_quanti2}{une variable quantitative.}

\item{variable_binaire}{une variable indicatrice.}

\item{modalites}{choix de la modalite a discriminer.}

\item{breaksHist}{le nombre de tranches pour un histogramme}

\item{breaksBox}{le nombre de tranches pour un boxplot}

\item{ajust}{ajustement de la taille des box si 'oui'.}

\item{discr}{discrimination par une modalite si 'oui'.}

\item{type}{le type de graphe utilise ('classique','ggplot','plotly')}
}
\description{
permet de faire un plot quantitatif
}
