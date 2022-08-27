#!/usr/bin/ruby -w
require 'openssl'
require 'json'
require 'net/http'
require 'uri'

load 'sign.rb'
# 定义类
class Client
   # 构造函数
   def initialize( app_id, app_key, domain='https://api.mianbaoduo.com')
      @app_id, @app_key, @domain = app_id, app_key, domain
   end
 
  def _handle_req(hashobj)
     hashobj['app_id']=@app_id
     hashobj['sign']= SignModule.sign(hashobj,@app_key)
     return hashobj
  end   
  def send_post(url,toSend)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == "https"
       http.use_ssl = true
         http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
     end
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    req.body = JSON.generate( toSend)
    puts req.body
    res = http.request(req)
    return JSON.parse res.body
   end
    private :_handle_req, :send_post
    def alipay(hashobj)
        """
        see：https://doc.mbd.pub/api/zhi-fu-bao-zhi-fu
        :param  has: AliPayReq required fields
            and optional `requests.post`'s kwargs, e.g. timeout=5
        :return: AliPayRes
        """
        req = _handle_req(hashobj)
        api = @domain+'/release/alipay/pay'
        res = send_post(api, req )

        return  res
    end

    def wx_h5(hashobj) 
        """
        see：https://doc.mbd.pub/api/wei-xin-h5-zhi-fu
        :param kwargs: WeChatH5Req required fields
            and optional `requests.post`'s kwargs, e.g. timeout=5
        :return: WeChatH5Res
        """
        req = _handle_req(hashobj)
        api = @domain+'/release/wx/prepay'
        res = send_post(api, req)
        return res

    end


     def wx_jsapi(hashobj) 
        """
        see：https://doc.mbd.pub/api/wei-xin-zhi-fu
        :param kwargs: WeChatJSApiReq required fields
        :return: 
        """
        req = _handle_req(hashobj)
        api = @domain+'/release/wx/prepay'
        res = send_post(api, req)

        return res
    end
    def get_openid_redirect_url(hashobj)
        """
        see：https://doc.mbd.pub/api/huo-qu-yong-hu-openid
        :param kwargs: GetOpenIdReq required fields
        :return: redirect_url
        """
        req = _handle_req(hashobj)
        base_url = 'https://mbd.pub/openid'
        params =send_post(base_url,req)
        puts params
        return base_url+URI::encode(params)
    end
      def refund(hashobj) 
        """
        see: https://doc.mbd.pub/api/tui-kuan
        :param kwargs: RefundReq required fields
            and optional `requests.post`'s kwargs, e.g. timeout=5
        :return: RefundRes
        """
        req = _handle_req(hashobj)
        api = @domain+'/release/main/refund'
        res = send_post(api, req)
        return res
    end
    def search_order(hashobj) 
        """
        see: https://doc.mbd.pub/api/ding-dan-cha-xun
        :param kwargs: SearchOrderReq required fields
            and optional `requests.post`'s kwargs, e.g. timeout=5
        :return: SearchOrderRes
        """
        req = _handle_req(hashobj)
        api = @domain+'release/main/search_order'
        res = send_post(api, req)
        return res
    end
end
