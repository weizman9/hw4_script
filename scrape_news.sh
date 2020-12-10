#!/bin/bash

#def var for website.
site=https://www.ynetnews.com/category/3082
artic="https://www.ynetnews.com/article/[a-zA-Z0-9]\{9\}[^a-zA-Z0-9]"
artic2="https://www.ynetnews.com/article/[a-zA-Z0-9]\{9\}"

# read website
wget -q $site -O tmp_site.txt

#search links with pattern define before
grep -o $artic tmp_site.txt | grep -o $artic2 > tmp_links.txt

#sort & uniq the links & save 
sort tmp_links.txt | uniq > tmp_links_uniq.txt

#read the file & count the links
cat tmp_links_uniq.txt | wc -l > results.csv

#read every link and count the words
for link in $(cat tmp_links_uniq.txt); do

	#read an article from a link & save
	wget -q $link -O tmp_appear.txt

	#save the number of names appear
	Netanyahu_cont=$(grep -o Netanyahu tmp_appear.txt | wc -l)
	Gantz_cont=$(grep -o Gantz tmp_appear.txt | wc -l)

	#print the links to output
	echo -n "$link, " >> results.csv

	#check if the names exist
	if (( Netanyahu_cont == 0 && Gantz_cont == 0 ))
	#if the names not exist print "-"
	then
		echo "-" >> results.csv
	#if one of the names exist print the num of appears
	else
		echo -n "Netanyahu, $Netanyahu_cont, " >> results.csv
		echo "Gantz, $Gantz_cont" >> results.csv
	fi
	
done

#remove temp files
find | grep tmp | xargs rm
