# DigitalMedia-Democracy
This repository contains the code used in Rstudio to conduct the analysis for out project on Fox News and politicians' tweets polarity

## The project in a nutshell

### Context
In recent years, the American conservative news outlet Fox News has increasingly taken the centre stage in the right-wing media landscape. It became one of the reference points which echoed many conspiracy theories and, more specifically, claims of former President Donald J. Trump. Fox News, together with One America News Network, InfoWars, and others became the 45th President’s personal propaganda machine confirming and amplifying the narratives he was pushing.

Our study is an attempt to analyse the influence that Fox News had on US officials in the 116th senate through a quantitative analysis of tweets between 2018 and 2022. Our aim is to dive deeper into the discovery of how much polluted news organisations, such as Fox News, impact the communication of politicians on both sides of the spectrum.

The study was conducted in two parts based on 385,060 tweets of Senators in the 116th US Congress. The first part of the study is exploratory and descriptive, where the data is analysed based on various metrics such as the connection to Fox News, polarity and popularity. The second part consists of a linear regression analysis testing for a relationship between the senators’ connection to Fox News and the polarity of their tweets. The regression analyses were conducted as OLS regressions using the ‘jtools’ library according to the following questions and formulas:

> ***Q<sub>1</sub>: How much does the exposure to Fox News twitter content influence the polarity of a politician's tweets?***

`Average polarity of senator account = ß<sub>0</sub> + ß<sub>1</sub>·connection to fox + ß<sub>2</sub>·religion + ß<sub>3</sub>·party + ß<sub>4·popularity`

> ***Q<sub>2</sub>: What is the effect of mentioning Fox News in a post on the tweets polarity?***

`Tweet polarity = ß<sub>0</sub> + ß<sub>1</sub>*·connection to fox + ß<sub>2</sub>·religion + ß<sub>3</sub>·party + ß<sub>4·</sub>popularity + ß<sub>5</sub>·mentioning fox + ß<sub>6</sub>·related to fox`




