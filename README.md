# mbdpay
A rubyclient/sdk for mbdpay api

# demo
load 'Client.rb'
client = Client.new( "194024590982810" , "920ee68b4e16df01d0cd6b2ca161195d")
 
# 使用alipay接口
res = client.alipay ( Hash["description" => "测试内容 描述",  "amount_total"=>1] )
puts res
