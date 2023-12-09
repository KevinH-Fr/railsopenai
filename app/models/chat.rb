class Chat < ApplicationRecord
  belongs_to :user

  attr_accessor :message 

  def message=(message)
    messages = [
      { 'role' => 'system', 'content' => message }
    ]

    response_raw = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages:,
        temperature: 0.7,
        max_tokens: 500,
        top_p: 1
      }
    )

    Rails.logger.debug response_raw
    
    response = JSON.parse(response_raw.to_json, object_class: OpenStruct)
    self.q_and_a << [message, response.choices[0].message.content]
    
  end

  private 

  def client
    OpenAI::Client.new
  end
end
