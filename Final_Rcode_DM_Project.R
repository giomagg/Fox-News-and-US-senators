############################################################################

#                         FINAL PROJECT <-  TIDY CODE

############################################################################
rm(list = ls(all=T))

####### Load necessary libraries
library(readr)
library(tidyr)
library(tidyverse)
library(lubridate)
library(DescTools)
library(ggforce)
library(ggrepel)
library(jtools)

####### Load the necessary datasets + set working directory to where the files are stored

FINAL_senator_tweets <- read_csv("Correct_FINAL_sen_tweets.csv")
sen_infoFINAL <- read_delim("Senator_Info.csv", delim = ";")

#work with df to maintain original dataset
df <- FINAL_senator_tweets


###########################################################################################

#################### Creating new variables and compiling new dataframes

####working on df

#calculate norm_popularity
df <- df %>%
  group_by(user_screen_name) %>%
  mutate(avg_user_followers = mean(user_followers))%>%
  ungroup()%>%
  mutate(norm_popularity = (avg_user_followers - min(avg_user_followers)) / (max(avg_user_followers) - min(avg_user_followers)))

#create new Month and Year column to make it easier to work with dates
df <- df%>%
  mutate(Date_tweet = as.Date(local_time),
         Time_tweet = format(as.POSIXct(local_time), format = "%H:%M:%S"),
         Month_Yr = format_ISO8601(Date_tweet, precision = "ym"), 
         day = day(Date_tweet))

#adds the average polarity per user, per month
df <- df %>%
  group_by(user_screen_name, Month_Yr)%>%
  mutate(avg_polarity = mean(polarity))%>%
  ungroup()

####working on direct mentions and related twets

#gathering all direct mentions and combining into one dataframe
mention_foxnews1 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%@foxnews%", ]
mention_foxnews2 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%@Foxnews%", ]
mention_foxnews3 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%@FoxNews%", ]
mention_foxnews4 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%@FOXNews%", ]
mention_foxnews5 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%@FOXNEWS%", ]

mention_foxnews <- rbind(mention_foxnews1,mention_foxnews2,mention_foxnews3,mention_foxnews4,mention_foxnews5)
save(mention_foxnews, file = "sen-mention_foxnews.rdata")
rm(mention_foxnews1, mention_foxnews2, mention_foxnews3, mention_foxnews4, mention_foxnews5)

#gathering all related tweets and combining into one dataset
related_tweets1 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%fox news%", ]  
related_tweets2 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Fox News%", ] 
related_tweets3 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%fox & friends%", ]  
related_tweets4 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%fox and friends%", ]  
related_tweets5 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%foxnews%", ] 
related_tweets6 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%fox news politics%", ] 
related_tweets7 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%FOX NEWS%", ] 
related_tweets8 <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Fox news%", ] 

related_tweets <- rbind(related_tweets1, related_tweets2, related_tweets3, related_tweets4, related_tweets5,
                        related_tweets6, related_tweets7, related_tweets8)
save(related_tweets, file="sen_related_tweets.rdata")
rm(related_tweets1, related_tweets2, related_tweets3, related_tweets4,
   related_tweets5, related_tweets6, related_tweets7, related_tweets8)

#makes new column for month and year as above to make it easier to work with dates
mention_foxnews <- mention_foxnews %>%
  mutate(Date_tweet = as.Date(local_time),
         Time_tweet = format(as.POSIXct(local_time), format = "%H:%M:%S"),
         Month_Yr = format_ISO8601(Date_tweet, precision = "ym"), 
         day = day(Date_tweet))

related_tweets <- related_tweets%>%
  mutate(Date_tweet = as.Date(local_time),
         Time_tweet = format(as.POSIXct(local_time), format = "%H:%M:%S"),
         Month_Yr = format_ISO8601(Date_tweet, precision = "ym"), 
         day = day(Date_tweet))

####working on commentators/anchors

#finding all tweets mentioning the commentators by their names
Baier <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Bret Baier%", ] 
Carlson <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Tucker Carlson%", ] 
Watter <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Jessy Watters%", ] 
Bartiromo <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Maria Bartiromo%", ] 
Bongino <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Ben Bongino%", ] 
Cain <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Will Cain%", ] 
CamposDuffy <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Rachel Campos-Duffy%", ] 
Cavuto <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Neil Cavuto%", ] 
Doocy <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Steve Doocy%", ] 
Earhardt <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Ainsley Earhardt%", ] 
Folkner <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Harris Folkner%", ] 
Gowdy <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Trey Gowdy%", ] 
Gutfeld <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Gregg Gutfeld%", ] 
Kudlow <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Larry Kudlow%", ] 
Kurtz <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Howard Kurtz%", ] 
Hannity <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Sean Hannity%", ]  
Hegseth <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Pete Hegseth%" , ] 
Hilton <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Steve Hilton%" , ] 
Ingrahm <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Laura Ingraham%" , ] 
Jenkins <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Griff Jenkins%" , ] 
Kilmeade <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Brian Kilmeade%" , ] 
LevinMark <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Mark Levin%", ] 
LevinHarvey <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Harvey Levin%", ] 
MacCallum <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Martha MacCallum%", ] 
McDowell <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Dagen McDowell%", ]  
Perino <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Dana Perino%" , ] 
Pirro <- FINAL_senator_tweets[FINAL_senator_tweets$text %like% "%Jeanine Pirro%" , ] 

#list of commnetators names
commentators_names <- c("Baier", "Carlson", "Watter", "Bartiromo", "Bongino", "Cain", "Campos Duffy", 
                        "Cavuto", "Doocy", "Earhardt", "Folkner", "Gowdy", "Gutfeld", "Kudlow", "Kurtz", 
                        "Hannity", "Hegseth", "Hilton", "Ingraham", "Jenkins", "Kilmeade", "Levin Harvey", 
                        "Levin Mark", "MacCallum", "McDowell", "Perino", "Pirro")

#creating columns for commentators names
Baier["commentator"] = commentators_names[1]
Carlson["commentator"] = commentators_names[2]
Watter["commentator"] = commentators_names[3]
Bartiromo["commentator"] = commentators_names[4]
Bongino["commentator"] = commentators_names[5]
Cain["commentator"] = commentators_names[6]
CamposDuffy["commentator"] = commentators_names[7] 
Cavuto["commentator"] = commentators_names[8]
Doocy["commentator"] = commentators_names[9]
Earhardt["commentator"] = commentators_names[10]
Folkner["commentator"] = commentators_names[11]
Gowdy["commentator"] = commentators_names[12]
Gutfeld["commentator"] = commentators_names[13]
Kudlow["commentator"] = commentators_names[14]
Kurtz["commentator"] = commentators_names[15]
Hannity["commentator"] = commentators_names[16]
Hegseth["commentator"] = commentators_names[17]
Hilton["commentator"] = commentators_names[18]
Ingrahm["commentator"] = commentators_names[19]
Jenkins["commentator"] = commentators_names[20]
Kilmeade["commentator"] = commentators_names[21]
LevinHarvey["commentator"] = commentators_names[22]
LevinMark["commentator"] = commentators_names[23]
MacCallum["commentator"] = commentators_names[24]
McDowell["commentator"] = commentators_names[25]
Perino["commentator"] = commentators_names[26]
Pirro["commentator"] = commentators_names[27]

#combine all tweets of the commentators, only those who were actually mentioned will be included
commentators <- rbind(Baier, Carlson, Watter, Bartiromo, Bongino, Cain, CamposDuffy, 
                      Cavuto, Doocy, Earhardt, Folkner, Gowdy, Gutfeld, Kudlow, Kurtz, 
                      Hannity, Hegseth, Hilton, Ingrahm, Jenkins, Kilmeade, LevinHarvey, 
                      LevinMark, MacCallum, McDowell, Perino, Pirro)

save(commentators, file="commentators.rdata")
rm(Baier, Carlson, Watter, Bartiromo, Bongino, Cain, CamposDuffy, 
   Cavuto, Doocy, Earhardt, Folkner, Gowdy, Gutfeld, Kudlow, Kurtz, 
   Hannity, Hegseth, Hilton, Ingrahm, Jenkins, Kilmeade, LevinHarvey, 
   LevinMark, MacCallum, McDowell, Perino, Pirro)


###################################################################################################

########### Creating the Graphs and Charts

#### Time Graph for mentions and related tweets over time

#summarises the amount of rows to have the amount of tweets per Month
timegraph_rel_tweets <- related_tweets%>%
  group_by(Month_Yr)%>%
  summarise(N_tweets = n())

timegraph_df <- df%>%
  group_by(Month_Yr)%>%
  summarise(N_tweets = n())

timegraph_mentions <- mention_foxnews%>%
  group_by(Month_Yr)%>%
  summarise(N_tweets = n())

#Related Tweets x100 to make it to scale for the graph
#Make dataframe ready for graph by merging it to necessary columns and making it long
timegraph_amount <- merge(timegraph_rel_tweets, timegraph_df, by="Month_Yr")%>%
  rename(Related_Tweets = N_tweets.x, Total_Tweets = N_tweets.y)%>%
  mutate(Related_Tweets = Related_Tweets * 100)%>%
  pivot_longer(cols = c("Related_Tweets", "Total_Tweets"), names_to = "Tweets", values_to = "count")
View(timegraph_amount)

#Plotting the amount of tweets related to FoxNews and in total over time
#second sclae is *0.01 to rescale the Related Tweets to the appropiate number
time_tweets <- ggplot(timegraph_amount, aes(x = Month_Yr, y = count, group = Tweets, color = Tweets))+
  geom_line()+
  labs(x = "Month-Year", y = "Total Tweets", title = "Total tweets and Fox related Tweets")+
  scale_x_discrete(breaks = c('2019-01', '2019-07', '2020-01', '2020-07', '2021-01','2021-07','2022-01', '2022-07'))+
  scale_y_continuous(sec.axis = sec_axis(~ . * 0.01, name = "No of related tweets"))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
time_tweets

#same thing for the mentions with different parameters --> 300
timegraph_mentionsfox <- merge(timegraph_mentions, timegraph_df, by="Month_Yr")%>%
  rename(Mentions_Tweets = N_tweets.x, Total_Tweets = N_tweets.y)%>%
  mutate(Mentions_Tweets = Mentions_Tweets * 300)%>%
  pivot_longer(cols = c("Mentions_Tweets", "Total_Tweets"), names_to = "Tweets", values_to = "count")

time_mentions <- ggplot(timegraph_mentionsfox, aes(x = Month_Yr, y = count, group = Tweets, color = Tweets))+
  geom_line()+
  labs(x = "Month-Year", y = "Total Tweets", title = "Total tweets and Fox mentions")+
  scale_x_discrete(breaks = c('2019-01', '2019-07', '2020-01', '2020-07', '2021-01','2021-07','2022-01', '2022-07'))+
  scale_y_continuous(sec.axis = sec_axis(~ . * 0.00333333, name = "No of Mentions"))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
time_mentions



##### Barchart for number of tweets per commentator
com_barchart <- commentators%>%
  group_by(commentator)%>%
  summarise(mentions = n())
View(com_barchart)

com_barchartplot <- ggplot(com_barchart, aes(x = commentator, y = mentions))+
  geom_bar(stat = "identity")+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
  labs(x = "Anchor", y = "Mentions", title = "Times an Anchor was mentioned")
com_barchartplot


######### Bar chart with average polarity per commentator
graph_commentators <- commentators%>%
  select(commentator, polarity)%>%
  group_by(commentator)%>%
  summarise(Average_Polarity = mean(polarity))

plot_commentators <- ggplot(graph_commentators, aes(x = commentator, y = Average_Polarity))+
  geom_bar(stat = 'identity')+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
  labs(x = "Anchor", y = "Average Polarity", title = "Average Polarity When Mentioning Commentator")
plot_commentators


########### Graph with % of total tweets being from fox news
to_merge <- list(timegraph_df, timegraph_mentions, timegraph_rel_tweets)%>%
  reduce(inner_join, by="Month_Yr")%>%
  rename(Mentions_Tweets = N_tweets.y, Total_Tweets = N_tweets.x, Related_Tweets = N_tweets)

percentage_mentions <- to_merge %>% 
  mutate(Percentage_Mentions = (Mentions_Tweets / Total_Tweets) * 100,
         Percentage_Related_Tweets = (Related_Tweets / Total_Tweets) * 100)%>%
  select(Month_Yr, Percentage_Mentions, Percentage_Related_Tweets)%>%
  pivot_longer(cols = c("Percentage_Mentions", "Percentage_Related_Tweets"), names_to = "Tweets", values_to = "count")

graph_percentage <- ggplot(percentage_mentions, aes(x = Month_Yr, y = count, group = Tweets, color = Tweets))+
  geom_line()+
  labs(x = "Month-Year", y = "Percentage Mentions", title = "Percentage of Fox Mentions and Related Tweets")+
  scale_x_discrete(breaks = c('2019-01', '2019-07', '2020-01', '2020-07', '2021-01','2021-07','2022-01', '2022-07'))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
graph_percentage

######### Graph of total tweets by party, also percentage related to fox news

#total tweets per Senator
total_tweets <- df%>%
  group_by(user_screen_name)%>%
  summarise(N_tweets = n())


#adds total tweets column to sen_infoFINAL
prep_partytweets <- inner_join(sen_infoFINAL, total_tweets, by="user_screen_name")%>%
  mutate(Total_Tweets = sum(N_tweets))

fulldf <- full_join(prep_partytweets, df, by="user_screen_name")%>%  
  group_by(Party, Month_Yr)%>%
  mutate(Tweets_per_Party = n(),
         Total_Fox = times_mentioning_fox + times_mentioning_related_fox,
         Percentage_Fox = (Total_Fox/Tweets_per_Party) * 100)%>%
  ungroup()
View(fulldf)

#plotting
partygraph <- fulldf %>%
  select(Month_Yr, Party, Total_Fox)%>%
  group_by(Month_Yr, Party)%>%
  summarise(Total_Fox = mean(Total_Fox))%>%
  pivot_longer(cols = "Total_Fox", names_to = "Tweets", values_to = "count")

final_partygraph <- ggplot(partygraph, aes(x = Month_Yr, y = count, group = Party, color = Party))+
  geom_line()+
  labs(x = "Month-Year", y = "No of Tweets", title = "Number of Tweets Relating to Fox per Party")+
  scale_x_discrete(breaks = c('2019-01', '2019-07', '2020-01', '2020-07', '2021-01','2021-07','2022-01', '2022-07'))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
  facet_zoom(y = Party == c("D","I"), zoom.size = 1)+
  scale_color_manual(values=c('Blue','Green', 'Red'))
final_partygraph


########## Regression Graph with average polarity and the connection
connection_polarity <- fulldf%>%
  select(user_screen_name, polarity, Party, norm_fox_score)%>%
  group_by(user_screen_name, Party)%>%
  summarise(Polarity = mean(polarity),
            Connection = mean(norm_fox_score) * 100)
View(connection_polarity)

plot_conpol <- ggplot(connection_polarity, aes(x = Connection, y = Polarity, color = Party))+
  geom_point()+
  geom_smooth(method = "lm", se = FALSE)+
  scale_color_manual(values = c('Blue','Green', 'Red'))+
  geom_text_repel(data=subset(connection_polarity, Connection > 45 | Polarity < 0.07 | Polarity > 0.25),
                  aes(label=user_screen_name),hjust="inward", vjust="center", size = 3,
                  min.segment.length = unit(0, 'lines'),
                  show.legend = FALSE)
plot_conpol

########### Time-line with development of polarity
#disregarded Independent Senator since made for harder readability and very volatile polarity
polarity_timeline <- fulldf %>%
  select(Month_Yr, Party, polarity)%>%
  filter(Party != "I")%>%
  group_by(Month_Yr, Party)%>%
  summarise(Average_Polarity = mean(polarity))%>%
  pivot_longer(cols = "Average_Polarity", names_to = "Tweets", values_to = "count")
View(polarity_timeline)

plot_polarity <- ggplot(polarity_timeline, aes(x = Month_Yr, y = count, group = Party, color = Party))+
  geom_line()+
  labs(x = "Month-Year", y = "Average Polarity", title = "Average Polarity over Time")+
  scale_x_discrete(breaks = c('2019-01', '2019-07', '2020-01', '2020-07', '2021-01','2021-07','2022-01', '2022-07'))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
  scale_color_manual(values=c('Blue', 'Red'))
plot_polarity

######### Bar chart average polarity of mentions and related tweets
#combining and created columns to show which exact tweets mention Fox, are related or are unrelated
prep_avgpol <- rbind(mention_foxnews, related_tweets)
l <- prep_avgpol$...1
l
df2 <- df[!(row.names(df) %in% l),]
df3 <- df[ ! df2$...1 %in% l, ]
View(df3)
prep_avgpol$Related_Fox <- 'Related' 
prep_avgpol <- prep_avgpol%>%
  select(Month_Yr, polarity, Related_Fox, text)

df3$Related_Fox <- 'Unrelated'
prep_df <- df3%>%
  select(Month_Yr, polarity, Related_Fox, text)

relunrel <- rbind(prep_avgpol, prep_df)
View(relunrel)

final_relunrel <- relunrel%>%
  select(Month_Yr, Related_Fox, polarity)%>%
  group_by(Month_Yr, Related_Fox, )%>%
  summarise(avg_polarity = mean(polarity))%>%
  pivot_longer(cols = "avg_polarity", names_to = "Relation", values_to = "Count")
View(final_relunrel)

#create the plot
plot_relunrel <- ggplot(final_relunrel, aes(x = Month_Yr, y = Count, group = Related_Fox, color = Related_Fox))+
  geom_line()+
  labs(x = "Month-Year", y = "Average Polarity", title = "Average Polarity over Time by Relation to Fox")+
  scale_x_discrete(breaks = c('2019-01', '2019-07', '2020-01', '2020-07', '2021-01','2021-07','2022-01', '2022-07'))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
plot_relunrel



##################################################################################################

###Regressions analysis


#QUESTION 1: How much does the exposure to Fox News twitter content influence the polarity 
#of a politicians tweets?

#make dummy out of Party affiliation --> drop Independent
regression <- sen_infoFINAL%>%
  select(user_screen_name, avg_polarity, norm_fox_score, Party, norm_popularity, Religion, sd_polarity)%>%
  filter(Party != 'I')%>%
  mutate(Party = ifelse(Party == "R", 1, 0))
View(regression)

#Regression 1
Q1.1_model <- lm(avg_polarity ~ norm_fox_score + as.factor(Religion) + Party + norm_popularity, data = regression)
summ(Q1.1_model)



#QUESTION 2: What is the effect of mentioning Fox News in a post on the tweets polarity?

#creating new columns to see if tweets mention, relate to Fox or not
mention_foxnews$Mentions <- 1
related_tweets$Mentions <- 0
mention_foxnews$Related <- 0 
related_tweets$Related <- 1
df3$Mentions <- 0
df3$Related <- 0

#combine the datasets with the rest on necessary data
full_mention <- full_join(mention_foxnews, sen_infoFINAL, by="user_screen_name")
full_related <- full_join(related_tweets, sen_infoFINAL, by="user_screen_name")
full_prep3 <- full_join(df3, sen_infoFINAL, by="user_screen_name")
full_prep3$norm_popularity <- full_prep3$norm_popularity.x

#combine the three datasets with only the variables necessary for the regression
prep_mention <- full_mention%>%
  select(polarity, Mentions, Related, Religion, norm_popularity, Party, norm_fox_score)

prep_related <- full_related%>%
  select(polarity, Mentions, Related, Religion, norm_popularity, Party, norm_fox_score)

prep_df3 <- full_prep3%>%
  select(polarity, Mentions, Related, Religion, norm_popularity, Party, norm_fox_score)

regmrp <- rbind(prep_mention, prep_related, prep_df3)

#regression
Q2.1model <- lm(polarity ~ Mentions + Related + as.factor(Religion) + norm_popularity + Party, data=regmrp)
summ(Q2.1model)








