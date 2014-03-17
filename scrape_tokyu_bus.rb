require 'open-uri'
require 'nokogiri'

# スクレイピング先のURL
url = 'http://tokyu.bus-location.jp/blsys/navi?VID=rsc&EID=nt&FID=&SID=&PRM=&SCT=2&DSMK=2336&DSN=%E6%B8%8B%E8%B0%B7%E9%A7%85&ASMK=2340&ASN=%E6%B1%A0%E5%B0%BB&FDSN=0&FASN=0&CTYP=0&RAMK=1&PGL=3&ARC=20&ART=0'

charset = nil
html = open(url) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを作成
doc = Nokogiri::HTML.parse(html, nil, charset)
hoge = doc.search('//table[@class="routeListTbl"]/tr')
p hoge.size

doc.xpath('//table[@class="routeListTbl"]/tr').each do |tr|
	busStop = tr.search('td[@class="stopName"]')
	if !busStop.empty? then
			p busStop.inner_text
	end
	realtimeName = tr.search('dl[@class="clearfix"]/dd')
	if !realtimeName.inner_text.empty? then

			p 'BusLocation::' + realtimeName.inner_text
			
	end

#	realTimeLocation = tr.search('//dl[@class="clearfix"]')


	# p busStop.size
	# p realTimeLocation.size
	#node.xpath('//tr').each do |node1|
		# if node1.attribute('class') == 'trEven' then

		# else 
		# 	node1.xpath('//td[@class="stopName"]').each do |busStopName|
		# 		p busStopName.inner_text
		# 	end 
		# end
		# node1.xpath('//td[@class="stopName"]').each do |node2|
		# 	p node2.inner_text 
		# end
#	end

end

# doc.xpath('//td[@class="stopName"]').each do |node|
#   # tilte
#   #p node.inner_text

#   # 記事のサムネイル画像
# #  p node.css('img').attribute('src').value

#   # 記事のサムネイル画像
#  # p node.css('a').attribute('href').value
# end

# doc.xpath('//dl[@class="clearfix"]/dd').each do |node|
# 	p node.inner_text
# end