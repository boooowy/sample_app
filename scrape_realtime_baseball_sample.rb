# -*- encoding: utf-8 -*-
require 'open-uri'
require 'nokogiri'


def scrapeGameDetail(url)

	charset = nil
	html = open(url) do |f|
	  charset = f.charset # 文字種別を取得
	  f.read # htmlを読み込んで変数htmlに渡す
	end

	# htmlをパース(解析)してオブジェクトを作成
	doc = Nokogiri::HTML.parse(html, nil, charset)
	iningList = [];
	topTeamScore = {};
	bottomTeamScore = {};
	gameDetailHash = {}
	gameDate = "";
	playballTime = "";
	# 対戦日付データの取得
	doc.css('div.h01_box div').each_with_index do  |each,i|
		gameDate = each.inner_text
	end
	doc.css('p.stadium').each_with_index do  |each,i|
		playballTime = each.inner_text
	end


	doc.css('div#scoreboard tr').each_with_index do  |tr,i|
		tr.css('th','td').each_with_index do |th,ining_index| 
			if  i == 0
				# make iningList
				if /^[0-9]{1,}/=~th.inner_text
					iningList.push(th.inner_text)
				end
			elsif i == 1

				if ining_index == 0
					topTeamScore['name'] = th.inner_text;
				elsif iningList.include?(ining_index.to_s)
					topTeamScore[ining_index.to_s] = th.inner_text
				else
					if iningList.max.to_i == ining_index -1 
						topTeamScore['hit_count'] = th.inner_text
					elsif iningList.max.to_i == ining_index -2
						topTeamScore['error_count'] = th.inner_text
					end
				end
			else
				if ining_index == 0
					bottomTeamScore['name'] = th.inner_text;
				elsif iningList.include?(ining_index.to_s)
					bottomTeamScore[ining_index.to_s] = th.inner_text
				else
					if iningList.max.to_i == ining_index -1 
						bottomTeamScore['hit_count'] = th.inner_text
					elsif iningList.max.to_i == ining_index -2
						bottomTeamScore['error_count'] = th.inner_text
					end
				end

			end
		end
	end
	gameDetailHash['gameDate'] = gameDate;
	gameDetailHash['playballTime'] = playballTime;
	gameDetailHash['topTeamScore'] = topTeamScore;
	gameDetailHash['bottomTeamScore'] = bottomTeamScore;

	p gameDetailHash
end
	

	BASE_URL = "http://baseball.yahoo.co.jp";


	url = BASE_URL + "/npb/";
	charset = nil
	html = open(url) do |f|
	  charset = f.charset # 文字種別を取得
	  f.read # htmlを読み込んで変数htmlに渡す
	end

	# htmlをパース(解析)してオブジェクトを作成
	doc = Nokogiri::HTML.parse(html, nil, charset)
	urlList = [];
	doc.css('.teams .score .end  a').each_with_index do  |atag,i|
		
		urlList.push(atag.attribute("href").value())
#			p atag.attribute('href').value()
		
	end
urlList.each do |gameDetailUrlPath|
scrapeGameDetail(BASE_URL  + gameDetailUrlPath)	
end

