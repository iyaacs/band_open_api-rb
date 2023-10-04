require 'pp'
require_relative '0_env'

# https://developers.band.us/develop/guide/api/get_post

# 글 상세 조회
# 특정 글의 상세정보를 조회합니다.

# ポストの詳細照会
# 特定のポストの詳細を照会。

params = {
    'band_key' => 'INPUT YOUR BAND KEY',
    'post_key' => 'INPUT YOUR POST KEY'
}
response = get_request('https://openapi.band.us/v2/band/post', params)
pp response

result_data = response['result_data']
properties = ['post']
puts validate?(result_data, properties)

post = result_data['post']
properties = ['created_at', 'comment_count', 'emotion_count', 'post_key', 'shared_count', 'author', 'photos', 'post_read_count', 'band_key', 'is_multilingual', 'content']
puts validate?(post, properties)