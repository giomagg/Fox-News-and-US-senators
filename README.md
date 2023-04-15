# DigitalMedia-Democracy
This repository contains the code used in Rstudio to conduct the analysis for out project on Fox News and politicians' tweets polarity

## The project in a nutshell

Here below we report extracts from the final paper. The information her reported are not comprehensive of the overall discussion and descriptive statistical analysis conducted. They simply aim to give the reader an idea of the overall framework and findings of the project. 

### Context
In recent years, the American conservative news outlet Fox News has increasingly taken the centre stage in the right-wing media landscape. It became one of the reference points which echoed many conspiracy theories and, more specifically, claims of former President Donald J. Trump. Fox News, together with One America News Network, InfoWars, and others became the 45th President’s personal propaganda machine confirming and amplifying the narratives he was pushing.

Our study is an attempt to analyse the influence that Fox News had on US officials in the 116th senate through a quantitative analysis of tweets between 2018 and 2022. Our aim is to dive deeper into the discovery of how much polluted news organisations, such as Fox News, impact the communication of politicians on both sides of the spectrum.

## Methods
The study was conducted in two parts based on 385,060 tweets of Senators in the 116th US Congress. The first part of the study is exploratory and descriptive, where the data is analysed based on various metrics such as the connection to Fox News, polarity and popularity. The second part consists of a linear regression analysis testing for a relationship between the senators’ connection to Fox News and the polarity of their tweets. The regression analyses were conducted as OLS regressions using the ‘jtools’ library according to the following questions and formulas:

> ***Q<sub>1</sub>: How much does the exposure to Fox News twitter content influence the polarity of a politician's tweets?***

_Average polarity of senator account = ß<sub>0</sub> + ß<sub>1</sub>·connection to fox + ß<sub>2</sub>·religion + ß<sub>3</sub>·party + ß<sub>4</sub>·popularity_

> ***Q<sub>2</sub>: What is the effect of mentioning Fox News in a post on the tweets polarity?***

_Tweet polarity = ß<sub>0</sub> + ß<sub>1</sub>·connection to fox + ß<sub>2</sub>·religion + ß<sub>3</sub>·party + ß<sub>4·</sub>popularity + ß<sub>5</sub>·mentioning fox + ß<sub>6</sub>·related to fox_

In trying to evaluate how much connection to Fox News influences the polarity of an account, we control for religious orientation, popularity of the account, and political party. Similarly to establish the relationship between a single tweets polarity and the connection to Fox News we again control for religious orientation, party affiliation, popularity of the account, but additionally include whether the tweet mentioned Fox News and whether it was related to Fox News.

## Findings
Our hypothesis was that the interaction with Fox increases the negativity of the tweets content based on the assumption that its polarising themes would bring a more emotionally extreme reaction to them. From our descriptive analysis (here not reported) we found that, first, the tweets with Fox-related content are statistically more likely to come from Republican senators’ accounts, and, second, mentioning Fox News or echoing its contents on Twitter negatively influence the type of language used.

Running the first regression analysis we find that, first, the effect of the connection to Fox News on a politician’s communication is statistically significant at the 1% level. As we expected, the relationship we found is a negative one ( -0.1 ) although it is not as influential as we first thought. What this means is that once we account for religion, party membership, popularity, and number of tweets of the account, the raw effect of being connected to Fox News is negative. The more a senator interacts with the Fox News Twitter account, the more negative its content will become. Our model explains 21% of the variance (adjusted R-squared) in the average polarity and thus has a rather significant explanatory power.

Running the second regression we also found a statistically significant result at the 1% level and identified a negative relation between the two variables. However, in this case the model is not robust enough and it explains only 1% of the variance in the polarity of all the senators’ tweets.

#### Output Regression 1 


#### Output Regression 2
 <div align="center"> 
<img width="600" alt="Fig_2" src="https://user-images.githubusercontent.com/55432992/232209643-a67e6f33-c539-41cd-acbc-ab13196aaa50.png">
 <br><br>
</div>



