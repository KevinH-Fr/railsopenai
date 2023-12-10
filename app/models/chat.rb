class Chat < ApplicationRecord
  belongs_to :user

  attr_accessor :message 

  def message=(message)
      messages = [
        { 'role' => 'system', 'content' => message }
      ]
      
      q_and_a.each do |question, answer| 
        messages << { 'role' => 'user', 'content' => question }
        messages << { 'role' => 'assistant', 'content' => answer }
      end
    
    response_raw = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages:,
        temperature: 0.7,
        max_tokens: 500,
        top_p: 1
      }
    )

    self.history = { 'history' => [] } if history.blank?
    self.history['history'] << response_raw 

    #Rails.logger.debug response_raw
    response = JSON.parse(response_raw.to_json, object_class: OpenStruct)
    self.q_and_a << [message, response.choices[0].message.content]
    
  end

  private 

  def client
    OpenAI::Client.new
  end
end
