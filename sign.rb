#!/usr/bin/ruby -w
require 'digest'

module SignModule
    def self.sign(attributes,payjs_key)
        sign_str= attributes.sort.to_h.map {|h| h.join '=' }.join '&'
        return  Digest::MD5.hexdigest( sign_str + '&key=' + payjs_key)
    end
end
